extends Panel

onready var tts = $"/root/Yapper/TTS"
onready var speaker_picker: OptionButton = $"%SpeakerPicker"

var local_volume
var local_speed
var local_pitch

var voices

# TODO: set dropdown to right value from config
func _ready():
	voices = tts.get_voices()
	for v in voices:
		var readable_name = v["name"]
		readable_name = readable_name.replace("com.apple.speech.synthesis.voice.", "")
		readable_name = readable_name.replace("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Speech\\Voices\\Tokens\\", "")
		speaker_picker.add_item(readable_name)
		speaker_picker.set_item_metadata(speaker_picker.get_item_count() - 1, v["name"])

func _on_close_pressed():
	queue_free()

func _on_SpeakerPicker_item_selected(index):
	tts.set_voice(speaker_picker.get_item_metadata(index))

func _on_VolumeSlider_drag_ended(value_changed):
	tts.set_volume(local_volume)

func _on_SpeedSlider_drag_ended(value_changed):
	tts.set_rate(local_speed)

func _on_PitchSlider_drag_ended(value_changed):
	tts.set_pitch(local_pitch)


func _on_VolumeSlider_value_changed(value):
	local_volume = value

func _on_SpeedSlider_value_changed(value):
	local_speed = value

func _on_PitchSlider_value_changed(value):
	local_pitch = value
