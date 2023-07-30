extends CharacterBody2D

enum {
	WANDERING,
	CHASING
}

@export var health = 200
@export var friction = 800.0
@export var max_speed = 80.0
@export var acceleration = 200.0
@export var damage = 10
@export var knockback_strength = 1000
@export var attack_delay = 1
@export var sight_range = -1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var invincible = false
var knockback_vector = Vector2.ZERO

var current_direction = "right"
var over_ledge = "none"
var current_state = WANDERING

@onready var progress_bar = %ProgressBar
@onready var invincible_frame_timer = $InvincibleFrameTimer

@onready var fall_check_left = $FallCheckLeft
@onready var fall_check_right = $FallCheckRight
@onready var leave_player_timer = $LeavePlayerTimer



func _ready():
	progress_bar.visible = false
	progress_bar.max_value = health
	progress_bar.value = health

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	handle_friction(delta)
	handle_movement(delta)
	move_and_slide()

func attacked(damage, knockback_strength, attacker_position, attack_delay, attack_type):
	if invincible == false and invincible_frame_timer.is_stopped() == true:
		if attack_type == "melee":
			if attack_delay > 0.05:
				invincible_frame_timer.wait_time = attack_delay
			else:
				invincible_frame_timer.wait_time = 0.05
			invincible_frame_timer.start()
		
		handle_knockback(knockback_strength, attacker_position)
		
		health -= damage
		progress_bar.visible = true
		progress_bar.value = health
		
		if health <= 0:
			queue_free()

func handle_knockback(knockback_strength, attacker_position):
	if attacker_position < global_position:
		knockback_vector = Vector2(1, 0) * knockback_strength
	else:
		knockback_vector = Vector2(-1, 0) * knockback_strength
	
	velocity.x = 0
	velocity += knockback_vector
	
func handle_friction(delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func handle_movement(delta):		
	if is_on_floor():
		if leave_player_timer.is_stopped() == true:
			if global_position.distance_to(PlayerValues.position) <= sight_range:
				current_state = CHASING
			
		if fall_check_left.is_colliding() == false:
			current_direction = "right"
			
			if PlayerValues.position.x < global_position.x:
				current_state = WANDERING
				leave_player_timer.start()
				velocity.x = 0
				
		elif fall_check_right.is_colliding() == false:
			current_direction = "left"
			
			if PlayerValues.position.x > global_position.x:
				current_state = WANDERING
				leave_player_timer.start()
				velocity.x = 0

		match current_state:
			WANDERING:
				if current_direction == "right":
					velocity.x = move_toward(velocity.x, max_speed, acceleration * delta)
				if current_direction == "left":
					velocity.x = move_toward(velocity.x, -max_speed, acceleration * delta)
			CHASING:
				velocity.x = move_toward(velocity.x, global_position.direction_to(PlayerValues.position).x * max_speed, acceleration * delta)


func _on_enemy_hitbox_body_entered(body):
	body.attacked(damage, 1, global_position, body.invincible_frame_timer.wait_time, "melee")
