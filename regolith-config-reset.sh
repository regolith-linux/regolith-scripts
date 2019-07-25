#!/bin/bash

DEST_DIR=$HOME/regolith-config-backup-`date +%Y%m%d%H%M%S`

cp -rv $HOME/.Xresources.d $DEST_DIR
cp -rv $HOME/.Xresources-regolith $DEST_DIR
cp -rv $HOME/.config/i3-regolith $DEST_DIR
cp -rv $HOME/.config/i3xrocks $DEST_DIR

echo "\nCopied all Regolith configuration files to $DEST_DIR"

rm -Rf $HOME/.config/i3-regolith
rm -Rf $HOME/.config/i3xrocks
rm -Rf $HOME/.Xresources-regolith
rm -Rf $HOME/.Xresources.d

echo "\nRemoved Regolith configuration files.  Please log back in to reload, or run regolith-config-init.sh."