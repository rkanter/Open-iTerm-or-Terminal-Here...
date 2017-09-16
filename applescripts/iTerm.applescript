tell application "Finder" to set thePath to target of front window as alias
set thePath to quoted form of POSIX path of thePath

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
