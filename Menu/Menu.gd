extends Control
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_start_button_down() -> void:
	audio_stream_player_2d.play()
	var tween = create_tween()
	tween.tween_callback(
		get_tree().change_scene_to_file.bind("res://main.tscn")
	)


func _on_quit_button_down() -> void:
	audio_stream_player_2d.play()
	get_tree().quit()
