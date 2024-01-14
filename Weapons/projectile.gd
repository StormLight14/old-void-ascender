extends Area2D

var speed = 200
var ranged_weapon = PlayerValues.player_data.ranged_weapon
var start_pos = Vector2.ZERO

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_area_entered(area):
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("attackable"):
		body.attacked(ranged_weapon['projectile_damage'] * PlayerValues.player_data.strength, ranged_weapon['projectile_knockback_strength'], start_pos, ranged_weapon['shot_delay'], "ranged")
	queue_free()



func _on_auto_delete_timer_timeout():
	queue_free()
