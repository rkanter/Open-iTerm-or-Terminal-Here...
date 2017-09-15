tell application "Finder" to set thePath to target of front window as alias
tell application "Terminal" to open thePath
tell application "Terminal" to activate
