@icon("res://addons/action_button/icons/ActionButtonAudio.svg")
extends Node

var streams : Dictionary[String, AudioStreamPlayer]

##Function that appends and keeps reference of sounds to use for ActionButton.
##Where possible it will reuse sounds if they have the same settings.
func append_audio(property : ActionButtonEffect) -> AudioStreamPlayer:
	if !property:
		return null
	if !property.audio_stream:
		return null
	
	var path : String = property.audio_stream.resource_path
	var key : String = path
	key += str(property.volume_db)
	key += str(property.pitch_scale)
	key += str(property.max_polyphony)
	key += property.bus

	var has = streams.has(key)
	if has:
		return streams[key]
	else:
		var stream : AudioStreamPlayer = AudioStreamPlayer.new()
		stream.stream = property.audio_stream
		stream.volume_db = property.volume_db
		stream.pitch_scale = property.pitch_scale
		stream.max_polyphony = property.max_polyphony
		stream.bus = property.bus
		stream.name = path.get_file().trim_suffix("." + path.get_extension()) + "_00"
		streams[key] = stream
		add_child(stream, true)
		return streams[key]
