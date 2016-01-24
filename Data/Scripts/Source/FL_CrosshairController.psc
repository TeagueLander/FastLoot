Scriptname FL_CrosshairController extends Quest  
{
Created by Teague Lander January 6th 2016
Called by the quest of the same name
Controls the crosshair and input keys
}
FL_WidgetBuilder Property FL_BuilderQuest Auto
FormList Property FL_FormList Auto
float fUpdateInterval = 0.01 ;This determines how often we check to make sure the widget isn't left on the screen
ObjectReference curRef

int iScrollDownKey
int iScrollUpKey
int iActivateKey
int iTransferKey
bool  bInputAllowed = true

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
	RegisterForSingleUpdate(fUpdateInterval)
	;RegisterForCrosshairRef()
	
EndEvent

;Check for a new object every update
Event OnUpdate()
	if (!UI.IsMenuOpen("Console"))
		if (Game.GetCurrentCrosshairRef() != curRef)
			curRef = Game.GetCurrentCrosshairRef()
			updateFLWidgetBuilder()	
		endif
	else
		FL_BuilderQuest.removeAndResetWidget()
	endif
	RegisterForSingleUpdate(fUpdateInterval)
EndEvent

Event OnKeyDown(int keycode)
	if (bInputAllowed)
		if (keycode == iScrollDownKey); || keycode == 208)
			FL_BuilderQuest.scrollDown()
		elseif (keycode == iScrollUpKey); || keycode == 200)
			FL_BuilderQuest.scrollUp()
		elseif (keycode == iTransferKey)
			;FL_BuilderQuest.removeAndResetWidget()
			curRef.Activate(Game.GetPlayer(),true)
		elseif (keycode == iActivateKey)
			FL_BuilderQuest.takeItem()
		endif
	endif
EndEvent

function updateFLWidgetBuilder() ;test formlist and dead body
	;REPLACE FORMLIST HERE
	;instead of checking containers just check to see if it can hold items?
	If (curRef as Actor).isDead() || (curRef.GetBaseObject() as Container) ;(curRef as Actor).isDead() || (FL_FormList.Find(curRef.GetBaseObject()) != -1  && !curRef.isLocked() )
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
	iScrollDownKey = Input.GetMappedKey("Zoom Out")
	RegisterForKey(iScrollDownKey)
	
	UnregisterForKey(iScrollUpKey)
	iScrollUpKey = Input.GetMappedKey("Zoom In")
	RegisterForKey(iScrollUpKey)
	
	UnregisterForKey(iActivateKey)
	iActivateKey = Input.GetMappedKey("Activate")
	RegisterForKey(iActivateKey)
	
	;This should change
	UnregisterForKey(iTransferKey)
	iTransferKey = 34  ;Input.GetMappedKey("Ready Weapon")
	RegisterForKey(iTransferKey)
	
	;This is only for testing
	;RegisterForKey(200)
	;RegisterForKey(208)
endfunction

function DisableConflictingActions()
	curRef.BlockActivation()
	Game.DisablePlayerControls(false, false, true, false, false, false, false)
endfunction

function EnableConflictingActions()
	curRef.BlockActivation(false)
	Game.EnablePlayerControls(false, false, true, false, false, false, false)
endfunction
