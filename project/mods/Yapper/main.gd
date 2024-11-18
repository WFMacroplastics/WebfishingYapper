extends Node

const MOD_ID: String = "Yapper"

#var commands = preload("./commands.gd").new()
const tts_t := preload("./tts.gd")
const scene_filter_t := preload("./scene_filter.gd")

var tts: tts_t
var scene_filter: scene_filter_t

onready var KeybindsAPI := $"/root/BlueberryWolfiAPIs/KeybindsAPI"
onready var TackleBox := $"/root/TackleBox"

var config: Dictionary
var default_config: Dictionary = {
	"voice_speed": 0,
	"voice_pitch": 0,
	"voice_volume": 100,
	"dialog": true,
	"ui": true,
	"tooltip": true,
	"chat": false,
}

# stuff at the beginning has more priority over stuff at the end
# There might be a need for a better system than this
var source_list: Dictionary = {
	"dialogue": {"autosay": true},
	"tooltip": {"autosay": false, "current_text": [null, null]},
	"ui": {"autosay": false, "current_text": [null, null]},
	"chat": {"autosay": true},
}

func _enter_tree():
	tts = tts_t.new()
	scene_filter = scene_filter_t.new()
	self.add_child(tts)
	self.add_child(scene_filter)

func _ready():
	_init_config()
	_init_voice_config()
	var tts_key_signal = KeybindsAPI.register_keybind({
		"action_name": "toggle_tts",
		"title": "Toggle Mouseover TTS. Shift reads out extended description.",
		"key": KEY_R,
	})
	KeybindsAPI.connect(tts_key_signal + "_up", self, "_on_tts_button")

func _init_config() -> void:
	var saved_config = TackleBox.get_mod_config(MOD_ID)

	for key in default_config.keys():
		if not saved_config[key]: # If the config property isn't saved...
			saved_config[key] = default_config[key] # Set it to the default
	
	config = saved_config
	TackleBox.set_mod_config(MOD_ID, config)

# A call to this gets patched into the _ready function
# TODO: figure out a more fleshed out way to do this
func _init_voice_config():
	tts.set_rate(clamp(config["voice_speed"], -100, 100))
	tts.set_volume(clamp(config["voice_volume"], 0, 100))
	tts.set_pitch(clamp(config["voice_pitch"], -10, 10))

func _on_tts_button():
	print(source_list)
	var extended = Input.is_key_pressed(KEY_SHIFT)

	for src in source_list.values():
		if src["autosay"]: continue

		var cur_txt = src["current_text"]
		var phrase = cur_txt[0]
		if extended and cur_txt[1] != null:
			phrase = cur_txt[1]

		if phrase == null: continue

		tts.speak(phrase)
		break

func _queue(source: String, header: String, body = null):
	if config[source] == false: return

	var cur_src = source_list[source]

	if cur_src["autosay"]:
		tts.speak(header)
	else:
		cur_src["current_text"][0] = header
		cur_src["current_text"][1] = body

func _dequeue(source: String):
	if not source in source_list: return
	var cur_src = source_list[source]

	cur_src["current_text"][0] = null
	cur_src["current_text"][1] = null
