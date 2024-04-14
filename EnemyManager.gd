extends Node2D

@export var enemy_spawnable_scene: PackedScene
@onready var timer: Timer = $Timer
var time_since_start = 0

func _process(delta: float) -> void:
	time_since_start+=delta

func _on_timer_timeout() -> void:
	var new_enemy = enemy_spawnable_scene.instantiate()
	
	timer.wait_time = randf_range(5,15)
	
	if time_since_start >= 30:
		new_enemy.speed = 75
		timer.wait_time = randf_range(5,10)
	if time_since_start >= 60:
		new_enemy.speed = 100
		timer.wait_time = randf_range(4,8)
	if time_since_start >= 90:
		new_enemy.speed = 150
		timer.wait_time = randf_range(3,6)
	if time_since_start >= 120:
		new_enemy.speed = 200
		timer.wait_time = randf_range(1,4)
	add_child(new_enemy)
