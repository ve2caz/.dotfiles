#!/usr/bin/env zsh
# Proves the key bindings in the cheat sheets. Drives a real interactive zsh, built from the home
# package in a temporary HOME, through a pseudo terminal. A stub fzf records how it was called and
# picks a canned line, so fzf-driven keys run without a human.
#
# Results: PASS, FAIL, XFAIL (known broken, has a reason), XPASS (marked broken but now works: remove
# the marker), SKIP (tool missing). Exits 1 on FAIL or XPASS.

set -uo pipefail
setopt extended_glob

zmodload zsh/zpty zsh/datetime zsh/zselect || { print -u2 "zsh/zpty, zsh/datetime and zsh/zselect are required"; exit 2 }

SCRIPT_DIR="${0:A:h}"
REPO_ROOT="${SCRIPT_DIR:h:h}"
REAL_DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
REAL_FZF="$(whence -p fzf)" || { print -u2 "fzf is required"; exit 2 }
SHEETS=(docs/zsh-keybindings.md docs/fzf-keybindings.md docs/fzf-git-keybindings.md)
SEP=$'\x1f'

# --- Spec ------------------------------------------------------------------------------------------
# Keys use bindkey notation: ^X is Ctrl-X, \ex is Alt-X (ESC then x), ^[[24~ is F12.
# names: the cheat sheet spellings this row covers, lowercased, separated by ";". Empty: not in a sheet.
# flags: herdr = taken by the herdr prefix inside herdr (accepted); wait = pause before reading the
#   result, for keys that are a prefix of longer bindings and for fzf-tab, which reads typeahead into
#   its query; flow = needs zsh to read Ctrl-S.
# status: ok, or xfail:<reason>.

typeset -a ZLE_ROWS FZF_ROWS BIND_ROWS

# id names key widget typed buffer cursor flags status ("-" for cursor: not checked)
zle_row() { ZLE_ROWS+=("${(pj:\x1f:)@}") }
zle_row ctrl-a        'ctrl-a'        '^A'   beginning-of-line                 'aa bb^A'             'aa bb'       0 ''    ok
zle_row ctrl-e        'ctrl-e'        '^E'   end-of-line                       'aa bb^A^E'           'aa bb'       5 ''    ok
zle_row ctrl-b        'ctrl-b'        '^B'   backward-char                     'abc^B'               'abc'         2 herdr ok
zle_row ctrl-f        'ctrl-f'        '^F'   forward-char                      'abc^A^F'             'abc'         1 ''    ok
zle_row alt-b         'alt-b'         '\eb'  backward-word                     'aa bb\eb'            'aa bb'       3 ''    ok
zle_row alt-f         'alt-f'         '\ef'  forward-word                      'aa bb^A\ef'          'aa bb'       3 ''    ok
zle_row ctrl-d        'ctrl-d'        '^D'   delete-char-or-list               'abc^A^D'             'bc'          0 ''    ok
zle_row ctrl-h        'ctrl-h'        '^H'   backward-delete-char              'abc^H'               'ab'          2 ''    ok
zle_row alt-d         'alt-d'         '\ed'  kill-word                         'aa bb^A\ed'          ' bb'         0 ''    ok
zle_row alt-backspace 'alt-backspace' '^[^?' backward-kill-word                'aa bb^[^?'           'aa '         3 ''    ok
zle_row ctrl-k        'ctrl-k'        '^K'   kill-line                         'aa bb^A^F^F^K'       'aa'          2 ''    ok
zle_row ctrl-u        'ctrl-u'        '^U'   backward-kill-line                'aa bb^B^B^U'         'bb'          0 ''    'xfail:zsh binds ^U to kill-whole-line, which also deletes after the cursor; the sheet says to the beginning of the line'
zle_row ctrl-y        'ctrl-y'        '^Y'   yank                              'aa bb^[^?^Y'         'aa bb'       5 ''    ok
zle_row alt-y         'alt-y'         '\ey'  yank-pop                          'alpha^A^K^[[23~beta^A^K^[[23~^Y\ey' 'alpha' 5 '' ok
zle_row alt-w         'alt-w'         '\ew'  kill-region                       'aa bb^A^@^F^F^F\ew'  'bb'          0 ''    ok
zle_row alt-t         'alt-t'         '\et'  transpose-words                   'aa bb\et'            'bb aa'       5 ''    ok
zle_row ctrl-s        'ctrl-s'        '^S'   history-incremental-search-forward '^S'                 ''            - flow  'xfail:flow control is on (zsh option flow_control), so the terminal pauses output instead'
zle_row ctrl-p        'ctrl-p'        '^P'   history-search-backward           'echo^P'              'echo kb-two' - ''    ok
zle_row ctrl-n        'ctrl-n'        '^N'   history-search-forward            'echo^P^P^N'          'echo kb-two' - ''    ok
zle_row ctrl-g        'ctrl-g'        '^G'   send-break                        'aa bb^G'             ''            0 wait  ok
zle_row ctrl-l        'ctrl-l'        '^L'   clear-screen                      'aa bb^L'             'aa bb'       5 ''    ok

# id names key widget typed pick expect options flags status
# pick: pattern the stub fzf selects. expect: the resulting buffer, a pattern if it starts with "~",
# or "pwd:<dir>" for the folder the shell must be in. options: text fzf must have been given.
# @HASH@ is replaced with the short hash of the test repo's last commit.
fzf_row() { FZF_ROWS+=("${(pj:\x1f:)@}") }
fzf_row ctrl-t       'ctrl-t'         '^T'   fzf-file-widget             'vim ^T'       'tracked.txt'      'vim tracked.txt '  'eza --tree'       ''   ok
fzf_row ctrl-r       'ctrl-r'         '^R'   fzf-history-widget          '^R'           '*echo kb-one'     'echo kb-one'       '--scheme=history' ''   ok
fzf_row alt-c        'alt-c'          '\ec'  fzf-cd-widget               '\ec'          'kbdir(|/)'        'pwd:kbdir'         'eza --tree'       ''   ok
fzf_row cd-star      'cd **tab'       '^I'   fzf-completion              'cd **^I'      '(./|)kbdir(|/)'   '~cd (./|)kbdir/*'  'eza --tree'       ''   ok
fzf_row export-star  'export **tab'   '^I'   fzf-completion              'export **^I'  'HOME'             '~export HOME*'     'echo'             ''   ok
fzf_row unset-star   'unset **tab'    '^I'   fzf-completion              'unset **^I'   'HOME'             '~unset HOME*'      'echo'             ''   ok
fzf_row unalias-star 'unalias **tab'  '^I'   fzf-completion              'unalias **^I' 'lg'               '~unalias lg*'      ''                 ''   ok
fzf_row ssh-star     'ssh **tab'      '^I'   fzf-completion              'ssh **^I'     'localhost'        '~ssh localhost*'   'dig'              ''   ok
fzf_row kill-star    'kill -9 **tab'  '^I'   fzf-completion              'kill -9 **^I' '*zsh*'            '~kill -9 <->*'     ''                 ''   ok
fzf_row vim-star     'vim **tab'      '^I'   fzf-completion              'vim **^I'     '(./|)tracked.txt' '~vim (./|)tracked.txt*' 'bat -n'      ''   ok
fzf_row cat-star     'cat **tab'      '^I'   fzf-completion              'cat **^I'     '(./|)tracked.txt' '~cat (./|)tracked.txt*' 'bat -n'      ''   ok
fzf_row fzf-tab      ''               '-'    -                           'cd kb^I^I'    '*kbdir2*'         '~cd kbdir2/*'      '--expect'         wait ok
fzf_row git-files    'ctrl-gf'        '^G^F' fzf-git-files-widget        '^G^F'         '*tracked.txt*'    '~*tracked.txt*'    ''                 ''   ok
fzf_row git-branches 'ctrl-gb'        '^G^B' fzf-git-branches-widget     '^G^B'         '*kb-branch*'      '~*kb-branch*'      ''                 ''   ok
fzf_row git-tags     'ctrl-gt'        '^G^T' fzf-git-tags-widget         '^G^T'         '*kb-tag*'         '~*kb-tag*'         ''                 ''   ok
fzf_row git-remotes  'ctrl-gr'        '^G^R' fzf-git-remotes-widget      '^G^R'         '*kb-remote*'      '~*kb-remote*'      ''                 ''   ok
fzf_row git-hashes   'ctrl-gh'        '^G^H' fzf-git-hashes-widget       '^G^H'         '*kb commit two*'  '~*@HASH@*'         ''                 ''   ok
fzf_row git-stashes  'ctrl-gs'        '^G^S' fzf-git-stashes-widget      '^G^S'         '*stash@{0}*'      'stash@\{0\} '      ''                 flow 'xfail:the chord ends in Ctrl-S, which flow control takes'
fzf_row git-reflogs  'ctrl-gl'        '^G^L' fzf-git-lreflogs-widget     '^G^L'         '*HEAD@{1}*'       'HEAD@\{1\} '       ''                 ''   ok
fzf_row git-worktree 'ctrl-gw'        '^G^W' fzf-git-worktrees-widget    '^G^W'         '*kb-worktree*'    '~*kb-worktree*'    ''                 ''   ok
fzf_row git-refs     'ctrl-ge'        '^G^E' fzf-git-each_ref-widget     '^G^E'         '*kb-tag*'         '~*kb-tag*'         ''                 ''   ok

# id names fzf-keys action flags status
# Keys handled inside fzf, read from FZF_DEFAULT_OPTS. action "default": the key must not be rebound.
bind_row() { BIND_ROWS+=("${(pj:\x1f:)@}") }
bind_row fzf-enter       'enter'                         'enter'              default         ''    ok
bind_row fzf-down        'ctrl-j;ctrl-n;down arrow'      'ctrl-j ctrl-n down' default         ''    ok
bind_row fzf-up          'ctrl-k;ctrl-p;up arrow'        'ctrl-k ctrl-p up'   default         ''    ok
bind_row fzf-mark        'tab;shift-tab'                 'tab btab'           default         ''    ok
bind_row fzf-toggle      '?;ctrl-/'                      '? ctrl-/'           toggle-preview  ''    ok
bind_row fzf-scroll-up   'shift-up'                      'shift-up'           preview-up      ''    ok
bind_row fzf-scroll-down 'shift-down'                    'shift-down'         preview-down    ''    ok
bind_row fzf-sideways    'shift-left;shift-right'        'shift-left shift-right' scroll-sideways '' 'xfail:the sheet says these scroll sideways; fzf cannot scroll the preview sideways and they page it'
bind_row fzf-page-up     'ctrl-b'                        'ctrl-b'             preview-page-up herdr ok
bind_row fzf-page-down   'ctrl-f'                        'ctrl-f'             preview-page-down ''  ok
bind_row fzf-line-ends   'ctrl-a;ctrl-e'                 'ctrl-a ctrl-e'      line-ends       ''    'xfail:the sheet says beginning or end of the preview line; they jump to the top and bottom of the preview'
bind_row fzf-query-keys  ''                              'ctrl-a ctrl-e ctrl-b ctrl-f ?' default '' 'xfail:these keys edit the fzf query and must not be rebound'

# --- Reporting -------------------------------------------------------------------------------------
typeset -i N_PASS=0 N_FAIL=0 N_XFAIL=0 N_XPASS=0 N_SKIP=0

# report <id> <status> <ok:0|1> <detail>
report() {
    local id=$1 st=$2 ok=$3 detail=$4
    if [[ $st == xfail:* ]]; then
        if (( ok )); then
            (( N_XPASS++ )); print -r -- "XPASS $id: marked broken but works now; remove the marker"
        else
            (( N_XFAIL++ )); print -r -- "XFAIL $id: ${st#xfail:} ($detail)"
        fi
    elif (( ok )); then
        (( N_PASS++ )); print -r -- "PASS  $id"
    else
        (( N_FAIL++ )); print -r -- "FAIL  $id: $detail"
    fi
}
skip() { (( N_SKIP++ )); print -r -- "SKIP  $1: $2" }

# --- Test fixtures ---------------------------------------------------------------------------------
TMP="$(mktemp -d)"
KB="$TMP/kb"
REPO="$TMP/repo"
# KB_KEEP=1 keeps the temporary folder for debugging.
cleanup() {
    zpty -d KBSH 2>/dev/null
    if [[ -n ${KB_KEEP-} ]]; then print -r -- "kept $TMP"; else rm -rf "$TMP"; fi
}
trap cleanup EXIT INT TERM

mkdir -p "$KB/stub" "$TMP/home/.config" "$TMP/xdg-cache" "$TMP/xdg-state/zsh" "$TMP/xdg-data/zinit"
while read -r d; do mkdir -p "$TMP/home/.config/$d"; done < "$REPO_ROOT/scripts/mixed-config-dirs.txt"
stow -d "$REPO_ROOT" -t "$TMP/home" home

# Plugins are linked, not copied: the session only reads them.
[[ -d "$REAL_DATA/zinit/zinit.git" ]] || { print -u2 "zinit is missing from $REAL_DATA; run scripts/setup.sh"; exit 2 }
for d in zinit.git plugins completions snippets; do
    [[ -e "$REAL_DATA/zinit/$d" ]] && ln -s "$REAL_DATA/zinit/$d" "$TMP/xdg-data/zinit/$d"
done
HAVE_FZF_GIT=0
if [[ -f "$REAL_DATA/fzf-git/fzf-git.sh" ]]; then
    ln -s "$REAL_DATA/fzf-git" "$TMP/xdg-data/fzf-git"
    HAVE_FZF_GIT=1
fi

print -l 'echo kb-one' 'ls' 'echo kb-two' > "$TMP/xdg-state/zsh/history"

g() { git -C "$REPO" -c user.name=kb -c user.email=kb@example.invalid -c init.defaultBranch=main "$@" >/dev/null 2>&1 }
mkdir -p "$REPO/kbdir" "$REPO/kbdir2"
print one > "$REPO/tracked.txt"
touch "$REPO/kbdir/.keep" "$REPO/kbdir2/.keep"
g init
g add -A
g commit -m 'kb commit one'
print two >> "$REPO/tracked.txt"
g commit -am 'kb commit two'
g branch kb-branch
g tag kb-tag
g remote add kb-remote "$TMP/remote.git"
print three >> "$REPO/tracked.txt"
g stash
g worktree add -b kb-wt "$TMP/kb-worktree"
HASH="$(git -C "$REPO" log -1 --format=%h)"

cat > "$KB/stub/fzf" <<EOF
#!/bin/zsh -f
setopt extended_glob
[[ \${1-} == --version ]] && exec ${(q)REAL_FZF} --version
all="\$FZF_DEFAULT_OPTS \${(j: :)@}"
print -r -- "\$all" >| ${(q)KB}/fzf-opts
print -r -- "\$all" >> ${(q)KB}/fzf-calls
pick="\$(<${(q)KB}/pick)"
typeset -a recs
# Like fzf, read the list from FZF_DEFAULT_COMMAND (or walk the folder) when input is the terminal.
if [[ -t 0 ]]; then
    exec < <(if [[ -n \${FZF_DEFAULT_COMMAND-} ]]; then eval "\$FZF_DEFAULT_COMMAND"; else command find . -mindepth 1 | sed 's|^\\./||'; fi)
fi
if [[ \$all == *--read0* ]]; then
    while IFS= read -r -d \$'\\0' r; do recs+=("\$r"); done
else
    while IFS= read -r r || [[ -n \$r ]]; do recs+=("\$r"); done
fi
[[ \$all == *--print-query* ]] && print -r -- "\${\${(M)@:#--query=*}#--query=}"
[[ \$all == *--expect* ]] && print
for r in "\${recs[@]}"; do
    s="\${r//\$'\\e'\\[[0-9;]#[mK]/}"
    if [[ \$s == \${~pick} ]]; then print -r -- "\$s"; exit 0; fi
done
exit 1
EOF
chmod +x "$KB/stub/fzf"

# Every key to look up with bindkey, one per line, in bindkey notation.
for row in "${ZLE_ROWS[@]}" "${FZF_ROWS[@]}"; do print -r -- "${${(@ps:\x1f:)row}[3]}"; done > "$KB/seqs"

cat > "$KB/helper.zsh" <<EOF
typeset -gi KB_SEQ=0
_kb_dump() {
    (( KB_SEQ++ ))
    print -r -- "\$KB_SEQ"\$'\x1f'"\$BUFFER"\$'\x1f'"\$CURSOR"\$'\x1f'"\$PWD" >| ${(q)KB}/dump
}
_kb_reset() {
    zle end-of-history
    BUFFER=''; CURSOR=0; MARK=0; REGION_ACTIVE=0
    [[ \$PWD == ${(q)REPO} ]] || builtin cd -q -- ${(q)REPO}
}
zle -N _kb_dump
zle -N _kb_reset
bindkey -M emacs '^[[24~' _kb_dump
bindkey -M emacs '^[[23~' _kb_reset
path=(${(q)KB}/stub \$path)
builtin cd -q -- ${(q)REPO}
while IFS= read -r k; do
    [[ \$k == - ]] && { print -r -- -; continue }
    b="\$(bindkey -M emacs -- "\$k")"
    print -r -- "\${b##* }"
done < ${(q)KB}/seqs >| ${(q)KB}/bindings
{
    print -r -- "flowcontrol=\${options[flowcontrol]}"
    print -r -- "FZF_DEFAULT_OPTS=\$FZF_DEFAULT_OPTS"
} >| ${(q)KB}/env
print ready >| ${(q)KB}/ready
EOF

# --- Session ---------------------------------------------------------------------------------------
# KB_LOG=<file> saves everything the session prints, for debugging.
drain() { local c; while zpty -rt KBSH c 2>/dev/null; do [[ -n ${KB_LOG-} ]] && print -rn -- "$c" >> "$KB_LOG"; done }
pause() { zselect -t "$1" 2>/dev/null; drain }
send() { zpty -w -n KBSH "${(g:ce:)1}" }

# wait_for <file> <timeout seconds>: until the file exists.
wait_for() {
    local deadline=$(( EPOCHREALTIME + $2 ))
    while [[ ! -s $1 ]]; do
        (( EPOCHREALTIME > deadline )) && return 1
        drain; zselect -t 2 2>/dev/null
    done
    return 0
}

# zpty evaluates its arguments as one command line, hence the quoting.
# A set SSH_AUTH_SOCK stops .zprofile from starting an ssh-agent that outlives the test.
session_env=(
    HOME="$TMP/home" ZDOTDIR="$TMP/home" TERM=xterm-256color
    SSH_AUTH_SOCK="$TMP/no-agent.sock"
    XDG_CACHE_HOME="$TMP/xdg-cache" XDG_DATA_HOME="$TMP/xdg-data" XDG_STATE_HOME="$TMP/xdg-state"
    MISE_CACHE_DIR="$TMP/mise-cache" MISE_DATA_DIR="$TMP/mise-data" MISE_STATE_DIR="$TMP/mise-state"
    TMPPREFIX="$TMP/zsh"
)
zpty KBSH "env -i ${(j: :)${(@q)session_env}} zsh -i"

# zle turns on bracketed paste each time it starts reading a line, so its escape code means a prompt.
out=''
deadline=$(( EPOCHREALTIME + 20 ))
while [[ $out != *$'\e[?2004h'* ]]; do
    (( EPOCHREALTIME > deadline )) && { print -u2 "FAIL  session: no prompt after 20 s"; exit 1 }
    zpty -rt KBSH c 2>/dev/null && out+=$c || zselect -t 2 2>/dev/null
done
[[ -n ${KB_LOG-} ]] && print -rn -- "$out" >> "$KB_LOG"
send " source ${(q)KB}/helper.zsh^M"
wait_for "$KB/ready" 10 || { print -u2 "FAIL  session: helper did not run"; exit 1 }

typeset -a BINDINGS=("${(@f)$(<$KB/bindings)}")
typeset -A ENV_VARS
for line in "${(@f)$(<$KB/env)}"; do ENV_VARS[${line%%=*}]=${line#*=}; done
FLOW_ON=0; [[ ${ENV_VARS[flowcontrol]} == on ]] && FLOW_ON=1

typeset -i ROW_INDEX=0
# run_keys <typed> <flags> [file]: reset the line, type, read back the dump. Sets R_BUF R_CUR R_PWD.
# With the wait flag, pause before the dump; if a file is given, first wait until it exists.
run_keys() {
    rm -f "$KB/dump"
    send '^[[23~'"$1"
    if [[ $2 == *wait* ]]; then
        [[ -n ${3-} ]] && wait_for "$3" 5
        pause 80
    fi
    send '^[[24~'
    if ! wait_for "$KB/dump" 5; then
        # Unstick whatever swallowed the keys, so later rows still run.
        send '^C'; pause 50; send '^C'; pause 50
        return 1
    fi
    local -a f=("${(@ps:\x1f:)$(<$KB/dump)}")
    R_BUF=$f[2] R_CUR=$f[3] R_PWD=$f[4]
}

# --- Layers 1 and 2: zle keys ----------------------------------------------------------------------
print -r -- "== zsh keys =="
for row in "${ZLE_ROWS[@]}"; do
    (( ROW_INDEX++ ))
    f=("${(@ps:\x1f:)row}")
    id=$f[1] key=$f[3] widget=$f[4] typed=$f[5] buf=$f[6] cur=$f[7] flags=$f[8] st=$f[9]
    actual=$BINDINGS[ROW_INDEX]
    if [[ $actual != "$widget" ]]; then
        report "$id" "$st" 0 "$key is bound to $actual, expected $widget"; continue
    fi
    if [[ $flags == *flow* ]] && (( FLOW_ON )); then
        report "$id" "$st" 0 "flow control is on, so the terminal driver takes Ctrl-S before zsh sees it"; continue
    fi
    if ! run_keys "$typed" "$flags"; then
        report "$id" "$st" 0 "no response from the shell"; continue
    fi
    if [[ $R_BUF != $buf || ( $cur != - && $R_CUR != $cur ) ]]; then
        report "$id" "$st" 0 "got buffer '${R_BUF}' cursor $R_CUR, expected '${buf}' cursor $cur"; continue
    fi
    report "$id" "$st" 1 ''
done

# --- Layer 3: fzf-driven keys ----------------------------------------------------------------------
print -r -- "== fzf-driven keys =="
for row in "${FZF_ROWS[@]}"; do
    (( ROW_INDEX++ ))
    f=("${(@ps:\x1f:)row}")
    id=$f[1] key=$f[3] widget=$f[4] typed=$f[5] pick=$f[6] expect=${f[7]//@HASH@/$HASH} opts=$f[8] flags=$f[9] st=$f[10]
    if [[ $id == git-* ]] && (( ! HAVE_FZF_GIT )); then skip "$id" "fzf-git is not installed"; continue; fi
    actual=$BINDINGS[ROW_INDEX]
    if [[ $widget != - && $actual != "$widget" ]]; then
        report "$id" "$st" 0 "$key is bound to $actual, expected $widget"; continue
    fi
    if [[ $flags == *flow* ]] && (( FLOW_ON )); then
        report "$id" "$st" 0 "flow control is on, so the terminal driver takes Ctrl-S before zsh sees it"; continue
    fi
    print -r -- "$pick" >| "$KB/pick"
    rm -f "$KB/fzf-opts"
    if ! run_keys "$typed" "$flags" "$KB/fzf-opts"; then
        report "$id" "$st" 0 "no response from the shell"; continue
    fi
    if [[ ! -f $KB/fzf-opts ]]; then
        report "$id" "$st" 0 "fzf was not called (buffer '${R_BUF}')"; continue
    fi
    if [[ -n $opts && "$(<$KB/fzf-opts)" != *"$opts"* ]]; then
        report "$id" "$st" 0 "fzf options lack '$opts'"; continue
    fi
    if [[ $expect == pwd:* ]]; then
        ok=0; [[ $R_PWD == "$REPO/${expect#pwd:}" ]] && ok=1
        report "$id" "$st" $ok "shell is in $R_PWD, expected $REPO/${expect#pwd:}"; continue
    fi
    if [[ $expect == '~'* ]]; then
        ok=0; [[ $R_BUF == ${~expect#\~} ]] && ok=1
    else
        ok=0; [[ $R_BUF == "$expect" ]] && ok=1
    fi
    report "$id" "$st" $ok "got buffer '${R_BUF}', expected '${expect#\~}'"
done

zpty -d KBSH 2>/dev/null

# --- Layer 4: keys handled inside fzf --------------------------------------------------------------
print -r -- "== keys inside fzf =="
FZF_OPTS=${ENV_VARS[FZF_DEFAULT_OPTS]-}
FZF_DEFAULT_OPTS="$FZF_OPTS" "$REAL_FZF" --filter=kb </dev/null >/dev/null 2>"$TMP/fzf-err"
if (( $? == 2 )); then
    report fzf-options ok 0 "fzf rejects FZF_DEFAULT_OPTS: $(<$TMP/fzf-err)"
else
    report fzf-options ok 1 ''
fi

# Split every --bind value into key:action pairs, keeping commas inside parentheses.
typeset -A FZF_BINDS
words=("${(@Q)${(z)FZF_OPTS}}")
for (( i = 1; i <= ${#words}; i++ )); do
    w=$words[i]
    case $w in
        --bind=*) spec=${w#--bind=} ;;
        --bind) spec=$words[i+1]; (( i++ )) ;;
        *) continue ;;
    esac
    depth=0 item=''
    for (( j = 1; j <= ${#spec}; j++ )); do
        ch=$spec[j]
        [[ $ch == '(' ]] && (( depth++ ))
        [[ $ch == ')' ]] && (( depth-- ))
        if [[ $ch == , && $depth == 0 && -n $item ]]; then
            FZF_BINDS[${item%%:*}]=${item#*:}; item=''
        else
            item+=$ch
        fi
    done
    [[ -n $item ]] && FZF_BINDS[${item%%:*}]=${item#*:}
done

for row in "${BIND_ROWS[@]}"; do
    f=("${(@ps:\x1f:)row}")
    id=$f[1] keys=$f[3] action=$f[4] st=$f[6]
    ok=1 detail=''
    for k in ${(s: :)keys}; do
        got=${FZF_BINDS[$k]-default}
        if [[ $got != $action ]]; then ok=0; detail+="$k is $got; "; fi
    done
    report "$id" "$st" $ok "${detail%; } (expected $action)"
done

# --- Layer 5: keys taken before zsh sees them ------------------------------------------------------
print -r -- "== terminal and multiplexer =="
# key_mods <bindkey key>: "MODS key" of the first key pressed, in WezTerm's naming.
key_mods() {
    local k=$1
    case $k in
        '^[^?') print -r -- 'ALT Backspace' ;;
        '\e'?*) print -r -- "ALT ${k[3]}" ;;
        '^I') print -r -- 'NONE Tab' ;;
        '^'?*) print -r -- "CTRL ${(L)k[2]}" ;;
        *) print -r -- "NONE $k" ;;
    esac
}
fzf_key_mods() {
    case $1 in
        ctrl-*) print -r -- "CTRL ${1#ctrl-}" ;;
        alt-*) print -r -- "ALT ${1#alt-}" ;;
        shift-up) print -r -- 'SHIFT UpArrow' ;; shift-down) print -r -- 'SHIFT DownArrow' ;;
        shift-left) print -r -- 'SHIFT LeftArrow' ;; shift-right) print -r -- 'SHIFT RightArrow' ;;
        *) print -r -- "NONE $1" ;;
    esac
}

# Every key the spec relies on, as "id<SEP>MODS key<SEP>flags".
typeset -a USED
for row in "${ZLE_ROWS[@]}" "${FZF_ROWS[@]}"; do
    f=("${(@ps:\x1f:)row}")
    [[ $f[3] == - ]] && continue
    [[ ${#f} == 9 ]] && flags=$f[8] || flags=$f[9]
    USED+=("$f[1]$SEP$(key_mods $f[3])$SEP$flags")
done
for row in "${BIND_ROWS[@]}"; do
    f=("${(@ps:\x1f:)row}")
    [[ $f[4] == default ]] && continue
    for k in ${(s: :)f[3]}; do USED+=("$f[1]$SEP$(fzf_key_mods $k)$SEP$f[5]"); done
done

WEZTERM_LUA="$REPO_ROOT/home/.config/wezterm/wezterm.lua"
if ! command -v wezterm >/dev/null; then
    skip wezterm "wezterm is not installed"
else
    # Only the top-level key table applies to the shell; key_tables are copy and search modes.
    typeset -A WEZ_KEYS
    in_keys=0
    while IFS= read -r line; do
        [[ $line == '  keys = {' ]] && { in_keys=1; continue }
        (( in_keys )) && [[ $line == '  },' ]] && break
        if (( in_keys )) && [[ $line =~ "key = '([^']+)', mods = '([^']+)', action = (.*) \\}," ]]; then
            WEZ_KEYS["$match[2] $match[1]"]=$match[3]
        fi
    done < <(wezterm --config-file "$WEZTERM_LUA" show-keys --lua 2>/dev/null)
    if (( ${#WEZ_KEYS} == 0 )); then
        report wezterm-keys ok 0 "could not read WezTerm's key table"
    else
        taken=''
        for u in "${USED[@]}"; do
            f=("${(@ps:\x1f:)u}")
            [[ -n ${WEZ_KEYS[$f[2]]-} ]] && taken+="$f[1] ($f[2]: ${WEZ_KEYS[$f[2]]}); "
        done
        report wezterm-keys ok $(( ${#taken} == 0 )) "WezTerm takes ${taken%; }"
    fi
    # WezTerm's default for this setting is false: left Option sends ESC plus the key, which ALT- rows need.
    ok=1
    [[ "$(<$WEZTERM_LUA)" =~ 'send_composed_key_when_left_alt_is_pressed *= *true' ]] && ok=0
    report wezterm-left-option ok $ok "wezterm.lua makes left Option compose characters, so ALT- keys never reach zsh"
fi

HERDR_TOML="$REPO_ROOT/home/.config/herdr/config.toml"
if ! command -v herdr >/dev/null; then
    skip herdr "herdr is not installed"
else
    prefix=ctrl+b
    if [[ "$(<$HERDR_TOML)" =~ '(^|'$'\n'')prefix *= *"([^"]+)"' ]]; then prefix=$match[2]; fi
    case $prefix in
        ctrl+?) prefix_mods="CTRL ${prefix#ctrl+}" ;;
        alt+?) prefix_mods="ALT ${prefix#alt+}" ;;
        *) prefix_mods="NONE $prefix" ;;
    esac
    taken='' stale=''
    for u in "${USED[@]}"; do
        f=("${(@ps:\x1f:)u}")
        if [[ $f[2] == $prefix_mods ]]; then
            [[ $f[3] == *herdr* ]] || taken+="$f[1]; "
        elif [[ $f[3] == *herdr* ]]; then
            stale+="$f[1]; "
        fi
    done
    report herdr-prefix ok $(( ${#taken} == 0 )) "the herdr prefix $prefix takes ${taken%; }; mark the rows herdr or change the key"
    report herdr-marks ok $(( ${#stale} == 0 )) "rows marked herdr but not taken by the prefix $prefix: ${stale%; }"
fi

# --- Cheat sheets list only keys in the spec -------------------------------------------------------
print -r -- "== cheat sheets =="
typeset -A SPEC_NAMES
for row in "${ZLE_ROWS[@]}" "${FZF_ROWS[@]}" "${BIND_ROWS[@]}"; do
    for n in "${(@s:;:)${${(@ps:\x1f:)row}[2]}}"; do [[ -n $n ]] && SPEC_NAMES[$n]=1; done
done
for sheet in "${SHEETS[@]}"; do
    file="$REPO_ROOT/$sheet"
    [[ -f $file ]] || { report "sheet:${sheet:t}" ok 0 "$sheet is missing"; continue }
    col=0 missing=''
    while IFS= read -r line; do
        [[ $line == '|'* ]] || { col=0; continue }
        cells=("${(@s:|:)line}")
        cells=("${(@)cells[2,-2]}")
        if (( col == 0 )); then
            for (( i = 1; i <= ${#cells}; i++ )); do
                [[ ${cells[i]} == *(Key Binding|Command)* ]] && { col=$i; break }
            done
            continue
        fi
        [[ ${cells[col]} == *---* ]] && continue
        # Text between backticks sits at the even positions of a split on backticks.
        parts=("${(@ps:\x60:)cells[col]}")
        for (( i = 2; i <= ${#parts}; i += 2 )); do
            n=${(L)${parts[i]// ##/ }}
            [[ -n ${SPEC_NAMES[$n]-} ]] || missing+="'${parts[i]}'; "
        done
    done < "$file"
    report "sheet:${sheet:t}" ok $(( ${#missing} == 0 )) "lists keys the test does not cover: ${missing%; }"
done

print
print -r -- "$N_PASS passed, $N_FAIL failed, $N_XFAIL expected failures, $N_XPASS unexpected passes, $N_SKIP skipped"
(( N_FAIL == 0 && N_XPASS == 0 ))
