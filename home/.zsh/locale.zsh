# ~/.zsh/locale.zsh - Locale configuration helpers
# Ensures UTF-8 while preserving the user's region settings.
# echo "SOURCED ~/.zsh/env.zsh (PID: $$)"

# Avoid LC_ALL; prefer setting LANG (region + UTF-8) and LC_CTYPE.
ensure_utf8_locale() {
  # Already UTF-8, as a parent shell usually passes it down: nothing to check, no program to start.
  # An unset LC_CTYPE follows LANG.
  if [[ $LANG == *UTF-8* && ( -z $LC_CTYPE || $LC_CTYPE == *UTF-8* ) ]]; then
    return 0
  fi
  local os region candidate chosen locales
  case $OSTYPE in darwin*) os=Darwin ;; *) os=$(uname -s) ;; esac

  # Derive region from existing LANG if present (e.g., fr_CA from fr_CA.UTF-8)
  if [[ -n "$LANG" ]]; then
    region="${LANG%%.*}"
  fi

  # macOS: read AppleLocale (e.g., en_CA) if region is unknown
  if [[ -z "$region" && "$os" == "Darwin" ]]; then
    region="$(defaults read -g AppleLocale 2>/dev/null | sed -E 's/-/_/; s/\..*$//')"
  fi

  # Linux/systemd: try localectl for System Locale
  if [[ -z "$region" ]]; then
    region="$(localectl status 2>/dev/null | sed -nE 's/.*System Locale:\s*([A-Za-z_]+).*/\1/p')"
  fi

  # Fallback: parse current locale output
  if [[ -z "$region" ]]; then
    region="$(locale 2>/dev/null | sed -nE 's/^LANG="?([A-Za-z_]+).*/\1/p')"
  fi

  # Build preferred UTF-8 locale for the detected region
  if [[ -n "$region" ]]; then
    candidate="${region}.UTF-8"
  fi

  # The installed locales, read once and kept local.
  locales=("${(@f)$(locale -a 2>/dev/null)}")

  if [[ -n "$candidate" ]] && (( ${locales[(Ie)$candidate]} )); then
    chosen="$candidate"
  else
    # Try any region-matching UTF-8 locale
    if [[ -n "$region" ]]; then
      chosen="${locales[(r)${region}.UTF-8]}"
    fi
    # Portable fallbacks: C.UTF-8 (Linux), en_US.UTF-8 (common), UTF-8 (macOS)
    if [[ -z "$chosen" ]]; then
      chosen="${locales[(r)(C.UTF-8|en_US.UTF-8|UTF-8)]}"
    fi
    # Final fallback: C
    if [[ -z "$chosen" ]]; then
      chosen="C"
    fi
  fi

  # Keep region preferences; ensure UTF-8 codeset
  if [[ -z "$LANG" || "$LANG" != *"UTF-8"* ]]; then
    if [[ -n "$region" ]] && (( ${locales[(Ie)${region}.UTF-8]} )); then
      export LANG="${region}.UTF-8"
    else
      export LANG="$chosen"
    fi
  fi

  # Ensure character classification/encoding uses UTF-8
  if [[ -z "$LC_CTYPE" || "$LC_CTYPE" != *"UTF-8"* ]]; then
    export LC_CTYPE="$chosen"
  fi
}
