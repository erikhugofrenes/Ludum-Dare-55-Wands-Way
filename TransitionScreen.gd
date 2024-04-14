extends Control

@onready var travel_distance_manager: Node2D = $"../TravelDistanceManager"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _process(delta: float) -> void:
	$"Distance Traveled".text = "Distance you traveled : " + String.num(travel_distance_manager.distance_traveled, 1) + " m" 



func _on_retry_button_down() -> void:
	audio_stream_player_2d.play()
	var tween = create_tween()
	tween.tween_callback(get_tree().reload_current_scene)


func _on_main_menu_button_down() -> void:
	audio_stream_player_2d.play()
	var tween = create_tween()
	tween.tween_callback(
		get_tree().change_scene_to_file.bind("res://Menu/Menu.tscn")
	)
