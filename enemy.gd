extends Area2D

@onready var rigid_body_2d: RigidBody2D = $"../../DandelionSeedPlayer/RigidBody2D"

var direction: Vector2
@export var speed:float = 50

@onready var explosion_2: AudioStreamPlayer2D = $explosion2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x  = randf_range(800,900)
	position.y  = randf_range(-300,300)
	direction = Vector2(0,rigid_body_2d.position.y+300) - position
	direction = direction.normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction*speed*delta
	if position.x <= -2000:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if(!(area.is_in_group("enemy")||area.is_in_group("Shield"))):
		explosion_2.play()
		queue_free()
