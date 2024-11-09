extends Node

const commands = preload("./commands.gd")
const utils = preload("./utils.gd")
var tts = preload("./tts.gd").new()
var readable_nodes:Array = []

func _enter_tree():
	self.add_child(tts, true)

func _ready():
	get_tree().connect("node_added", self, "_scene_filterer", [], CONNECT_DEFERRED)

func _scene_filterer(node:Node):
	if node.get_parent() == get_tree().root:
		readable_nodes = []
		call_deferred("_append_text_nodes", node)
		if node.name == "playerhud":
			_refresh_connection(Network,"_members_updated",self,"refresh_node_descendants",[node.get_node("main/menu/tabs/players")],CONNECT_DEFERRED)
			_refresh_connection(PlayerData, "_inventory_refresh", self, "refresh_node_descendants", [node])
			node.connect("_menu_entered", self, "_menu_connected_bridge")
			for tab in node.get_node("main/menu/tabs/inventory/tabs").get_children():
				if tab as BaseButton:
					_refresh_connection(tab,"pressed",self,"refresh_node_descendants",[node.get_node("main/menu/tabs/inventory/Panel/items")],CONNECT_DEFERRED)

func _append_text_nodes(start_node:Node):
	var nodes = utils._get_all_children(start_node)
	for node in nodes:
		var is_control = node as Control
		if not is_control: continue
		if node is TooltipNode or node is RichTextLabel or node.get("text"):
			readable_nodes.append(node)
	_connect_readable_nodes()

func refresh_node_descendants(start_node:Node):
	if !start_node:
		print("trying to refresh text nodes with a null start.")
		return
	var decendants = utils._get_all_children(start_node)
	prints("refreshing TTS'd children for",start_node)
	for decendant in decendants:
		for readable_node in readable_nodes:
			if decendant == readable_node:
				#prints("deleting reference for",decendant)
				readable_nodes.erase(decendant)
	_append_text_nodes(start_node)

func _menu_connected_bridge(menu_enum:int):
	var hud = get_node_or_null("/root/playerhud")
	if hud:
		print("tab changed")
		call_deferred("refresh_node_descendants",hud.get_node("main/menu/tabs"))

func _refresh_connection(host:Node,refreshing_signal:String,function_host:Node,function_name:String,binds:=[],flags:=0):
	if host.is_connected(refreshing_signal,function_host,function_name):
		host.disconnect(refreshing_signal,function_host,function_name)
	host.connect(refreshing_signal,function_host,function_name,binds,flags)

func _connect_readable_nodes():
	for node in readable_nodes: 
		var invalid_node:bool
		if !is_instance_valid(node): #check to make sure we don't crash, cleanup!
			invalid_node = true
		elif node.is_queued_for_deletion(): #if we merge the two it crashes, ignore the boilerplate
			invalid_node = true
		if invalid_node:
			#print("deleted freed/missing node from the TTS list")
			readable_nodes.erase(node)
			continue
		if node is TooltipNode:
#			if node.is_connected("_entered",self,"_read_tts"):
#				node.disconnect("_entered",self,"_read_tts")
			#prints("found tooltip",node,node.header,node.body)
			var header = utils._strip_bbcode(node.header)
			var body = utils._strip_bbcode(node.body)
			var stringy = "Tooltip: " + header + "; Description: " + body
			_refresh_connection(node,"_entered", self, "_read_tts", [stringy], CONNECT_DEFERRED)
		elif node is RichTextLabel:
#			if node.is_connected("mouse_entered",self,"_read_tts"):
#				node.disconnect("mouse_entered",self,"_read_tts")
			_refresh_connection(node,"mouse_entered",self,"_read_tts",[node.bbcode_text])
		elif node.get("text"):
			var tooltipped:bool
			for children in node.get_children():
				if children is TooltipNode:
					tooltipped = true
			if !tooltipped:
				_refresh_connection(node,"mouse_entered",self,"_read_tts",[node.get_class()+": "+node.text])

func _read_tts(text: String):
	tts.speak(text)
