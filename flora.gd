extends Sprite2D

var is_ready_to_move:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.x <= -2000:
		queue_free()
	if is_ready_to_move:
		position.x -= 50*delta


func _on_timer_timeout() -> void:
	is_ready_to_move = true
