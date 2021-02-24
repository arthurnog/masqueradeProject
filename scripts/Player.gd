extends KinematicBody2D

export (int) var speed = 130
export (int) var grav = 50
export (int) var jump = -1000
export (int) var hearts = 3

var vel = Vector2() #movimentação do personagem (x,y)

func atack():
	$DamageArea/CollisionShape2D.disabled = false

func get_input():
	vel.x = 0
	var R = Input.is_action_pressed("ui_right")
	var L = Input.is_action_pressed("ui_left")
	var U = Input.is_action_just_pressed("jump")
	var A = Input.is_action_just_pressed("atk")
	
	if R:
		vel.x += 1
		$AnimatedSprite.flip_h = false
	if L:
		vel.x -= 1
		$AnimatedSprite.flip_h = true
	if U and is_on_floor():
		vel.y += jump
		#$AnimatedSprite.play("jump")
	if A:
		atack()
		$AnimatedSprite.play("atk")
		yield($AnimatedSprite, "animation_finished")
	else:
		if vel.x != 0 and is_on_floor():
			$AnimatedSprite.play("run")
		if vel.x == 0 and is_on_floor():
			$AnimatedSprite.play("idle")
		if not is_on_floor():
			$AnimatedSprite.play("jump")
		
	
	vel.x = vel.x*speed

# warning-ignore:unused_argument
func _physics_process(delta):
	vel.y = vel.y + grav
	get_input()
	vel = move_and_slide(vel, Vector2.UP)
	
	$DamageArea/CollisionShape2D.disabled = true
	if $AnimatedSprite.flip_h:
		$DamageArea.position.x = -58.667
	else:
		$DamageArea.position.x = 58.667


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		hearts -= 1
