extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var wall_jump_timer = $WallJumpTimer
@onready var invincible_frame_timer = $InvincibleFrameTimer

@onready var controller_pivot = $ControllerPivot
@onready var controller_cursor_sprite = %ControllerCursorSprite
@onready var controller_cursor = %ControllerCursor


@onready var melee = %Melee
@onready var melee_hitbox = %MeleeHitbox
@onready var melee_sprite = %MeleeSprite
@onready var melee_attack_delay = %MeleeAttackDelay

@onready var ranged = %Ranged
@onready var ranged_sprite = %RangedSprite
@onready var ranged_attack_delay = $Ranged/RangedAttackDelay

@export var player_stats = PlayerStats

var health = PlayerValues.health
var melee_weapon = PlayerValues.melee_weapon
var ranged_weapon = PlayerValues.ranged_weapon

var knockback_vector = Vector2.ZERO


@onready var mouse_position = get_viewport().get_mouse_position()

var attack_hitbox_offset = Vector2(10, 0)

enum {
	MELEE,
	RANGED,
	SPECIAL
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_start_pos = global_position
var current_direction = "right"

var just_wall_jumped = false
var invincible = false
var previous_wall_normal = Vector2.ZERO
var air_jumps = 0 

var current_attack = MELEE

func _ready():
	randomize()
	melee_sprite.visible = false
	ranged_sprite.visible = false
	air_jumps = player_stats.air_jumps

func _physics_process(delta):
	var input_direction = Input.get_axis("left", "right")
	PlayerValues.position = global_position
	
	handle_gravity(delta)
	handle_wall_jump()
	handle_jump(input_direction)
	
	handle_controller_cursor(delta)
	handle_attacks()
	
	handle_movement(input_direction, delta)
	handle_friction(input_direction, delta)
	handle_air_resistance(input_direction, delta)
	
	if current_attack == MELEE:
		if Input.is_key_pressed(KEY_H):
			melee_weapon = PlayerValues.melee_weapons[1]
			PlayerValues.melee_weapon = melee_weapon
		if Input.is_key_pressed(KEY_J):
			melee_weapon = PlayerValues.melee_weapons[99]
			PlayerValues.melee_weapon = melee_weapon
		if Input.is_key_pressed(KEY_K):
			melee_weapon = PlayerValues.melee_weapons[100]
			PlayerValues.melee_weapon = melee_weapon
		PlayerValues.melee_weapon = melee_weapon
		
	if current_attack == RANGED:
		if Input.is_key_pressed(KEY_H):
			ranged_weapon = PlayerValues.ranged_weapons[0]
			PlayerValues.ranged_weapon = ranged_weapon
		if Input.is_key_pressed(KEY_J):
			ranged_weapon = PlayerValues.ranged_weapons[1]
			PlayerValues.ranged_weapon = ranged_weapon
		if Input.is_key_pressed(KEY_K):
			ranged_weapon = PlayerValues.ranged_weapons[2]
			PlayerValues.ranged_weapon = ranged_weapon
			

	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall_only() # only allow wall jump if not on floor + on wall
	
	if was_on_wall:
		previous_wall_normal = get_wall_normal()
		
	move_and_slide()
	
	var just_left_ledge = was_on_floor != is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
	just_wall_jumped = false
	var just_left_wall = was_on_wall != is_on_wall_only()
	if just_left_wall:
		wall_jump_timer.start()

	handle_animation(input_direction)
	check_for_cursor_movement()
	
func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func handle_wall_jump():
	if not is_on_wall_only() and wall_jump_timer.time_left <= 0.0: return
	
	var wall_normal = get_wall_normal() 
	if wall_jump_timer.time_left > 0.0:
		wall_normal = previous_wall_normal
		
	if Input.is_action_just_pressed("jump"):
		velocity.x = wall_normal.x * player_stats.max_speed
		velocity.y = player_stats.jump_velocity
		just_wall_jumped = true

func handle_jump(input_direction):
	if is_on_floor():
		air_jumps = player_stats.air_jumps
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote_jump_timer.is_stopped() == false:
			velocity.y = player_stats.jump_velocity
			coyote_jump_timer.stop()
		elif air_jumps >= 1 and not is_on_floor() and not just_wall_jumped:
				velocity.y = player_stats.jump_velocity
				velocity.x = input_direction * player_stats.max_speed * 1.25
				air_jumps -= 1

func handle_movement(input_direction, delta):
	if input_direction != 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, player_stats.max_speed * input_direction, player_stats.acceleration * delta)
	if input_direction != 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, player_stats.max_speed * input_direction, player_stats.air_acceleration * delta)

func handle_friction(input_direction, delta):
	if input_direction == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, player_stats.friction * delta)
		
func handle_air_resistance(input_direction, delta):
	if input_direction == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, player_stats.air_resistance * delta)
		
func handle_animation(input_direction):
	ranged_sprite.scale = Vector2(ranged_weapon['sprite_scale'], ranged_weapon['sprite_scale'])
	if GameValues.using_controller == false:
		ranged.look_at(get_global_mouse_position())
	else:
		ranged.look_at(controller_cursor.global_position)
	
	if GameValues.using_controller == false:
		if get_global_mouse_position() > global_position:
			ranged_sprite.flip_v = false
		else:
			ranged_sprite.flip_v = true
	else:
		if controller_cursor.global_position > global_position:
			ranged_sprite.flip_v = false
		else:
			ranged_sprite.flip_v = true
	
	if input_direction != 0:
		if input_direction < 0:
			if current_direction == "right":
				current_direction = "left"
				animated_sprite_2d.flip_h = true
				melee.scale.x *= -1
				melee.rotation *= -1
				melee.position.x *= -1
				if animation_player.is_playing() and animation_player.current_animation == "melee_attack_right":
					var current_frame = animation_player.current_animation_position
					animation_player.stop()
					animation_player.play("melee_attack_left")
					animation_player.seek(current_frame)
					
				ranged.position.x *= -1
			
		if input_direction > 0:
			if current_direction == "left":
				current_direction = "right"
				animated_sprite_2d.flip_h = false
				melee.scale.x *= -1
				melee.rotation *= -1
				melee.position.x *= -1
				if animation_player.is_playing() and animation_player.current_animation == "melee_attack_left":
					var current_frame = animation_player.current_animation_position
					animation_player.stop()
					animation_player.play("melee_attack_right")
					animation_player.seek(current_frame)
					
				ranged.position.x *= -1
			
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
		
	if not is_on_floor():
			animated_sprite_2d.play("jump")
			

func handle_attacks():
	var attack_pressed = false
	
	if Input.is_action_just_pressed("set_attack_melee"):
		current_attack = MELEE
		PlayerValues.current_attack = "melee"
	elif Input.is_action_just_pressed("set_attack_ranged"):
		current_attack = RANGED
		PlayerValues.current_attack = "ranged"
	elif Input.is_action_just_pressed("set_attack_special"):
		current_attack = SPECIAL
		PlayerValues.current_attack = "special"
		
	match current_attack:
		MELEE:
			if PlayerValues.melee_weapon_auto_swing == true:
				attack_pressed = Input.is_action_pressed("attack")
			else:
				attack_pressed = Input.is_action_just_pressed("attack")
		RANGED:
			if PlayerValues.ranged_weapon_auto_shoot == true:
				attack_pressed = Input.is_action_pressed("attack")
			else:
				attack_pressed = Input.is_action_just_pressed("attack")
		SPECIAL:
			if PlayerValues.special_weapon_auto_attack == true: 
				attack_pressed = Input.is_action_pressed("attack")
			else:
				attack_pressed = Input.is_action_just_pressed("attack")
		
	if Input.is_action_pressed("melee") or (attack_pressed and current_attack == MELEE):
		attack_melee()
	if Input.is_action_pressed("ranged") or (attack_pressed and current_attack == RANGED):
		attack_ranged()
	if Input.is_action_pressed("special") or (attack_pressed and current_attack == SPECIAL):
		attack_special()

func attack_melee():
	melee_sprite.texture = PlayerValues.melee_weapon_sprite
	var melee_sprite_height = melee_sprite.texture.get_height()
	melee_sprite.offset.y = -melee_sprite_height
	
	#set_melee_collision()
	
	melee_attack_delay.wait_time = melee_weapon['attack_delay']
	
	if melee_attack_delay.is_stopped() == true:
		melee_sprite.visible = true
		melee_attack_delay.start()
		
		if melee_weapon['size'] == 0:
			if melee_sprite_height <= 16.0:
				melee_sprite.scale = Vector2(0.6, 0.6)
			elif melee_sprite_height <= 32.0:
				melee_sprite.scale = Vector2(0.3, 0.3)
			%SmallMelee.disabled = false
		elif melee_weapon['size'] == 1:
			if melee_sprite_height <= 16.0:
				melee_sprite.scale = Vector2(0.8, 0.8)
			elif melee_sprite_height <= 32.0:
				melee_sprite.scale = Vector2(0.4, 0.4)
			%MediumMelee.disabled = false
		elif melee_weapon['size'] == 2:
			if melee_sprite_height <= 16.0:
				melee_sprite.scale = Vector2(1.0, 1.0)
			elif melee_sprite_height <= 32.0:
				melee_sprite.scale = Vector2(0.5, 0.5)
			%LargeMelee.disabled = false
			
		animation_player.speed_scale = 1 + 1/melee_weapon['attack_delay'] # Original animation time 1 sec
		if current_direction == "right":
			animation_player.play("melee_attack_right")
		else:
			animation_player.play("melee_attack_left")

func attack_ranged(): 
	animation_player.stop()
	%SmallMelee.disabled = true
	%MediumMelee.disabled = true
	%LargeMelee.disabled = true
	melee_sprite.visible = false
	
	ranged_sprite.texture = ranged_weapon['sprite']
	ranged_sprite.scale = Vector2(0.5, 0.5)
	ranged_sprite.visible = true
	ranged_attack_delay.wait_time = ranged_weapon['shot_delay']
	
	if ranged_attack_delay.is_stopped() == true:
		if ranged_weapon['shot_projectiles'] == 1:
			var projectile = preload("res://Weapons/projectile.tscn").instantiate()
			projectile.global_position = %ProjectileSpawnLocation.global_position
			projectile.rotation = ranged.rotation
			projectile.speed = ranged_weapon['projectile_speed']
			projectile.start_pos = global_position
			
			owner.add_child(projectile)
		else:
			var spread_degrees = ranged_weapon['spread_degrees']
			for i in range(ranged_weapon['shot_projectiles']):
				var projectile = preload("res://Weapons/projectile.tscn").instantiate()
				projectile.global_position = %ProjectileSpawnLocation.global_position
				projectile.rotation_degrees = ranged.rotation_degrees + randf_range(-spread_degrees, spread_degrees)
				projectile.speed = ranged_weapon['projectile_speed']
				projectile.start_pos = global_position
				
				owner.add_child(projectile)
				
		ranged_attack_delay.start()
				
	
func attack_special():
	pass
	
func handle_controller_cursor(delta):
	var direction = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))
	var controller_cursor_to = controller_cursor.global_position
	var radius = 20

	if direction.length() > 0.2:
		GameValues.using_controller = true
		controller_cursor_sprite.visible = true
		controller_cursor_to += direction * 600.0 * delta

		# Calculate the direction from the center to the cursor
		var direction_from_center = controller_cursor_to - controller_pivot.global_position
		var distance = direction_from_center.length()

		if distance > radius:
			# Move the cursor to the edge of the circle
			direction_from_center = direction_from_center.normalized() * radius
			controller_cursor_to = controller_pivot.global_position + direction_from_center

		controller_cursor.global_position = controller_cursor_to
	else:
		GameValues.using_controller = false
		direction = controller_cursor.global_position.direction_to(controller_pivot.global_position)
		controller_cursor.global_position += direction * 200.0 * delta
		
		if controller_cursor.global_position.distance_to(controller_pivot.global_position) <= 5:
			controller_cursor_sprite.visible = false
		
	
	#if direction.x == 1:
	#	controller_pivot.rotation_degrees = 0
	#if direction.x == -1:
	#	controller_pivot.rotation_degrees = 180
	#if direction.y == 1:
	#	controller_pivot.rotation_degrees = 90
	#if direction.y == -1:
	#	controller_pivot.rotation_degrees = 270
	
func check_for_cursor_movement():
	if get_viewport().get_mouse_position() != mouse_position:
		GameValues.using_controller = false
		controller_cursor_sprite.visible = false
	mouse_position = get_viewport().get_mouse_position()

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
		#progress_bar.visible = true
		#progress_bar.value = health
		
		if health <= 0:
			get_tree().change_scene_to_packed(GameValues.worlds[GameValues.current_world].levels[GameValues.current_level])
			#progress_bar.value = health
			
func handle_knockback(knockback_strength, attacker_position):
	if attacker_position < global_position:
		knockback_vector = Vector2(1, 0) * knockback_strength
	else:
		knockback_vector = Vector2(-1, 0) * knockback_strength
	
	velocity.x = 0
	velocity += knockback_vector

func _on_hurtbox_area_entered(area):
	get_tree().change_scene_to_packed(GameValues.worlds[GameValues.current_world].levels[GameValues.current_level])


func _on_melee_attack_delay_timeout():
	%SmallMelee.disabled = true
	%MediumMelee.disabled = true
	%LargeMelee.disabled = true
	melee_sprite.visible = false


func _on_ranged_attack_delay_timeout():
	ranged_sprite.visible = false


func _on_melee_hitbox_body_entered(body):
	if body.is_in_group("player") == false:
		body.attacked(melee_weapon['damage'] * PlayerValues.strength, melee_weapon['knockback_strength'], global_position, melee_weapon['attack_delay'], "melee")

