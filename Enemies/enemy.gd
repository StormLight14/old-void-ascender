extends CharacterBody2D

@export var health = 200
@export var friction = 800.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var invincible = false
var knockback_vector = Vector2.ZERO

@onready var progress_bar = %ProgressBar
@onready var invincible_frame_timer = $InvincibleFrameTimer

func _ready():
	progress_bar.visible = false
	progress_bar.max_value = health
	progress_bar.value = health

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	handle_friction(delta)

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
			print("died")
			health = 200
			progress_bar.value = health

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
