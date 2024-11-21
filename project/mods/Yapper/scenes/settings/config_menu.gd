extends Control

onready var Yapper := $"/root/Yapper"
onready var tts := $"/root/Yapper/TTS"
onready var TackleBox := $"/root/TackleBox"

onready var speaker_picker: OptionButton = $"%SpeakerPicker"

var local_volume
var local_speed
var local_pitch

var voices

# TODO: set dropdown to right value from config
func _ready():
	voices = tts.get_voices()
	var cur_voice = Yapper.config.voice
	for v in voices:
		var readable_name = v["name"]
		readable_name = readable_name.replace("com.apple.speech.synthesis.voice.", "")
		readable_name = readable_name.replace("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Speech\\Voices\\Tokens\\", "")
		speaker_picker.add_item(readable_name)
		var id = speaker_picker.get_item_count() - 1
		speaker_picker.set_item_metadata(id, v["name"])
		if cur_voice == v["name"]:
			speaker_picker.select(id)

	$"%VolumeSlider".value = Yapper.config.voice_volume
	$"%SpeedSlider".value  = Yapper.config.voice_speed
	$"%PitchSlider".value  = Yapper.config.voice_pitch

func _on_close_pressed():
	queue_free()

func _set_tacklebox_cfg(key: String, value):
	var cfg = Yapper.config.duplicate()
	cfg[key] = value
	TackleBox.set_mod_config(Yapper.MOD_ID, cfg)


# TODO: HANDLE ERROR
func _on_SpeakerPicker_item_selected(index):
	var selected_voice = speaker_picker.get_item_metadata(index)
	_set_tacklebox_cfg("voice", selected_voice)

func _on_VolumeSlider_drag_ended(value_changed):
	_set_tacklebox_cfg("voice_volume", local_volume)

func _on_SpeedSlider_drag_ended(value_changed):
	_set_tacklebox_cfg("voice_speed", local_speed)

func _on_PitchSlider_drag_ended(value_changed):
	_set_tacklebox_cfg("voice_pitch", local_pitch)


func _on_VolumeSlider_value_changed(value):
	local_volume = value

func _on_SpeedSlider_value_changed(value):
	local_speed = value

func _on_PitchSlider_value_changed(value):
	local_pitch = value
