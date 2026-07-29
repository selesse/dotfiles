chpwd() {
    [[ -o interactive ]] && ls
}

extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      rar x $1        ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file - go home"
    fi
}

# Keep going up directories until you find "$file", or we reach root.
find_parent_file() {
    local file="$1"
    local directory="$PWD"
    local starting_directory="$directory"
    local target=""

    if [ -z "$file" ] ; then
        echo "Please specify a file to find"
    fi

    while [ -d "$directory" ] && [ "$directory" != "/" ] ; do
        if [ `find "$directory" -maxdepth 1 -name "$file"` ] ; then
            target="$PWD"
            break
        else
            builtin cd .. && directory="$PWD"
        fi
    done

    builtin cd $starting_directory

    if [ -z "$target" ] ; then
        return 1
    fi

    echo $target
    return 0
}

# Open a file in Vim using a fuzzy-finder
vif() {
    file=$(fzf)
    if [ ! -z "$file" ] ; then
        $EDITOR $file
    fi
}
