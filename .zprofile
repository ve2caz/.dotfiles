# .zprofile - Login Shell Configuration
# echo "SOURCED .zprofile"

# Source common environment variables only if not already sourced by .zshenv
if [[ -z "$ZSHENV_SOURCED" ]]; then
	source .zshenv
fi
