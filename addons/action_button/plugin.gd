@tool
extends EditorPlugin

const AUTOLOAD_NAME = "ActionButtonAudio"
const AUTOLOAD_PATH = "res://addons/action_button/action_button_autoload.gd"

func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)

func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME)
