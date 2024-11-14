extends Node

const commands = preload("./commands.gd")
var tts = preload("./tts.gd").new()
onready var KeybindsAPI = get_node_or_null("/root/BlueberryWolfiAPIs/KeybindsAPI")

# stuff at the beginning has more priority over stuff at the end
var source_list: Dictionary = {
	"dialog": {"enabled": true, "autosay": true},
	"tooltip": {"enabled": true, "autosay": false, "current_text": [null, null]},
	"ui": {"enabled": true, "autosay": false, "current_text": [null, null]},
}

func _ready():
	var tts_key_signal = KeybindsAPI.register_keybind({
		"action_name": "toggle_tts",
		"title": "Toggle Mouseover TTS. Shift reads out extended description.",
		"key": KEY_R,
	})
	KeybindsAPI.connect(tts_key_signal + "_up", self, "_on_tts_button")

	_filter_all_children($"/root/OptionsMenu")
	get_tree().connect("node_added", self, "_scene_filterer")

func _on_tts_button():
	print(source_list)
	var extended = Input.is_key_pressed(KEY_SHIFT)

	var sel = 0
	if extended: sel = 1

	for src in source_list.values():
		if src["autosay"]: continue

		var phrase = src["current_text"][sel]
		if phrase == null: continue

		_say(phrase)
		break


func _filter_all_children(node: Node):
	_scene_filterer(node)
	for N in node.get_children():
		_filter_all_children(N)

func _scene_filterer(node:Node):
	# What lies ahead is a horrible, awful pile of hacks.
	# This took hours of trial and error to narrow down as many edge cases as possible...
	# I wish there was a better way to do this, but for many things, there just isn't
	# If you find anything that makes this easier, PLEASE ping us on the Webfishing modding discord.
	if node is RichTextLabel:
		node.mouse_filter = Control.MOUSE_FILTER_PASS
#		print("RichTextLabel - ", node.get_class(), " ", node.bbcode_text)
		_connect(node, "bbcode_text")
	elif node is Label and not node.name == "stack_count":
		node.mouse_filter = Control.MOUSE_FILTER_PASS
#		print("Label - ", node.text)
		_connect(node, "text")
	elif node as BaseButton:
		node.mouse_filter = Control.MOUSE_FILTER_PASS
		_connect(node, "text")
	elif node.get("bbcode_text"):
		node.mouse_filter = Control.MOUSE_FILTER_PASS
#		print(node.get_class(), " - ", node.text)
		_connect(node, "bbcode_text")
	elif node.get("text") and not node.name == "stack_count":
#		print(node.get_class(), " - ", node.text)
		_connect(node, "text")

func _connect(node: Node, prop: String):
	node.connect("mouse_entered",self,"_mouse_enter", [node, prop])
	node.connect("mouse_exited",self,"_mouse_exit")

func _mouse_enter(node: Node, prop: String):
	if not node.get(prop): return
	_queue("ui", node[prop])

func _mouse_exit():
	_dequeue("ui")

func _queue(source: String, header: String, body = null):
	var cur_src = source_list[source]

	if cur_src["autosay"]:
		_say(header)
	else:
		cur_src["current_text"][0] = header
		cur_src["current_text"][1] = body

func _dequeue(source: String):
	if not source in source_list: return
	var cur_src = source_list[source]

	cur_src["current_text"][0] = null
	cur_src["current_text"][1] = null

func _say(text: String):
	tts.speak(text)
