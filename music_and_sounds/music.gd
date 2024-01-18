extends Node

@export var theme : AudioStream

var previous_song

@onready var audio_stream_player = $AudioStreamPlayer

func play_music(song, song_start = 0.0):
	audio_stream_player.stream = song
	previous_song = song
	audio_stream_player.play(song_start)

func fade_music(fade_duration = 15.0):
	var previous_volume = audio_stream_player.volume_db
	var volume_fade = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	volume_fade.tween_property(audio_stream_player, "volume_db", -60.0, fade_duration).from_current()
	await volume_fade.finished
	audio_stream_player.stop()
	audio_stream_player.volume_db = previous_volume

func _on_audio_stream_player_finished():
	play_music(previous_song)
