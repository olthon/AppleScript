###################################
# ToggleTeleportSynergy
# 
# Toggle Teleport Synergy(Server)
###################################

property typeofsynergy : "cmd" -- "app" or "cmd"			//実行するSynergyのタイプ
property execmachinename : "Erica.local" -- uname -n		//実行するMachine
property synergycmd : "/Applications/Synergy.app/Contents/MacOS/synergys -f --no-tray --debug NOTE --name Erica.local -c /Users/ohton/synergyconf --address :24800 --daemon"

----------------------------------------------

-- Check machine
if (do shell script "uname -n") = execmachinename then
	
	-- Check SystemPreferences Running status
	(* 
	tell application "System Events"
		set SPisExist to exists application process "Synergy"
	end tell
 	*)
	
	if application "System Preferences" is running then
		set SPisExist to true
	else
		set SPisExist to false
	end if
	
	-- Check Synergy Running status
	if typeofsynergy is "app" then
		if application "Synergy" is running then
			set synergyisExist to true
		else
			set synergyisExist to false
		end if
	else
		do shell script "ps -ef |grep [s]ynergy|awk '{print $2}'"
		if result is not equal to "" then
			set synergyisExist to true
		else
			set PID to result as number
			set synergyisExist to false
		end if
	end if
	
	-- Activate SystemPreferences
	tell application "System Preferences"
		activate
		(*	set current pane to pane id "teleport" *)
	end tell
	(*
	-- Toggle teleport active state
	tell application "System Events"
		tell process "System Preferences"
			click menu item "teleport" of menu "View" of menu bar 1
			delay 2
			tell window "teleport"
				click checkbox "Activate teleport"
			end tell
		end tell
	end tell
*)
	-- Toggle with Synergy
	tell application "System Events"
		tell process "System Preferences"
			click menu item "teleport" of menu "View" of menu bar 1
			delay 2
			tell window "teleport"
				if (value of checkbox "Activate teleport") = 1 then
					if synergyisExist then
					else
						click checkbox "Activate teleport" -- Can I use "set value of checkbox "Activate teleport" to 0"?
					end if
				else
					if synergyisExist then
						click checkbox "Activate teleport"
					end if
				end if
			end tell
		end tell
	end tell
	
	-- Restore SystemPreferences pane
	if SPisExist then
		(* TODO: Restore current pane *)
	else
		tell application "System Preferences"
			quit
		end tell
	end if
	
	-- Toggle Synergy
	if synergyisExist then
		if typeofsynergy is "app" then
			display dialog "Please quit Synergy"
			(* TODO: quit Synergy*)
		else
			do shell script "ps -ef |grep [s]ynergy|awk '{print $2}'|xargs kill -9"
		end if
	else
		if typeofsynergy is "app" then
			tell application "Synergy"
				activate
			end tell
		else
			do shell script synergycmd
		end if
	end if
end if
