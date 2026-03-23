#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
REPO_ROOT="${SCRIPT_DIR:h:h}"

# By default, run against this repository's zsh config.
TEST_HOME="${TEST_HOME:-$REPO_ROOT}"
TEST_ZDOTDIR="${TEST_ZDOTDIR:-$REPO_ROOT}"
MAX_MISE_INDEX="${MAX_MISE_INDEX:-5}"

PATH_DUMP_CMD='print -r -- "__PATH_START__"; echo "$PATH" | tr ":" "\n"; print -r -- "__PATH_END__"'

run_session_test() {
    local session_name="$1"
    shift

    local output
    local -a shell_args=("$@")
    local temp_root
    temp_root="$(mktemp -d)"

    print -r -- "=== ${session_name} ==="

    if ! output="$(
        env -i \
            HOME="$TEST_HOME" \
            ZDOTDIR="$TEST_ZDOTDIR" \
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
    print
    rm -rf "$temp_root"
}

failures=0

run_session_test "interactive login" -i -l || ((failures++))
run_session_test "interactive non-login" -i || ((failures++))
run_session_test "non-interactive login" -l || ((failures++))
run_session_test "non-interactive non-login" || ((failures++))

if (( failures > 0 )); then
    print -u2 -r -- "${failures} session test(s) failed"
    exit 1
fi

print -r -- "All session tests passed"