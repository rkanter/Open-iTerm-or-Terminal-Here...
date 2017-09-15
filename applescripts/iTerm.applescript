tell application "Finder" to set thePath to target of front window as alias
set thePath to quoted form of POSIX path of thePath

tell application "iTerm"
	tell current window
		create tab with default profile
		tell current tab
			launch session
			tell the last session
				write text "cd " & thePath & " && clear"
			end tell
		end tell
	end tell
	activate
end tell
