#!/bin/bash

# run this script in $HOME directory (eg. /home/blvnk)!

set -e

echo "checking if script is executed in user's \$HOME directory."
if [[ $(pwd) != $(echo $HOME) ]]; then
    echo "not in user's \$HOME directory!"
    exit 1
fi

echo "-----BASICS-----"

printf "\ngetting latest updates & upgrading . . .\n"
sudo apt-get update -q > /dev/null
sudo apt-get upgrade -qy --with-new-pkgs > /dev/null

printf "\ninstalling multi-media codecs.\n"
sudo apt-get install -qy mint-meta-codecs

printf "\ninstalling git.\n"
sudo apt-get install -qy git
read -p "add Git logline alias (y/n)? " logline_input
if [[ $logline_input == "y" ]]; then
    git config --global alias.logline "log --graph --pretty=format:'%C(yellow)%h %C(red)%ah%C(auto)%d %Creset%s %C(bold blue)<%an>'
"
    git config --global alias.ll "log --pretty=format:'%C(yellow)%h%C(auto)%d %Creset%s %C(bold blue)<%an>'"
    echo "added Git logline alias. run with \"git logline\"."
fi

printf "\ninstalling python3.9.\n"
sudo add-apt-repository -y ppa:deadsnakes/ppa > /dev/null
sudo apt-get update -q > /dev/null
sudo apt-get install -qy python3.10 python3-pip python3.10-venv

printf "\ninstalling Microsoft fonts.\n"
sudo apt-get install -qy ttf-mscorefonts-installer

printf "\ninstalling trash-cli.\n"
# https://github.com/andreafrancia/trash-cli
sudo apt-get install -qy trash-cli


echo "-----INSTALLING MACOS THEME-----"

printf "\ninstalling WhiteSur GTK theme.\n"
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme/ && ./install.sh
# install tweaks for Firefox
./tweaks.sh -f

printf "\ninstalling plank dock.\n"
# https://launchpad.net/plank
sudo apt-get install -qy plank
printf "adding WhiteSur theme to Plank."
mkdir -p ~/.local/share/plank/themes
cp -r ~/WhiteSur-gtk-theme/src/other/plank/theme-Light ~/WhiteSur-gtk-theme/src/other/plank/theme-Dark ~/.local/share/plank/themes
cd && trash WhiteSur-gtk-theme/

printf "\ninstalling WhiteSur icon theme.\n"
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme/ && ./install.sh
cd && trash WhiteSur-icon-theme/

printf "\ninstalling WhiteSur cursors.\n"
git clone https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors/ && sudo ./install.sh
cd && trash WhiteSur-cursors/

printf "\ninstalling Nautilus file manager.\n"
# https://gitlab.gnome.org/GNOME/nautilus
sudo apt-get install -qy nautilus


echo "-----ENABLE ADDITIONAL CONFIGURATIONS-----"

read -p "enable additional configurations (eg bash prompt modification, bash auto-completion) (y/n)? " add_conf_input
if [[ $add_conf_input == "y" ]]; then
    printf "\ncreating pretty bash prompt.\n"
    # downloading git-prompt.sh from https://github.com/git/git
    curl -s https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o .git-prompt.sh
    chmod ug+x .git-prompt.sh
    # customising bash prompt.
    echo \
"
# bash prompt w/ git branch
source ~/.git-prompt.sh
# display chroot name if in chroot
PS1='\${debian_chroot:+(\$debian_chroot)}'
# add working directory
PS1+='\[\033[01;34m\]\w\[\033[00m\]'
# add git branch if exists
PS1+='\[\033[01;33m\]\$(__git_ps1)\[\033[00m\] '
# prompt symbol then clear colours
PS1+='\[\033[01;35m\]\\$\[\033[00m\] '" >> .bashrc

    printf "\nadding aliases.\n"
    echo \
"# bash aliases
alias c=clear" > .bash_aliases
    if [[ -n $(which python3) ]]; then
        echo \
"alias python=python3
alias py=python3" >> .bash_aliases
        echo "added aliases for python3."
    else
        echo "python3 does not exist. skipping its aliases."
    fi

    printf "\nbash better auto-completion.\n"
    if [ ! -f "~/.inputrc" ]; then
        echo \
"# bash better auto-completion
set show-all-if-ambiguous on
set completion-ignore-case on" > .inputrc
    else
        echo "~/.inputrc file exists. adding bash better autocompletion skipped. please manually the required lines from \`install.sh\`."
    fi
fi


echo "-----EXTRAS-----"

printf "\ninstalling tree.\n"
# https://gitlab.com/OldManProgrammer/unix-tree
sudo apt-get install -qy tree

printf "\ninstalling neofetch.\n"
sudo apt-get install -qy neofetch

printf "\ninstalling batcat (& adding aliases).\n"
sudo apt-get install -qy bat
echo "alias cat=\"batcat -pp\"" >> ~/.bash_aliases

printf "\ninstalling terminator (& adding Atom One Dark theme).\n"
sudo apt-get install -qy terminator
mkdir -p ~/.config/terminator/
echo \
"[global_config]
  title_transmit_bg_color = \"#2e3436\"
  inactive_color_offset = 1.0
  suppress_multiple_term_dialog = True
[keybindings]
[profiles]
  [[default]]
    icon_bell = False
    background_color = \"#282c34\"
    background_darkness = 0.95
    background_type = transparent
    cursor_shape = ibeam
    cursor_color = \"#bbbbbb\"
    foreground_color = \"#ffffff\"
    show_titlebar = False
    scrollbar_position = hidden
    palette = \"#000000:#eb6e67:#95ee8f:#f8c456:#6eaafb:#d886f3:#6cdcf7:#b2b2b2:#50536b:#eb6e67:#95ee8f:#f8c456:#6eaafb:#d886f3:#6cdcf7:#dfdfdf\"
    copy_on_selection = True
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = \"\"
    [[[child1]]]
      type = Terminal
      parent = window0
[plugins]" > ~/.config/terminator/config

printf "\ninstalling btop.\n"
# https://github.com/aristocratos/btop
sudo apt-get install -qy btop

echo "-----APPS-----"

printf "\ninstalling VLC.\n"
sudo apt-get install -qy vlc

printf "\ninstalling VS Code.\n"
curl -s -o code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868
sudo apt-get install -qy ./code.deb
trash code.deb

printf "\ninstalling Discord.\n"
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo apt-get install -qy ./discord.deb
trash discord.deb

printf "\ninstalling OBS Studio.\n"
# ffmpeg required by OBS.
sudo apt-get install -qy ffmpeg
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt-get update -q > /dev/null
sudo apt-get install -qy obs-studio

printf "\ninstalling Image Magick.\n"
sudo apt-get install -qy imagemagick

echo "-----FINISHED SUCCESSFULLY-----"
