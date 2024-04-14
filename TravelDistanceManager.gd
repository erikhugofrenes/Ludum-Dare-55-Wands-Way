extends Node2D

@export var distance_traveled: float = 0.0 # in meters
var meters_per_second: float  = 0.1
var is_flying:bool = true
@export var summon_points: float = 0


@onready var label: Label = $"Label"

@onready var timer: Timer = $Timer

func _on_dandelion_seed_is_flying(is_flying_in: Variant) -> void:
	is_flying = is_flying_in


func _on_timer_timeout() -> void:
	if is_flying:
		distance_traveled += meters_per_second
		summon_points+= 5
		label.text = "distance traveled : " + String.num(distance_traveled, 1) + " m"
