tell application "Finder"
	if (count of windows) > 0 then
		set thePath to target of front window
	else
		display dialog "There are no open Finder windows." with icon caution buttons {"OK"} default button "OK"
		return
	end if
end tell

if not (exists thePath) then
	tell application "Finder" to set theName to name of front window
	display dialog "The location of the Finder window \"" & theName & "\" is not a real location (e.g. smart folder, search, network, trash, etc) and cannot opened in Terminal." with icon caution buttons {"OK"} default button "OK"
	return
end if
set thePath to quoted form of POSIX path of (thePath as alias)

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
