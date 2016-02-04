Scriptname FL_WidgetBase extends SKI_WidgetBase  
{
Created by Teague Lander January 6th 2016
Objects of this type have basic functions that widgets should have like enabling visibility and fade in and fade out
}

;CONSTANTS
string SOURCE = "box.swf"
bool _visible = true
float fFadeTime = 0.2 ;Should be made no less than this or we will see text changings
float fOutlineBoxAlpha = 75.0
int screenWidth
int screenHeight

;PROPERTIES
bool Property Visible
	bool function get()
		return _visible
	endFunction

	function set(bool a_val)
		_visible = a_val
		if (Ready)
			UI.InvokeBool(HUD_MENU, WidgetRoot + ".setVisible", _visible)
		endIf
	endFunction
endProperty


; EVENTS

; @override SKI_WidgetBase
event OnWidgetReset()
	parent.OnWidgetReset()
endEvent


;FUNCTIONS
Function setPosition(float xPercent, float yPercent)
	screenWidth = 1280;Utility.GetIniInt("iSize W:Display")
	screenHeight = 720;Utility.GetIniInt("iSize H:Display")
	X = screenWidth*xPercent/100
	Y = screenHeight*yPercent/100
EndFunction

function setAlpha(float a1) ;Legacy function: using SetOutlineBoxAlpha looks better
	Alpha = a1
endFunction

function SetOutlineBoxAlpha(float a1)
	fOutlineBoxAlpha = a1
	UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setOutlineBoxAlpha", a1)
endfunction

function setUIScale(float scale)
	UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setScale", scale)
EndFunction

; @overrides SKI_WidgetBase
string function GetWidgetSource()
	return SOURCE
endFunction

; @overrides SKI_WidgetBase
string function GetWidgetType()
	return "FL_WidgetBase"
	; Must be the same as scriptname
endFunction

function FadeInWidget()
	if(Ready)
		FadeTo(Alpha, fFadeTime)
	endIf
endFunction

function FadeOutWidget()
	if(Ready)
		FadeTo(0, fFadeTime)
	endIf
endFunction


