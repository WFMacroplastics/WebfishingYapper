extends Node

onready var LucysLib := get_node_or_null("/root/LucysLib")

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
	# Thanks, Lucy!
	var stripped = LucysLib.BBCode.parse_bbcode_text(text).get_stripped()
	TTS.speak(stripped, interrupt)

# TODO: this doesn't use a flag for async
func stop():
	TTS.stop()

# TODO: add this
func skip():
	pass

func is_speaking():
	return TTS.is_speaking()


func get_voices() -> Array:
	return TTS.get_voices()

func set_voice(name: String):
	TTS.set_voice(name)


func get_volume() -> int:
	return TTS.get_volume()

# 0 to 100
func set_volume(volume: int):
	TTS.set_volume(volume)


func get_pitch() -> float:
	return TTS.get_pitch()

# -10 to 10
func set_pitch(pitch: float):
	TTS.set_rate(pitch)


func get_rate() -> int:
	return TTS.get_rate()

# -100 to 100
func set_rate(rate: int):
	TTS.set_rate(rate)
