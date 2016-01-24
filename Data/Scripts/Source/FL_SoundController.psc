Scriptname FL_SoundController extends Quest  

Sound Property GoldSound Auto
Sound Property MiscSound Auto
Sound Property ArmorSound Auto
Sound Property PotionSound Auto
Sound Property WeaponSound Auto
Sound Property ArrowSound Auto
Sound Property KeySound Auto
Sound Property BookSound Auto
float iSoundVolume = 1.0

;Special Objects
MiscObject Property goldForm Auto ;We can delete this

;Plays a sound that corresponds to this form
function PlayPickupSound(Form playingForm)

	int soundID = GetPickupSoundFromForm(playingForm).play(Game.GetPlayer())
	Sound.SetInstanceVolume(soundID, iSoundVolume)
	
endfunction

Sound function GetPickupSoundFromForm(Form playingForm)
	int typeCode = playingForm.GetType()
	;Debug.Notification(typeCode)
	if (playingForm == goldForm)
		return GoldSound
	elseif (typeCode == 26)
		return ArmorSound
	elseif (typeCode == 41)
		return WeaponSound
	elseif (typeCode == 46)
		return PotionSound
	elseif (typeCode == 42)
		return ArrowSound
	elseif (typeCode == 45)
		return KeySound
	elseif (typeCode == 27)
		return BookSound
	else
		return MiscSound
	endif 
endfunction