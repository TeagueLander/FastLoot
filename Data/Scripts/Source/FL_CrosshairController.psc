Scriptname FL_CrosshairController extends Quest  
{
Created by Teague Lander January 6th 2016
Called by the quest of the same name
Controls the crosshair and input keys
}
FL_WidgetBuilder Property FL_BuilderQuest Auto
FormList Property FL_FormList Auto
Actor Property PlayerRef Auto
MiscObject Property NodeType Auto
float fUpdateInterval = 0.02 ;This determines how often we check to make sure the widget isn't left on the screen
ObjectReference curRef

int iScrollDownKey
int iScrollUpKey
int iActivateKey
int iTransferKey
bool  bInputAllowed = true
bool bMenuOpen = false

;INPUT Queue
;FL_FormNode inputRoot
;FL_FormNode inputTail

bool Property InputAllowed
	bool function get()
		return bInputAllowed
	endFunction
	function set(bool a_val)
		bInputAllowed = a_val
	endFunction
endProperty

Event OnInit()

	registerInput()
	;inputRoot = Game.GetPlayer().PlaceAtMe(NodeType) as FL_FormNode
	;inputTail = inputRoot
	RegisterForSingleUpdate(fUpdateInterval)
	
	;REGISTER MENUS
	RegisterForMenu("BarterMenu")
	RegisterForMenu("Book Menu")
	RegisterForMenu("Console")
	RegisterForMenu("Console Native UI Menu")
	RegisterForMenu("ContainerMenu")
	RegisterForMenu("Crafting Menu")
	RegisterForMenu("Credits Menu")
	RegisterForMenu("Cursor Menu")
	RegisterForMenu("Debug Text Menu")
	RegisterForMenu("Dialogue Menu")
	RegisterForMenu("Fader Menu")
	RegisterForMenu("FavoritesMenu")
	RegisterForMenu("GiftMenu")
	RegisterForMenu("HUD Menu")
	RegisterForMenu("InventoryMenu")
	RegisterForMenu("Journal Menu")
	RegisterForMenu("Kinect Menu")
	RegisterForMenu("LevelUp Menu")
	RegisterForMenu("Loading Menu")
	RegisterForMenu("Lockpicking Menu")
	RegisterForMenu("MagicMenu")
	RegisterForMenu("Main Menu")
	RegisterForMenu("MapMenu")
	RegisterForMenu("MessageBoxMenu")
	RegisterForMenu("Mist Menu")
	RegisterForMenu("Overlay Interaction Menu")
	RegisterForMenu("Overlay Menu")
	RegisterForMenu("Quantity Menu")
	RegisterForMenu("RaceSex Menu")
	RegisterForMenu("Sleep/Wait Menu")
	RegisterForMenu("StatsMenu")
	RegisterForMenu("TitleSequence Menu")
	RegisterForMenu("Top Menu")
	RegisterForMenu("Training Menu")
	RegisterForMenu("Tutorial Menu")
	RegisterForMenu("TweenMenu")	
EndEvent

;Check for a new object every update
Event OnUpdate()
	if (Game.GetCurrentCrosshairRef() != curRef)
		curRef = Game.GetCurrentCrosshairRef()
		updateFLWidgetBuilder()	
	endif
	RegisterForSingleUpdate(fUpdateInterval)
EndEvent

Event OnMenuOpen(String menu)
	FL_BuilderQuest.removeAndResetWidget()
EndEvent

Event OnMenuClose(String menu)
	if (!Utility.IsInMenuMode())
		curRef = none;Game.GetCurrentCrosshairRef()
		updateFLWidgetBuilder()
	endif
EndEvent

Event OnKeyDown(int keycode)
	if (!Utility.IsInMenuMode())
		if (bInputAllowed)
			if (keycode == iScrollDownKey); || keycode == 208)
				FL_BuilderQuest.scrollDown()
			elseif (keycode == iScrollUpKey); || keycode == 200)
				FL_BuilderQuest.scrollUp()
			elseif (keycode == iTransferKey)
				curRef.Activate(PlayerRef,true)
			elseif (keycode == iActivateKey)
				if (curRef)
					FL_BuilderQuest.takeItem()
				endif
			endif
		else 
		
		endif
	endif
EndEvent

function updateFLWidgetBuilder() ;test formlist and dead body
	;REPLACE FORMLIST HERE
	;instead of checking containers just check to see if it can hold items?
	If (curRef as Actor).isDead() || ((curRef.GetBaseObject() as Container) && !curRef.isLocked() )
		DisableConflictingActions()
		FL_BuilderQuest.buildWidgetFromObj(curRef)
	Else
		EnableConflictingActions()
		FL_BuilderQuest.removeAndResetWidget()
	EndIf
	;Ensures this function is only run when a new object is found under the crosshair
	
endfunction

function registerInput()
	UnregisterForKey(iScrollDownKey)
	if Game.UsingGamePad()
		iScrollDownKey = 267
	else
		iScrollDownKey = Input.GetMappedKey("Zoom Out")
	endif
	RegisterForKey(iScrollDownKey)
	
	UnregisterForKey(iScrollUpKey)
	if Game.UsingGamePad()
		iScrollUpKey = 266
	else
		iScrollUpKey = Input.GetMappedKey("Zoom In")
	endif
	RegisterForKey(iScrollUpKey)
	
	UnregisterForKey(iActivateKey)
	iActivateKey = Input.GetMappedKey("Activate")
	RegisterForKey(iActivateKey)
	
	UnregisterForKey(iTransferKey)
	iTransferKey = 34;Input.GetMappedKey("Ready Weapon")
	RegisterForKey(iTransferKey)
	
endfunction

function DisableConflictingActions()
	curRef.BlockActivation()
	Game.DisablePlayerControls(false, false, true, false, false, false, false)
endfunction

function EnableConflictingActions()
	curRef.BlockActivation(false)
	Game.EnablePlayerControls(false, false, true, false, false, false, false)
endfunction

;Queue input functions
;function push(int keycode)
;	inputTail.NextNode = Game.GetPlayer().PlaceAtMe(NodeType) as FL_FormNode
;	inputTail = inputTail.NextNode
;	inputTail.Amount = keycode
;endFunction

;int function pop()
;	int keycode = inputRoot.NextNode.Amount
;	inputRoot.NextNode.deleteNode()
;	return keycode
;endFunction