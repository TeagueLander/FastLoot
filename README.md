NOTE FOR ANYONE WHO WANTS TO MODIFY THIS CODE:
Skyrim runs scripts asynchonyously which can lead to some unusual behaviour (ie You are trying to access a few nodes but they are being deleted by another function as you access them).
The mod accounts for the cases where this might happen.  Ensure conflicting functions/events are queued up or don't occur when called.

Adds the Fallout 4 looting system to Skyrim.  For those who haven't played F4, this mod pops up a menu when you look at a container and lets you take items out without going into any menus, dramatically decreasing the amount of time you spend opening containers!  

Requires: 
-SKSE 
-SkyUI 

Issues:
- Please quicksave and quickload up to 2 times if the popup is not showing up (only has to be done the first time you use the mod).
- People with other UI mods such as iHud have reported that the popup does not show up.  Being looked into.
- Taking items is mapped to 'Activate' (usually 'E") which means transfer has been moved to 'G', which is not mappable yet.
- No controller support yet
- People who loot in 3rd person may have trouble scrolling through items on the popup.

To Do: 
-Controller support
-Block containers from opening when they are first unlocked 
-Make it a crime to steal 
-Remove Skyrim Activation text 
-Test functionality with quest specific containers and items

Changelog:
v0.2
-MCM Menu added
-Properly controllable with the mouse scroll wheel! (this might cause slight problems if you are in 3rd person and try to loot things). 
-The UI popup comes up faster now, to be improved further 
-Magical items will show up with blue text (NOTE: Player enchanted items will have their default name and default magical status but still remove from containers properly, this problem is unlikely to be fixed) 
-Unusable items (such as Giant's Club) are Greyed out and cannot be taken 
-Some basic sounds are implemented (unlikely to ever have all the proper pickup sounds)
