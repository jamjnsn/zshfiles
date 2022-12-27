#!/usr/bin/env zsh
	
# ==================================================
# Simplified archive extraction
# ==================================================

ex() {
	# Set output directory
	if [ -z "$2" ]; then
		outdir="${1%%.*}"
	else
		outdir="$2"
	fi
	
	# Ensure output directory is valid
	if [ -f $outdir ]; then
		echo "Can't extract to \"$outdir\": file exists"
		return
	elif [ -d $outdir ]; then
		echo "Can't extract to \"$outdir\": directory exists"
		return
	fi
	
	# Attempt extraction based on filename
	if [ -f $1 ]; then
		case $1 in
			*.tar.bz2)	tar -xjf $1 -one-top-level=$outdir  ;;
			*.tar.gz)	tar xzf $1 --one-top-level=$outdir  ;;
			*.tgz)		tar xzf $1 --one-top-level=$outdir	;;
			*.zip)		unzip $1 -d $outdir				 	;;
			*.7z)		7z x $1 -o$outdir					;;
			
			*)
				echo "\"$1\" is not a supported archive"
				return
			;;
		esac
		
		echo "Extracted to 📁$outdir"
	else
		echo "\"$1\" is not a valid file"
	fi
}

# ==================================================
# Make temporary directory for the  
# duration of a subshell.
# ==================================================

tmp () {
    (
        export MY_SHLVL=tmp:$MY_SHLVL 
        export od=$PWD 
        export tmp=$(mktemp -d) 
        trap "rm -rf $tmp" 0
        cd $tmp
        if [ -z "$1" ]
        then
            $SHELL -l
        else
            [ "$1" = "-l" ] && {
                shift
                set "$@" ";" "$SHELL -l"
            }
            eval "$@"
        fi
    )
}

# ==================================================
# Reload zsh config
# ==================================================

rlzsh () {
	source $HOME/.zshenv
	source $ZDOTDIR/.zshrc
	exec /usr/bin/env zsh
}

# =================================================
# cd to last directory on lf exit
# =================================================

lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

# =================================================
# Take
# =================================================

function take() {
  if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
    takeurl "$1"
  elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
    takegit "$1"
  else
    takedir "$@"
  fi
}

function mkcd takedir() {
  mkdir -p $@ && cd ${@:$#}
}

function takegit() {
  git clone "$1"
  cd "$(basename ${1%%.git})"
}

function takeurl() {
  local data thedir
  data="$(mktemp)"
  curl -L "$1" > "$data"
  tar xf "$data"
  thedir="$(tar tf "$data" | head -n 1)"
  rm "$data"
  cd "$thedir"
}