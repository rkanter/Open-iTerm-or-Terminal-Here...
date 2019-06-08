tell application "Finder"
	if (count of windows) > 0 then
		set thePath to target of front window
	else
		display dialog "There are no open Finder windows." with icon caution buttons {"OK"} with title "Open iTerm Here..."
		return
	end if
end tell

if not (exists thePath) then
	tell application "Finder" to set theName to name of front window
	display dialog "The location of the Finder window \"" & theName & "\" is not a real location (e.g. smart folder, search, network, trash, etc) and cannot opened in iTerm." with icon caution buttons {"OK"} with title "Open iTerm Here..."
	return
end if
set thePath to quoted form of POSIX path of (thePath as alias)

tell application "iTerm"
	-- Handles the case where iTerm is running but has no windows
	set createdWindow to false
	if it is running then
		if (count windows) is 0 then
			create window with default profile
			set createdWindow to true
		end if
	end if
	if not createdWindow then
		tell current window
			create tab with default profile
			tell current tab
				launch session
				tell the last session
					write text "cd " & thePath & " && clear"
				end tell
			end tell
		end tell
	end if
	activate
end tell
