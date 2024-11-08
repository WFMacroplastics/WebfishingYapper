extends Reference

const BBCODE_REGEX = "\\[\\/?(?:b|i|u|sup|url|image|color|size|font){1,}.*?]"

# TODO: see if this could be memory intensive
static func get_all_children(node: Node):
	var nodes : Array = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes

static func _strip_bbcode(text:String) -> String:
	var regex:RegEx = RegEx.new()
	var parsed = text
	if regex.compile(BBCODE_REGEX) == OK:# thank you stack overflow
		var result:Array = regex.search_all(text)
		if result:
			for regexres in result:
				parsed = parsed.replace(regexres.get_string(),"")
		regex = null
	return parsed
