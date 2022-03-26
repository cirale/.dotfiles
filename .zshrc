unsetopt BG_NICE
source ~/.bashrc

# if [[ -z "$TMUX" ]]; then
#   tmux new-session
#   exit
# fi
# Set up the prompt

autoload -Uz promptinit && promptinit
autoload -Uz bashcompinit && bashcompinit
autoload -Uz compinit && compinit -c

setopt histignorealldups
setopt share_history
# コマンドのスペルを訂正する
setopt correct
# Ctrl+sのロック, Ctrl+qのロック解除を無効にする
setopt no_flow_control
# ワイルドカード時の挙動
setopt nonomatch

# Ctrl+rでヒストリーのインクリメンタルサーチ、Ctrl+sで逆順
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# コマンドを途中まで入力後、historyから絞り込み
# 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

export EDITOR=emacs

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# auto pushd
DIRSTACKSIZE=100
setopt AUTO_PUSHD

RPROMPT="%F{green}[%D %*]"
zmodload zsh/datetime # $EPOCHSECONDS, strftime等を利用可能に
reset_tmout() { TMOUT=$[60-EPOCHSECONDS%60] }
precmd_functions=($precmd_functions reset_tmout) # プロンプト表示時に更新までの時間を再計算
redraw_tmout() { zle reset-prompt; reset_tmout } # 時刻を更新
TRAPALRM() { redraw_tmout }

#eval $(dircolors ~/.dircolors.ansi-universal)
zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#補完候補にディレクトリスタックを表示する cd -<TAB>
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

# source aws_zsh_completer.sh
complete -C '/usr/local/aws-cli/v2/2.0.45/bin/aws_completer' aws

### Added by Zinit's installer
zi_home="${HOME}/.zi"
if [[ ! -d ${zi_home} ]]; then
  mkdir -p $zi_home
  git clone https://github.com/z-shell/zi.git "${zi_home}/bin"
fi
zi_home="${HOME}/.zi"
source "${zi_home}/bin/zi.zsh"
# Next two lines must be below the above two
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

zi light zsh-users/zsh-autosuggestions
zi light zdharma/fast-syntax-highlighting
zi light zsh-users/zsh-history-substring-search
zi ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zi light sindresorhus/pure

# completion for awscli
#complete -C '/usr/local/bin/aws_completer' aws

### End of Zinit's installer chunk
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi
