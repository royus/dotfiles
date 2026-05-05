#!/usr/bin/env bash
# install.sh — symlink dotfiles into $HOME
# Usage: ./install.sh [--dry-run]

set -euo pipefail

DRY_RUN=0
for arg in "$@"; do
	case "$arg" in
		-n|--dry-run) DRY_RUN=1 ;;
		-h|--help)
			cat <<EOF
Usage: ./install.sh [--dry-run]
  -n, --dry-run   Show what would be linked without making changes
  -h, --help      Show this help
EOF
			exit 0
			;;
		*) echo "Unknown option: $arg" >&2; exit 1 ;;
	esac
done

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
	Darwin) OS=mac ;;
	Linux)
		if grep -qiE '(microsoft|wsl)' /proc/version 2>/dev/null; then
			OS=wsl
		else
			OS=linux
		fi
		;;
	*) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

echo "[info] OS=$OS  DOTFILES=$DOTFILES  DRY_RUN=$DRY_RUN"

run() {
	if [[ $DRY_RUN -eq 1 ]]; then
		echo "  [dry] $*"
	else
		"$@"
	fi
}

link() {
	local src="$DOTFILES/$1"
	local dst="$2"
	dst="${dst/#\~/$HOME}"

	if [[ ! -e "$src" ]]; then
		echo "  [skip] source missing: $src"
		return
	fi

	if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
		echo "  [ok]   $dst -> $src"
		return
	fi

	run mkdir -p "$(dirname "$dst")"

	if [[ -e "$dst" || -L "$dst" ]]; then
		local bak="${dst}.bak.$(date +%Y%m%d%H%M%S)"
		echo "  [bak]  $dst -> $bak"
		run mv "$dst" "$bak"
	fi

	echo "  [link] $dst -> $src"
	run ln -s "$src" "$dst"
}

# common — all platforms
link .vimrc ~/.vimrc

# linux + wsl shared
if [[ $OS == linux || $OS == wsl ]]; then
	link linux/.bashrc       ~/.bashrc
	link linux/.bash_profile ~/.bash_profile
	link linux/.inputrc      ~/.inputrc
fi

# mac — karabiner/btt are managed via app UI; see README
if [[ $OS == mac ]]; then
	echo "[info] mac/ configs (karabiner, btt) are not auto-linked. See README."
fi

echo "[done]"
