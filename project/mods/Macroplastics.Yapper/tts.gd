extends Node

const utils = preload("./utils.gd")

var TTS

# TODO: would it be desirable to refactor this?

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

func speak(text, interrupt: bool = true):
	if text == "": return
	print(text)
#	TTS.speak(utils._strip_bbcode(text), interrupt)

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
