case "$(uname -s)" in
    "Darwin")
        alias ls="ls -G"
        alias l="ls -GF"

        export JAVA_HOME=/Users/alex/Library/Java/JavaVirtualMachines/openjdk-21/Contents/Home
        ;;
    *)
        alias ls="ls --color"
        alias l="ls --color -F"
        if_program_installed xclip 'alias pbcopy="xclip -selection clipboard"'
        if_program_installed xclip 'alias pbpaste="xclip -selection clipboard -o"'
        ;;
esac

alias config="cd ~/git/dotfiles"
alias hisgrep="history | grep"
alias fname="find . -type f -name"
alias vi="${EDITOR}"
if_program_installed colordiff 'alias diff="colordiff -u"'
if_program_installed tree 'alias tree="tree -C"'
if_program_installed bat 'alias cat="bat"'
if_program_installed vagrant 'alias vagrant-rebuild="vagrant destroy -f && vagrant up && vagrant ssh"'

export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export LS_COLORS="di=1;34:ln=1;36:so=1;31:pi=1;33:ex=1;32:bd=1;34;46:cd=1;34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
