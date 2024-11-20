extends Reference

const cmds = {
		"alt / return a selection, kinda like ctrl C?":{},
		"space / confirm key stroke":{},
		"in-game":{
			"p / esc menu": {
				"+q / options":{},
				"+w / quick save":{},
				"+ee / main menu ":{},
				"+rr / close game confirm":{},
			},
			"t / tab":{
				"+z / inventory":{},
				"+x / journal":{},
				"+c / customize":{},
				"+v / inbox":{
					"+f / send letter":{},
					"+g / open letter":{},
				},
				"+b / player_list":{
					"downarrow-arrow / move focus on the player list":{},
					"leftarrow-rightarrow / move focus on the player related buttons":{},
				},
			},
		},
	}

func _print_cmds(dict:Dictionary,level := 0):
	var _level: int = level # retains local level property
	for k in dict.keys():
		print("\t".repeat(_level) + "["+k+"]")
		if dict[k] is Dictionary:
			if dict[k].size() > 0:
				_print_cmds(dict[k], _level + 1)

func _init():
	_print_cmds(cmds)
