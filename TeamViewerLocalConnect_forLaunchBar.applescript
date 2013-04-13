###################################
# For TeamViewer8
#  Connect to local teamviewer by Mac Name(Samba host name)
#
# "LaunchBar with arg Action" or "Default Action"
#			 : default "LaunchBar with arg Action"
###################################

#property DEFAULTMACNAME : "MyMac" -- Default Mac Name for dialog using "Default Action"

----------------------------------------------
-- Activate TeamViewer, Search IP with Mac Name by smbutil, Connect!
on myFunc(MACNAME)
	do shell script "open -a /Applications/TeamViewer\\ 8/TeamViewer.app"
	do shell script "smbutil lookup " & MACNAME & "|grep response |awk '{print $4}'"
	set PartnerID to result
	tell application "System Events"
		tell process "TeamViewer"
			tell window "TeamViewer"
				tell group 1
					set value of combo box 1 to PartnerID
					click button "Connect to partner"
				end tell
			end tell
		end tell
	end tell
end myFunc

-- For "LaunchBar with arg Action"
on handle_string(MACNAME)
	myFunc(MACNAME)
end handle_string


-- For Default Action
(*
display dialog "Mac Machine Name:" default answer DEFAULTMACNAME
set MACNAME to text returned of result
myFunc(MACNAME)
*)
