extends Node2D

signal wind_rotation(wind_rotation_in: float)

@export var lower_wind_rotation: float = -PI/8
@export var upper_wind_rotation: float = PI/8

@export var rotation_speed: float = PI/20

var random_target: float = randf_range(lower_wind_rotation, upper_wind_rotation)
var current_position: float = 0

func _physics_process(delta: float) -> void:
	if random_target > current_position:
		current_position+=rotation_speed * delta
	if random_target < current_position:
		current_position-=rotation_speed * delta
	print("current_positions" + str(current_position*180/PI))
	wind_rotation.emit(current_position)
	change_wind_sound()

func _on_timer_timeout() -> void:
	random_target = randf_range(lower_wind_rotation, upper_wind_rotation)

#in x values
var upper_wind_pixel_coordinate: float = 1000
var lower_wind_pixel_coordinate: float = -1000
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func change_wind_sound() ->void:
	#hard coded this
	var calculation: float = current_position/upper_wind_rotation
	if(is_flying):
		if(audio_stream_player_2d.playing!=true):
			audio_stream_player_2d.play(calculation*upper_wind_pixel_coordinate)
		else:
			audio_stream_player_2d.position = Vector2(0,calculation*upper_wind_pixel_coordinate)

var is_flying: bool = true

func _on_dandelion_seed_player_is_flying(is_flying_in: Variant) -> void:
	is_flying = is_flying_in
