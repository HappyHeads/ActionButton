@icon("res://addons/action_button/icons/ActionButtonEffect.svg")
class_name ActionButtonEffect
extends Resource
##Defines the parameters for how to animate and what sonuds to emit for a [ActionButton] state.

##For how long the motion will animate for in seconds.
@export var motion_duration : float = 0.1
##How much to offset the position of the button when animated.
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var position : Vector2
##Same as [member position] but expressed in units relative to the [b]Button[/b] [member size]. The final offset is the combined value of this property and [member position].
@export var position_ratio : Vector2
##How much to rotate the button when animated, in degrees.
@export_range(-360, 360, 0.1, "degrees", "or_greater", "or_less") var rotation : float
##How much to scale the button when animated.
@export_custom(PROPERTY_HINT_LINK, "") var scale : Vector2 = Vector2.ONE
##How much to modulate the color of the button when animated, uses self-modulate.
@export var color : Color = Color.WHITE
@export var transition_type: Tween.TransitionType
@export var ease_type: Tween.EaseType
##Offsets [member z_index] so when the button is animated it can appear in front or behind neighboring ui elements. You usually want this number to be positive so the buttons doesn't get obscured.
@export var z_index_offset: int = 1
@export_category("Audio")
##What sound to emit when this action happens, sounds are reused globally when possible (in ActionButtonAudio autoload).
@export var audio_stream : AudioStream
##Volume of sound, in decibels.
@export_range(-80, 24, 0.001, "suffix:dB") var volume_db : float
##The audio's pitch and tempo, as a multiplier of the stream's sample rate.
@export_range(0.01, 4, 0.01, "or_greater") var pitch_scale : float = 1
##How many times this sound can play at the same time.
@export_range(0, 2147483647) var max_polyphony : int = 1
##The target bus name. The sound will be playing on this bus.
@export var bus : StringName = "Master"
