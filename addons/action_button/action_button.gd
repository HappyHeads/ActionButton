@icon("res://addons/action_button/icons/ActionButton.svg")
class_name ActionButton
extends Button

##Action that plays when you hover over the button with your mouse or when you focus on it. 
@export var on_hover : ActionButtonEffect
##Action that plays when the button is pressed either with mouse or UI input. Has no connection with [member BaseButton.action_mode]
@export var on_button_down : ActionButtonEffect
##Action that plays when the button is let go either with mouse or UI input. Has no connection with [member BaseButton.action_mode]
@export var on_button_up : ActionButtonEffect
##Action that plays when the button is back to its original base state. In most use cases this can be left at default values or be [code]null[/code].
@export var on_rest : ActionButtonEffect

##Reference to the audio stream used for [member on_hover]
var stream_hover : AudioStreamPlayer
##Reference to the audio stream used for [member on_button_down]
var stream_button_down : AudioStreamPlayer
##Reference to the audio stream used for [member on_button_up]
var stream_button_up : AudioStreamPlayer
##Reference to the audio stream used for [member on_rest]
var stream_rest : AudioStreamPlayer

var tween : Tween
var tween_reset : Tween
##Default effect that is used when a [ActionButtonEffect] is not set for a state.
var fallback_property : ActionButtonEffect

##Keeps track of where the "original" position of the button is. If you are moving the button outside of this code you might want to set this variable.
var default_position : Vector2
var default_z_index : int
enum state {REST, HOVER, BUTTON_DOWN, BUTTON_UP}
var current_state : state
var is_focused : bool
var audio_manager : Node



func _ready() -> void:
	await get_tree().process_frame
	
	init_audio()
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	
	toggled.connect(_on_toggle)
	
	var parent = get_parent_control()
	if parent is Container:
		parent.sort_children.connect(_on_container_sort)
	
	if on_hover == null or on_button_up == null or on_button_down == null or on_rest == null:
		fallback_property = ActionButtonEffect.new()
	
	default_position = position
	default_z_index = z_index
	pivot_offset = size / 2
	
	reset()


##Sets up all the audio stuff with the global ActionButtonAudio so the button can have sounds.
func init_audio() -> void:
	#ATTENTION, if this is giving you an errors you probably did not enable the plugin in project settings
	stream_hover = ActionButtonAudio.append_audio(on_hover)
	stream_button_down = ActionButtonAudio.append_audio(on_button_down)
	stream_button_up = ActionButtonAudio.append_audio(on_button_up)
	stream_rest = ActionButtonAudio.append_audio(on_rest)


func _on_container_sort() -> void:
	default_position = position
	if tween_reset:
		tween_reset.kill()
	if tween:
		tween.kill()
	reset()
	

func _on_mouse_entered():
	if toggle_mode and button_pressed:
		return
	if disabled:
		return
	if is_focused:
		return
	if toggle_mode and button_pressed:
		return
	if stream_hover:
		stream_hover.play()
	tween_it(on_hover, state.HOVER, false, true)


func _on_mouse_exited():
	if disabled:
		return
	if toggle_mode and button_pressed:
		return
	if stream_rest:
		stream_rest.play()
	tween_it_reset()


func _on_focus_entered():
	if toggle_mode and button_pressed:
		return
	if disabled:
		return
	if is_hovered():
		return
	if stream_hover:
		stream_hover.play()
	is_focused = true
	tween_it(on_hover, state.HOVER, false, true)


func _on_focus_exited():
	if disabled:
		return
	if is_hovered():
		return
	if toggle_mode and button_pressed:
		return
	is_focused = false
	tween_it_reset()


func _on_button_down():
	if toggle_mode:
		return
	if stream_button_down:
		stream_button_down.play()
	tween_it(on_button_down, state.BUTTON_DOWN)


func _on_button_up():
	if toggle_mode:
		return
	if stream_button_up:
		stream_button_up.play()
	tween_it(on_button_up, state.BUTTON_UP, true)


func _on_toggle(toggled_on : bool):
	if toggle_mode:
		if toggled_on:
			if stream_button_down:
				stream_button_down.play()
			tween_it(on_button_down, state.BUTTON_DOWN)
		else:
			if tween_reset:
				tween_reset.kill()
			if stream_button_up:
				stream_button_up.play()
			tween_it(on_button_up, state.BUTTON_UP, true)


## Tweens to a state.
func tween_it(property : ActionButtonEffect, what_state : state ,reset_after_done : bool = false, override : bool = false) -> void:
	if current_state == what_state:
		return
	if tween:
		if tween.is_running() and override:
			return
		tween.kill()
	if property == null:
		property = fallback_property
	z_index = default_z_index+100
	current_state = what_state
	tween = create_tween()
	tween.set_trans(property.transition_type)
	tween.set_ease(property.ease_type)
	tween.set_parallel(true)
	tween.tween_property(self, "position", default_position + property.position, property.motion_duration)
	tween.tween_property(self, "rotation_degrees", property.rotation, property.motion_duration)
	tween.tween_property(self, "scale", property.scale, property.motion_duration)
	tween.tween_property(self, "self_modulate", property.color, property.motion_duration)
	await tween.finished
	if reset_after_done:
		if is_hovered():
			tween_it(on_hover, state.HOVER)
		else:
			tween_it_reset()


##Tweens to [memeber on_rest]
func tween_it_reset():
	var property : ActionButtonEffect = on_rest
	if current_state == state.REST:
		return
	if tween_reset:
		tween_reset.kill()
	if tween:
		tween.kill()
	if property == null:
		property = fallback_property
	z_index = default_z_index
	current_state = state.REST
	tween_reset = create_tween()
	tween_reset.set_trans(property.transition_type)
	tween_reset.set_ease(property.ease_type)
	tween_reset.set_parallel(true)
	tween_reset.tween_property(self, "position", default_position + property.position, property.motion_duration)
	tween_reset.tween_property(self, "rotation_degrees", property.rotation, property.motion_duration)
	tween_reset.tween_property(self, "scale", property.scale, property.motion_duration)
	tween_reset.tween_property(self, "self_modulate", property.color, property.motion_duration)


##Reset to [member on_rest] immediately
func reset():
	var property : ActionButtonEffect = on_rest
	if property == null:
		property = fallback_property
	position = default_position + property.position
	rotation_degrees = property.rotation
	scale = Vector2.ONE * property.scale
	self_modulate = property.color
