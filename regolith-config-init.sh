#!/bin/bash

REGOLITH_I3_CONFIG_DIR="$HOME/.config/i3-regolith"
PKG_VERSION=`dpkg -s regolith-gnome-flashback | grep '^Version:' | awk '{print $2}'`
UPDATE_FLAG_PATH="$REGOLITH_I3_CONFIG_DIR/config-flag-$PKG_VERSION"

# If new version of regolith-gnome-flashback, stage Xresources.
if [ ! -f $UPDATE_FLAG_PATH ]; then
        if [ -f /usr/share/regolith-styles/root ]; then
                if [ ! -f ~/.Xresources-regolith ]; then
                        echo "Staging Regolith styles."
                        cp /usr/share/regolith-styles/root ~/.Xresources-regolith
                        if [ ! -d ~/.Xresources.d ]; then
                                mkdir ~/.Xresources.d
                        fi
                        cp /usr/share/regolith-styles/* ~/.Xresources.d/
                        rm ~/.Xresources.d/root
                fi
        fi
fi

# Load Xresources
if [ -f ~/.Xresources ]; then
        echo "Loading default Xresources."
        xrdb -merge ~/.Xresources
fi

# Load Regolith Xresources
if [ -f ~/.Xresources-regolith ]; then
        echo "Loading regolith Xresources."
        xrdb -merge ~/.Xresources-regolith
fi

# The following stanza is to set Regolith-specific changes to default Ubuntu settings.
if [ ! -f $UPDATE_FLAG_PATH ]; then
        echo "Executing regolith session configuration script for $PKG_VERSION."

        # Required for i3 and gnome-shell to coexist
        gsettings set org.gnome.desktop.background show-desktop-icons false
        gsettings set org.gnome.gnome-flashback desktop-background true


        # Remap default keyboard switch keybindings to avoid collision w/ i3
        gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt><Super>BackSpace']"
        gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift><Alt><Super>BackSpace']"

        # Set the theme
        gsettings set org.gnome.desktop.interface gtk-theme "SolArc-Dark"
        gsettings set org.gnome.desktop.wm.preferences theme "SolArc-Dark"
        gsettings set org.gnome.desktop.interface icon-theme "Arc"

        # Set the wallpaper
        gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/ESP_020528_1750_desktop.jpg"

        # Only run this script once per package version per user login session.
        touch $UPDATE_FLAG_PATH
fi

# Stage i3 config file
REGOLITH_I3_CONFIG_FILE="$REGOLITH_I3_CONFIG_DIR/config"
if [ ! -f $REGOLITH_I3_CONFIG_FILE ]; then
        echo "Copying default Regolith i3 configuration to user directory."
        mkdir -p $REGOLITH_I3_CONFIG_DIR
        cp /etc/i3/config $REGOLITH_I3_CONFIG_FILE
fi

# Stage i3xrocks file
REGOLITH_I3XROCKS_CONFIG_DIR="$HOME/.config/i3xrocks"
if [ ! -d $REGOLITH_I3XROCKS_CONFIG_DIR ]; then
        echo "Copying default i3xrocks configuration to user directory."
        mkdir -p $REGOLITH_I3XROCKS_CONFIG_DIR
        cp /usr/share/i3xrocks/* REGOLITH_I3XROCKS_CONFIG_DIR
fi
