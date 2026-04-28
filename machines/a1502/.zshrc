export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Cargo/Rust
. "$HOME/.cargo/env"

# Starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/nigel/.lmstudio/bin"
# End of LM Studio CLI section

