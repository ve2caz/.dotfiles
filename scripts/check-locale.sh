#!/bin/bash
# check-locale.sh - Verify locale settings for troubleshooting

echo "=== Current Locale Settings ==="
locale

echo -e "\n=== Environment Variables ==="
printenv | grep -E "^(LANG|LC_)" | sort

echo -e "\n=== Date Format Test ==="
date

echo -e "\n=== Number Format Test ==="
printf "%.2f\n" 1234.56

echo -e "\n=== Currency Format Test (if available) ==="
if command -v locale >/dev/null 2>&1; then
    echo "1234.56" | numfmt --format="%.2f" 2>/dev/null || echo "numfmt not available"
fi

echo -e "\n=== Terminal Info ==="
echo "TERM: $TERM"
echo "SHELL: $SHELL"
echo "PWD: $PWD"
