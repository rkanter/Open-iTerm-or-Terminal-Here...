#!/bin/bash

generateApp() {
  name=$1
  iconName=$2
  appPath=/Applications/Open\ ${name}\ Here....app

  echo "Generating 'Open ${name} Here...' app"

  # This is necessary because we later change the permissions of the script file to read-only (for Mojave)
  # That prevents us from overwriting it now when regenerating the app
  if [ -d "$appPath" ]; then
	chmod 644 "${appPath}/Contents/Resources/Scripts/main.scpt"
  fi

  echo "Putting AppleScript into place"
  # Bundle the script into an Application
  osacompile -o "${appPath}" "applescripts/${name}.applescript"

  echo "Setting the icon"
  # Copy over the legit icon
  iconAppPath=$(osascript -e "tell application \"Finder\" to return  (POSIX path of (path to application \"${name}\"))")
  cp -f "${iconAppPath}Contents/Resources/${iconName}.icns" "${appPath}/Contents/Resources/applet.icns"

  # Do misc random stuff that would be hard to explain in an echo
  echo "Reticulating splines"
  # Set internal app property to make it not show up in the Dock
  # Otherwise, it looks weird because it opens and then closes <1 second later
  plutil -replace LSUIElement -bool YES  "${appPath}/Contents/Info.plist"
  # Make the script read-only
  # This is necessary to deal with Mojave where the app will sometimes prompt for permissions again if it changes
  # See https://github.com/rkanter/Open-iTerm-or-Terminal-Here.../issues/1 for details
  chmod 444 "${appPath}/Contents/Resources/Scripts/main.scpt"

  # Show the app in Finder
  echo "Opening app location in Finder"
  osascript -e "tell application \"Finder\" to reveal (POSIX file \"${appPath}\" as text)" > /dev/null
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
   exit 1
fi
