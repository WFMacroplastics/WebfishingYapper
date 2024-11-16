extends Node

#var commands = preload("./commands.gd").new()
const tts_t := preload("./tts.gd")
const scene_filter_t := preload("./scene_filter.gd")

var tts: tts_t
var scene_filter: scene_filter_t

onready var KeybindsAPI = get_node_or_null("/root/BlueberryWolfiAPIs/KeybindsAPI")

# stuff at the beginning has more priority over stuff at the end
var source_list: Dictionary = {
	"dialogue": {"enabled": true, "autosay": true},
	"tooltip": {"enabled": true, "autosay": false, "current_text": [null, null]},
	"ui": {"enabled": true, "autosay": false, "current_text": [null, null]},
}

func _enter_tree():
	tts = tts_t.new()
	scene_filter = scene_filter_t.new()
	self.add_child(tts)
	self.add_child(scene_filter)

func _ready():
	var tts_key_signal = KeybindsAPI.register_keybind({
		"action_name": "toggle_tts",
		"title": "Toggle Mouseover TTS. Shift reads out extended description.",
		"key": KEY_R,
	})
	KeybindsAPI.connect(tts_key_signal + "_up", self, "_on_tts_button")

# A call to this gets patched into the _ready function
# TODO: figure out a more fleshed out way to do this
func _init_voice_config(speed: int):
	tts.set_rate(clamp(speed, 0, 100))

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
