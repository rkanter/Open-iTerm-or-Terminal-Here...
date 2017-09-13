#!/bin/bash

# TODO:
# Make the Terminal applescript do a new tab instead of a new window
# what if the file already exists?
# error handling
# clean up, etc


generateApp() {
  name=$1
  iconName=$2

  echo "Preparing to generate 'Open ${name} Here...' app"

  # Bundle the iTerm script into an Application
  echo "Putting AppleScript into place"
  osacompile -o /Applications/Open\ ${name}\ Here....app applescripts/${name}.scpt

  # Copy over the legit icon
  echo "Setting the icon"
  appPath=$(osascript -e "tell application \"Finder\" to return  (POSIX path of (path to application \"${name}\"))")
  cp -f ${appPath}Contents/Resources/${iconName}.icns /Applications/Open\ ${name}\ Here....app/Contents/Resources/applet.icns

  # Set internal app property to make it not show up in the Dock
  # Otherwise, it looks weird because it opens and then closes <1 second later
  echo "Reticulating splines"
  plutil -replace LSUIElement -bool YES  /Applications/Open\ ${name}\ Here....app/Contents/Info.plist

  # Show the app in Finder
  echo "Opening app location in Finder"
  osascript -e "tell application \"Finder\" to reveal (POSIX file \"/Applications/Open ${name} Here....app\" as text)" > /dev/null
  osascript -e "tell application \"Finder\" to activate"

  echo "Done"
}


type=$1

if [ "$type" == "iterm" ]
then
  generateApp "iTerm" "AppIcon"
elif [ "$type" == "terminal" ]
then
  generateApp "Terminal" "Terminal"
else
   echo "usage: generate.sh [iterm|terminal]"
   exit -1
fi

