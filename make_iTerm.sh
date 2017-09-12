#!/bin/bash

# TODO:
# Parameterize this with default values
# Make common script for Terminal version
# printouts
# what if the file already exists?
# error handling
# clean up, etc


# Bundle the iTerm script into an Application
osacompile -o /Applications/Open\ iTerm\ Here....app applescripts/iTerm.scpt

# Copy over the iTerm icon
itermPath=$(osascript -e "tell application \"Finder\" to return  (POSIX path of (path to application \"iTerm\"))")
cp -f ${itermPath}Contents/Resources/AppIcon.icns /Applications/Open\ iTerm\ Here....app/Contents/Resources/applet.icns

# Set internal app property to make it not show up in the Dock
# Otherwise, it looks weird because it opens and then closes <1 second later
plutil -replace LSUIElement -bool YES  /Applications/Open\ iTerm\ Here....app/Contents/Info.plist
