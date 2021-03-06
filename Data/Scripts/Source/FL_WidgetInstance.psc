Scriptname FL_WidgetInstance extends FL_WidgetBase  
{
Created by Teague Lander January 6th 2016
Objects of this type have basic functions that widgets should have like enabling visibility and fade in and fade out
}

FL_ConfigMenu Property FL_ConfigMenuQuest Auto
FL_CrosshairController Property FL_CrosshairControllerQuest Auto

string SOURCE = "box.swf"
float fUpdateInterval = 0.01



event OnInit()
	;GetSettingsFromConfigMenu() ;THIS gets the correct xy position but doesn't seem to affect scale or alpha even though it should
	RegisterForSingleUpdate(fUpdateInterval)
EndEvent

event OnWidgetReset()
	parent.OnWidgetReset()
	RegisterForSingleUpdate(fUpdateInterval)
endEvent

event OnUpdate()
	If (Ready)
		GetSettingsFromConfigMenu()
		UI.InvokeBool(HUD_MENU, WidgetRoot + ".setVis", true)
		FL_CrosshairControllerQuest.updateFLWidgetBuilder()
	Else
		RegisterForSingleUpdate(fUpdateInterval)
	EndIf
EndEvent

Function GetSettingsFromConfigMenu()
	FL_ConfigMenuQuest.applyWidgetSettings()
EndFunction

Function DisplayBuiltWidget(String containerName, String actionText, String[] itemNames, int arrowPosition, bool arrowVisible, bool[] blueText, bool[] redText, bool[] greyText)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setContainerName", containerName)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setActionText", actionText)
	int i = 0
	while i < 5
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setItemName" + i, itemNames[i])
		i += 1
	endWhile
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".setArrowPos", arrowPosition)
	UI.InvokeBool(HUD_MENU, WidgetRoot + ".setArrowVisible", arrowVisible)
	UI.InvokeBoolA(HUD_MENU, WidgetRoot + ".setMagicalColour", blueText)
	UI.InvokeBoolA(HUD_MENU, WidgetRoot + ".setStolenColour", redText)
	UI.InvokeBoolA(HUD_MENU, WidgetRoot + ".setGreyedColour", greyText)
	
EndFunction

Function SetSelectorPosition(int arrowPosition)
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".setArrowPos", arrowPosition)
EndFunction

Function SetSelectorVisible(bool arrowVisible)
	UI.InvokeBool(HUD_MENU, WidgetRoot + ".setArrowVisible", arrowVisible)
EndFunction

;LEGACY CAN PROBABLY DELETE
Function SetContainerName(String name)
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setContainerName", name)
EndFunction

Function SetMagicalColourValue(int color)
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".setMagicalColourValue", color)
EndFunction