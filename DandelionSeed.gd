extends Node2D

@onready var rigid_body_2d: RigidBody2D = $RigidBody2D

@export var lower_rotation_limit = -PI/8
@export var upper_rotation_limit = PI/8

@export var lower_force_modifier:float = -3 # good value at 0
@export var upper_force_modifier:float = 10 # good value at 7 - this value seems to work well

@export var torque_amount:float = 125
var wind_rotation: float = 0


signal is_flying(is_flying_in)

func _ready() -> void:
	
	rigid_body_2d.apply_central_impulse(Vector2.UP*35)

@onready var audio_stream_player_for_summon: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	if lower_rotation_limit < rigid_body_2d.rotation and Input.is_action_pressed("rotate_left"):
		rigid_body_2d.apply_torque(-torque_amount * delta)
	elif upper_rotation_limit > rigid_body_2d.rotation and Input.is_action_pressed("rotate_right"):
		rigid_body_2d.apply_torque(torque_amount * delta)
	
	var difference_between_seed_and_wind_rotation: float = abs(wind_rotation-rigid_body_2d.rotation)
	var modifier_calculation = (1 - (difference_between_seed_and_wind_rotation)/(abs(lower_rotation_limit) + upper_rotation_limit))
	var modifier: float = (upper_force_modifier-lower_force_modifier)*modifier_calculation * modifier_calculation # remove extra modifer
	var upward_force: Vector2 = Vector2.UP*modifier*delta
	#print("rigidbody" + str(rigid_body_2d.position) + str(modifier))
	rigid_body_2d.apply_central_force(upward_force)
	
	if Input.is_action_pressed("quite"):
		get_tree().quit()
	
	#spawning helper
	if helper_visibility>0:
		helper_visibility -= 0.05*delta
	elif helper_visibility<0:
		helper_visibility = 0
	
	helper.position.y = rigid_body_2d.position.y - 75
	helper.position.x = 50 * wind_rotation-rigid_body_2d.rotation
	
	helper.modulate = Color(1,1,1,helper_visibility)
	if Input.is_action_just_pressed("summon_helper") and travel_distance_manager.summon_points >= 75 && helper_visibility<=0:
		helper_visibility = 1
		travel_distance_manager.summon_points = travel_distance_manager.summon_points - 75
		audio_stream_player_for_summon.play()
	
	if (Input.is_action_just_pressed("summon_shield") and travel_distance_manager.summon_points >= 75 and !shield_is_active):
		travel_distance_manager.summon_points = travel_distance_manager.summon_points - 75
		shield_is_active = true
		sprite_2d.visible = true
		audio_stream_player_for_summon.play()
	
	if  travel_distance_manager.summon_points >= 75:
		can_summon.emitting = true
	else:
		can_summon.emitting = false

@onready var can_summon: GPUParticles2D = $RigidBody2D/CanSummon

func _on_wind_manager_wind_rotation(wind_rotation_in: float) -> void:
	self.wind_rotation = wind_rotation_in


@onready var travel_distance_manager: Node2D = $"../TravelDistanceManager"


var helper_visibility:float = 1
@onready var helper: Sprite2D = $Helper


@onready var enemy_manager: Node2D = $"../EnemyManager"

func _on_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Ground")||area.is_in_group("High Altitude")||area.is_in_group("enemy")||area.is_in_group("Flora"):
		is_flying.emit(false)
		enemy_manager.queue_free()
		explosion.play()
		game_over()


@onready var transition_screen: Control = $"../TransitionScreen"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../WindManager/AudioStreamPlayer2D"

func game_over() -> void:
	set_physics_process(false)
	transition_screen.visible = true
	audio_stream_player_2d.stop()

@onready var area_2d: Area2D = $RigidBody2D/Area2D
var shield_is_active: bool = false
@onready var sprite_2d: Sprite2D = $RigidBody2D/Area2D/Sprite2D

@onready var explosion: AudioStreamPlayer2D = $Explosion

func _on_area_2d_area_entered(area: Area2D) -> void:
	if shield_is_active:
		if(area.is_in_group("Flora")):
			area.get_parent().queue_free()
			sprite_2d.visible = false
			shield_is_active = false
			explosion.play()
		if(area.is_in_group("enemy")):
			area.queue_free()
			sprite_2d.visible = false
			shield_is_active = false
			explosion.play()
