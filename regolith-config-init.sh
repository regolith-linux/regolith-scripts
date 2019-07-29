#!/bin/bash

REGOLITH_I3_CONFIG_DIR="$HOME/.config/i3-regolith"
PKG_VERSION=`dpkg -s regolith-styles | grep '^Version:' | awk '{print $2}'`
UPDATE_FLAG_PATH="$REGOLITH_I3_CONFIG_DIR/config-flag-$PKG_VERSION"

# Load Xresources
if [ -f ~/.Xresources ]; then
        echo "Loading default Xresources."
        xrdb -merge ~/.Xresources
fi

UPDATE_POLICY=`xrescat regolith.policy.update true`
REGOLITH_XRES_ROOT="$HOME/.Xresources-regolith-$PKG_VERSION"

# If new version of regolith-gnome-flashback, stage Xresources.
if [ "$UPDATE_POLICY" = true ] && [ ! -f $UPDATE_FLAG_PATH ]; then
        echo "Staging Regolith styles."
        cp /usr/share/regolith-styles/root $REGOLITH_XRES_ROOT
        if [ ! -d ~/.Xresources.d ]; then
                mkdir ~/.Xresources.d
        fi
        cp /usr/share/regolith-styles/* ~/.Xresources.d/
        rm ~/.Xresources.d/root
fi

# Reload Regolith Xresources
if [ -f $REGOLITH_XRES_ROOT ]; then
        echo "Loading regolith Xresources."
        xrdb -merge $REGOLITH_XRES_ROOT
fi

# Stage i3 config file
I3_PKG_VERSION=`dpkg -s regolith-i3-wm | grep '^Version:' | awk '{print $2}'`
REGOLITH_I3_CONFIG_FILE="$REGOLITH_I3_CONFIG_DIR/config-$I3_PKG_VERSION"
if [ "$UPDATE_POLICY" = true ] && [ ! -f $REGOLITH_I3_CONFIG_FILE ]; then
        echo "Copying default Regolith i3 configuration to user directory."
        mkdir -p $REGOLITH_I3_CONFIG_DIR
        cp /etc/i3/config $REGOLITH_I3_CONFIG_FILE
fi

# Stage i3xrocks file
REGOLITH_I3XROCKS_CONFIG_DIR="$HOME/.config/i3xrocks"
REGOLITH_I3XROCKS_CONFIG_FILE="$REGOLITH_I3XROCKS_CONFIG_DIR/i3xrocks.conf"
if [ "$UPDATE_POLICY" = true ] && [ ! -f $REGOLITH_I3XROCKS_CONFIG_FILE ]; then
        echo "Copying default i3xrocks configuration to user directory."
        mkdir -p $REGOLITH_I3XROCKS_CONFIG_DIR
        cp /usr/share/i3xrocks/* $REGOLITH_I3XROCKS_CONFIG_DIR
fi

# The following stanza is to set Regolith-specific changes to default Ubuntu settings.
if [ "$UPDATE_POLICY" = true ] && [ ! -f $UPDATE_FLAG_PATH ]; then
        echo "Executing regolith session configuration script for $PKG_VERSION."

        # Required for i3 and gnome-shell to coexist
        gsettings set org.gnome.desktop.background show-desktop-icons false
        gsettings set org.gnome.gnome-flashback desktop-background true


        # Remap default keyboard switch keybindings to avoid collision w/ i3
        gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt><Super>BackSpace']"
        gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift><Alt><Super>BackSpace']"

        # Set the theme
        gsettings set org.gnome.desktop.interface gtk-theme "`xrescat gnome.gtk.theme SolArc-Dark`"
        gsettings set org.gnome.desktop.wm.preferences theme "`xrescat gnome.wm.theme SolArc-Dark`"
        gsettings set org.gnome.desktop.interface icon-theme "`xrescat gnome.icon.theme Arc`"

        # Set the wallpaper
        gsettings set org.gnome.desktop.background picture-uri `xrescat gnome.wallpaper.uri "file:///usr/share/backgrounds/ESP_020528_1750_desktop.jpg"`

        # Only run this script once per package version per user login session.
        touch $UPDATE_FLAG_PATH
fi
