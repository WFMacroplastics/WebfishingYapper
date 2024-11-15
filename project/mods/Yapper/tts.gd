extends Node

var TTS
# thank you stack overflow
const BBCODE_REGEX = "\\[\\/?(?:b|i|u|sup|url|image|color|size|font|center|left|right){1,}.*?]"

func _strip_bbcode(text:String) -> String:
	var regex:RegEx = RegEx.new()
	var parsed = text
	if regex.compile(BBCODE_REGEX) == OK:
		var result:Array = regex.search_all(text)
		if result:
			for regexres in result:
				parsed = parsed.replace(regexres.get_string(),"")
		regex = null
	return parsed

# Thanks Jules. YOINK!!!!!!
# https://github.com/NotNite/WebfishingRichPresence/blob/main/project/mods/WebfishingRichPresence/main.gd
func _set_up_tts(): 
	var lib = GDNativeLibrary.new()
	var cfg = ConfigFile.new()
	cfg.set_value("entry", "Windows.64", "%LIBGDTTS%")
	lib.config_file = cfg

	var script = NativeScript.new()
	script.library = lib
	script.resource_name = "TTSDriver"
	script.set_class_name("TTSDriver")
	
	TTS = Node.new()
	TTS.set_script(script)

func _init():
	self.name = "TTS"
	_set_up_tts()

func speak(text: String, interrupt: bool = false):
	if text == "": return
	TTS.speak(_strip_bbcode(text), interrupt)

# TODO: this doesn't use a flag for async
func stop():
	TTS.stop()

# TODO: add this
func skip():
	pass

func get_voices():
	return TTS.get_voices()

func is_speaking():
	return TTS.is_speaking()

func get_rate():
	return TTS.get_rate()

func set_rate(rate: int):
	return TTS.set_rate(rate)
