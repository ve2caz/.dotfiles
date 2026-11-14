#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
REPO_ROOT="${SCRIPT_DIR:h:h}"

# By default, stow the home package into a temporary HOME, so sessions never write into the repo.
TEST_HOME="${TEST_HOME:-}"
TEST_ZDOTDIR="${TEST_ZDOTDIR:-}"
MAX_MISE_INDEX="${MAX_MISE_INDEX:-5}"

PATH_DUMP_CMD='print -r -- "__PATH_START__"; echo "$PATH" | tr ":" "\n"; print -r -- "__PATH_END__"'

run_session_test() {
    local session_name="$1"
    shift

    local output
    local -a shell_args=("$@")
    local temp_root
    temp_root="$(mktemp -d)"
    local session_home="${TEST_HOME:-$temp_root/home}"
    if [[ -z "$TEST_HOME" ]]; then
        mkdir -p "$session_home/.config"
        while read -r d; do mkdir -p "$session_home/.config/$d"; done < "$REPO_ROOT/scripts/mixed-config-dirs.txt"
        stow -d "$REPO_ROOT" -t "$session_home" home
    fi

    print -r -- "=== ${session_name} ==="

    # A set SSH_AUTH_SOCK stops .zprofile from starting an ssh-agent that outlives the test.
    if ! output="$(
        env -i \
            HOME="$session_home" \
            ZDOTDIR="${TEST_ZDOTDIR:-$session_home}" \
            SSH_AUTH_SOCK="$temp_root/no-agent.sock" \
            XDG_CACHE_HOME="$temp_root/xdg-cache" \
            XDG_DATA_HOME="$temp_root/xdg-data" \
            XDG_STATE_HOME="$temp_root/xdg-state" \
            MISE_CACHE_DIR="$temp_root/mise-cache" \
            MISE_DATA_DIR="$temp_root/mise-data" \
            MISE_STATE_DIR="$temp_root/mise-state" \
            TERM="${TERM:-xterm-256color}" \
            zsh "${shell_args[@]}" -c "$PATH_DUMP_CMD" 2>&1
    )"; then
        print -u2 -r -- "FAIL: could not start session: ${session_name}"
        print -u2 -r -- "$output"
        rm -rf "$temp_root"
        return 1
    fi

    local line
    local in_path=0
    local -a path_entries=()
    local idx=0
    local mise_idx=0

    while IFS= read -r line; do
        if [[ "$line" == "__PATH_START__" ]]; then
            in_path=1
            continue
        fi
        if [[ "$line" == "__PATH_END__" ]]; then
            in_path=0
            break
        fi
        if (( in_path )) && [[ -n "$line" ]]; then
            path_entries+=("$line")
        fi
    done <<< "$output"

    if (( ${#path_entries[@]} == 0 )); then
        print -u2 -r -- "FAIL: no PATH entries captured for ${session_name}"
        print -u2 -r -- "$output"
        rm -rf "$temp_root"
        return 1
    fi

    print -r -- "PATH entries (in order encountered):"
    for line in "${path_entries[@]}"; do
        ((idx++))
        print -r -- "  ${idx}. ${line}"
        if (( mise_idx == 0 )) && [[ "$line" =~ 'mise.*/shims/?$' ]]; then
            mise_idx=$idx
        fi
    done

    if (( mise_idx == 0 )); then
        print -u2 -r -- "FAIL: mise shims not found in PATH for ${session_name}"
        rm -rf "$temp_root"
        return 1
    fi

    if (( mise_idx > MAX_MISE_INDEX )); then
        print -u2 -r -- "FAIL: mise shims found at position ${mise_idx}, expected <= ${MAX_MISE_INDEX} for ${session_name}"
        rm -rf "$temp_root"
        return 1
    fi

    print -r -- "PASS: mise shims is near the front at position ${mise_idx}"

    local -aU unique_entries=("${path_entries[@]}")
    if (( ${#path_entries} != ${#unique_entries} )); then
        print -u2 -r -- "FAIL: PATH lists a folder twice for ${session_name}"
        rm -rf "$temp_root"
        return 1
    fi
    print -r -- "PASS: no folder twice in PATH"
    print
    rm -rf "$temp_root"
}

# A zsh started inside another environment, in each session type: a folder its parent put in front
# of PATH stays right behind the shims, a mise version folder does not come back in front, nothing
# is listed twice in any search path, and a missing LANG gets the same region as in a non-login shell.
run_inherited_test() {
    local session_name="$1"
    shift
    local temp_root
    temp_root="$(mktemp -d)"
    local session_home="$temp_root/home"
    mkdir -p "$session_home/.config" "$temp_root/venv/bin" "$temp_root/mise-data/installs/tool/1/bin"
    while read -r d; do mkdir -p "$session_home/.config/$d"; done < "$REPO_ROOT/scripts/mixed-config-dirs.txt"
    stow -d "$REPO_ROOT" -t "$session_home" home

    print -r -- "=== inherited PATH, ${session_name} ==="
    local probe='
        dups() { local -aU u=("$@"); print -r -- $(( $# - ${#u} )); }
        print -r -- "__POS__${path[(i)*/venv/bin]}|${path[(i)*/mise-data/shims]}|${path[(i)*/installs/tool/1/bin]}|${path[(i)/usr/bin]}"
        print -r -- "__DUP__$(dups $path)|$(dups $fpath)|$(dups ${(s.:.)MANPATH})|$(dups ${(s.:.)INFOPATH})"
        print -r -- "__LANG__${LANG-}"'
    local -a lines out
    lines=("${(@f)$(
        env -i \
            HOME="$session_home" \
            ZDOTDIR="$session_home" \
            SSH_AUTH_SOCK="$temp_root/no-agent.sock" \
            XDG_CACHE_HOME="$temp_root/xdg-cache" \
            XDG_DATA_HOME="$temp_root/xdg-data" \
            XDG_STATE_HOME="$temp_root/xdg-state" \
            MISE_CACHE_DIR="$temp_root/mise-cache" \
            MISE_DATA_DIR="$temp_root/mise-data" \
            MISE_STATE_DIR="$temp_root/mise-state" \
            TERM="${TERM:-xterm-256color}" \
            PATH="$temp_root/mise-data/installs/tool/1/bin:$temp_root/venv/bin:/usr/bin:/bin:/usr/bin" \
            INFOPATH="/opt/homebrew/share/info:/opt/homebrew/share/info:" \
            FPATH="/opt/homebrew/share/zsh/site-functions:/opt/homebrew/share/zsh/site-functions" \
            zsh "$@" -c "$probe" 2>/dev/null
    )}")
    rm -rf "$temp_root"
    # Interactive startup can print its own text first, even on the same line, so take each result
    # by its prefix.
    out=('' '' '')
    local line
    for line in "${lines[@]}"; do
        case $line in
            (*__POS__*) out[1]=${line#*__POS__} ;;
            (*__DUP__*) out[2]=${line#*__DUP__} ;;
            (*__LANG__*) out[3]=${line#*__LANG__} ;;
        esac
    done

    local -a pos=("${(@s:|:)out[1]}") dup=("${(@s:|:)out[2]}")
    local failed=0
    if (( pos[1] != pos[2] + 1 )); then
        print -u2 -r -- "FAIL: the inherited venv folder is at ${pos[1]}, expected right behind the shims at ${pos[2]}"
        failed=1
    fi
    if (( pos[3] < pos[4] )); then
        print -u2 -r -- "FAIL: an inherited mise version folder is at ${pos[3]}, in front of /usr/bin at ${pos[4]}"
        failed=1
    fi
    if [[ ${out[2]} != '0|0|0|0' ]]; then
        print -u2 -r -- "FAIL: folders listed twice (PATH|fpath|MANPATH|INFOPATH): ${out[2]}"
        failed=1
    fi
    if [[ ${out[3]} != *.UTF-8 || ${out[3]} == C.UTF-8 ]]; then
        print -u2 -r -- "FAIL: with no LANG, the shell set '${out[3]}', expected the region's UTF-8 locale"
        failed=1
    fi
    (( failed )) && return 1
    print -r -- "PASS: venv folder right behind the shims, mise version folder behind the system, no duplicates, LANG ${out[3]}"
    print
}

failures=0

run_session_test "interactive login" -i -l || failures=$((failures + 1))
run_session_test "interactive non-login" -i || failures=$((failures + 1))
run_session_test "non-interactive login" -l || failures=$((failures + 1))
run_session_test "non-interactive non-login" || failures=$((failures + 1))
run_inherited_test "interactive login" -i -l || failures=$((failures + 1))
run_inherited_test "interactive non-login" -i || failures=$((failures + 1))
run_inherited_test "non-interactive login" -l || failures=$((failures + 1))
run_inherited_test "non-interactive non-login" || failures=$((failures + 1))

if (( failures > 0 )); then
    print -u2 -r -- "${failures} session test(s) failed"
    exit 1
fi

print -r -- "All session tests passed"