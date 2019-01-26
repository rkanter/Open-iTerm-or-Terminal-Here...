tell application "Finder" to set thePath to target of front window as alias
set thePath to quoted form of POSIX path of thePath

tell application "Terminal"
	if it is running then
		-- This seems to be the only way to tell Terminal to open a new tab
		tell application "System Events"
			tell application process "Terminal"
				set frontmost to true
				try
					keystroke "t" using command down
				on error errMsg
					set msg to "Error: " & errMsg & "

This probably means that you're using Mojave and you will need to add this app to the \"Accessibility\" section in the \"Privacy\" tab of the \"Security & Privacy\" System Preferences.

Please see the \"Mojave\" section of the README for more details"
					display dialog msg buttons {"OK"} with icon caution
					return
				end try
			end tell
		end tell
		do script "cd " & thePath & " && clear" in last tab of front window
	else
		do script "cd " & thePath & " && clear"
	end if
	activate
end tell
