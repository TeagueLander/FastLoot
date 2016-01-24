Scriptname FL_ConfigMenu extends SKI_ConfigBase
{
Created by Teague Lander January 6th 2016
Called by the quest of the same name
Creates a MCM Menu to control mod options ie. the position of the UI element
}

;Properties
FL_WidgetInstance Property FL_WidgetQuest Auto

;OPTIONS
	;X-Slider
	int HorizontalOffset_S ;Displayed Slider
	float fHorizontalDefault = 53.0
	float fHorizontalOffsetValue = 53.0
	;Y-Slider
	int VerticalOffset_S ;Displayed Slider
	float fVerticalDefault = 13.0
	float fVerticalOffsetValue = 13.0
	;Scale-Slider
	int Scale_S
	float fScaleValue = 120.0
	float fScaleDefault = 120.0
	;Alpha-Slider
	int Alpha_S
	float fAlphaValue = 75.0
	float fAlphaDefault = 75.0
	float fAlphaMaxValue = 800.0
	
;SCREEN CONTANTS
float fOffsetInterval = 1.0
float fScaleInterval = 1.0
float fAlphaInterval = 1.0
string sSliderFormat = "{0}%"

;LANGUAGE
string sOffsetLabel = "Widget Offset"
string sHorizontalOffsetLabel = "Horizontal Offset"
string sVerticalOffsetLabel = "Vertical Offset"
string sMiscLabel = "Misc"
string sScaleLabel = "$Scale"
string sAlphaLabel = "Transparency"

event OnConfigClose()
    { Called when the config menu is closed }
	applyWidgetSettings()
endEvent

event OnPageReset(string page)
	;Build the MCM Page
		SetCursorFillMode(TOP_TO_BOTTOM)
		
		;Offset
		AddHeaderOption(sOffsetLabel)
		HorizontalOffset_S = AddSliderOption(sHorizontalOffsetLabel, fHorizontalOffsetValue, sSliderFormat)
		VerticalOffset_S = AddSliderOption(sVerticalOffsetLabel, fVerticalOffsetValue, sSliderFormat)
		
		;Misc
		AddHeaderOption(sMiscLabel)
		Scale_S = AddSliderOption(sScaleLabel, fScaleValue, sSliderFormat)
		Alpha_S = AddSliderOption(sAlphaLabel, fAlphaValue, sSliderFormat)
endEvent

event OnOptionSliderOpen(int option)
	if (option == HorizontalOffset_S)
		SetSliderDialogStartValue(fHorizontalOffsetValue)
		SetSliderDialogDefaultValue(fHorizontalDefault)
		SetSliderDialogRange(0.0, 100)
		SetSliderDialogInterval(fOffsetInterval)
	elseIf (option == VerticalOffset_S)
		SetSliderDialogStartValue(fVerticalOffsetValue)
		SetSliderDialogDefaultValue(fVerticalDefault)
		SetSliderDialogRange(0.0, 100)
		SetSliderDialogInterval(fOffsetInterval)
	elseIf (option == Alpha_S)
		SetSliderDialogStartValue(fAlphaValue)
		SetSliderDialogDefaultValue(fAlphaDefault)
		SetSliderDialogRange(0.0, 100)
		SetSliderDialogInterval(fAlphaInterval)
	elseIf (option == Scale_S)
		SetSliderDialogStartValue(fScaleValue)
		SetSliderDialogDefaultValue(fScaleDefault)
		SetSliderDialogRange(0.0, fAlphaMaxValue)
		SetSliderDialogInterval(fScaleInterval)
	endIf
endEvent

event OnOptionSliderAccept(int option, float value)
	if (option == HorizontalOffset_S)
		fHorizontalOffsetValue = value
		SetSliderOptionValue(HorizontalOffset_S, fHorizontalOffsetValue, sSliderFormat)
	elseIf (option == VerticalOffset_S)
		fVerticalOffsetValue = value
		SetSliderOptionValue(VerticalOffset_S, fVerticalOffsetValue, sSliderFormat)
	elseIf (option == Alpha_S)
		fAlphaValue = value
		SetSliderOptionValue(Alpha_S, fAlphaValue, sSliderFormat)
	elseIf (option == Scale_S)
		fScaleValue = value
		SetSliderOptionValue(Scale_S, fScaleValue, sSliderFormat)
	endIf
endEvent

event OnOptionDefault(int option)
	if (option == HorizontalOffset_S)
		fHorizontalOffsetValue = fHorizontalDefault
		SetSliderOptionValue(HorizontalOffset_S, fHorizontalOffsetValue, sSliderFormat)
	elseIf (option == VerticalOffset_S)
		fVerticalOffsetValue = fVerticalDefault
		SetSliderOptionValue(VerticalOffset_S, fVerticalOffsetValue, sSliderFormat)
	elseIf (option == Alpha_S)
		fAlphaValue = fAlphaDefault
		SetSliderOptionValue(Alpha_S, fAlphaValue, sSliderFormat)
	elseIf (option == Scale_S)
		fScaleValue = fScaleDefault
		SetSliderOptionValue(Scale_S, fScaleValue, sSliderFormat)
	endIf
endEvent

function applyWidgetSettings()
	FL_WidgetQuest.setPosition(fHorizontalOffsetValue,fVerticalOffsetValue)
	FL_WidgetQuest.SetOutlineBoxAlpha(fAlphaValue)
	FL_WidgetQuest.SetUIScale(fScaleValue)
endfunction
		
