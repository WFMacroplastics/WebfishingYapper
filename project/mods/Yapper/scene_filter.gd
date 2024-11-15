extends Node

onready var Yapper = $"/root/Yapper"

func _ready():
	_filter_all_children($"/root/OptionsMenu")
	get_tree().connect("node_added", self, "_scene_filterer")
	print("Scene Filterer Ready")

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
	node.connect("mouse_exited",self,"_mouse_exit", [node])

func _mouse_enter(node: Node, prop: String):
	if not node.get(prop): return
	node.connect("hide", self, "_mouse_exit", [node])
	Yapper._queue("ui", node[prop])

func _mouse_exit(node: Node):
	node.disconnect("hide", self, "_mouse_exit")
	Yapper._dequeue("ui")