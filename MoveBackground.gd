extends Node2D

@export var flora_spawnable_scene: PackedScene
@onready var timer: Timer = $Timer


func _on_timer_timeout() -> void:
	var newflora = flora_spawnable_scene.instantiate()
	newflora.position.x = 2000
	newflora.position.y = 415
	add_child(newflora)
	timer.wait_time = randf_range(3,8)
