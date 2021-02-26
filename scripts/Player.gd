extends KinematicBody2D

export (int) var speed = 140
export (int) var grav = 45
export (int) var jump = -1000
export (int) var hearts = 3

var vel = Vector2() #movimentação do personagem (x,y)

var atkFlag = false

func atack():
	$DamageArea/CollisionShape2D.disabled = false
	$AnimatedSprite.play("atk")
	atkFlag = true
	$AtkTimer.start()

func get_input():
	vel.x = 0
	var R = Input.is_action_pressed("ui_right")
	var L = Input.is_action_pressed("ui_left")
	var U = Input.is_action_just_pressed("jump")
	var A = Input.is_action_just_pressed("atk")
	
	if R:
		vel.x += 1
		$AnimatedSprite.flip_h = false
		if atkFlag:
			$AnimatedSprite.play("atk")
		else:
			if is_on_floor():
				$AnimatedSprite.play("run")
	if L:
		vel.x -= 1
		$AnimatedSprite.flip_h = true
		if atkFlag:
			$AnimatedSprite.play("atk")
		else:
			if is_on_floor():
				$AnimatedSprite.play("run")
	if U and is_on_floor():
		vel.y += jump
		$AnimatedSprite.play("jump")
	if A:
		atack()
		
	if is_on_floor() and vel.x == 0 and not atkFlag:
		$AnimatedSprite.play("idle")
	vel.x = vel.x*speed

func _ready():
	$AnimatedSprite.play("idle")
	$DamageArea/CollisionShape2D.disabled = true

# warning-ignore:unused_argument
func _physics_process(delta):
	vel.y = vel.y + grav
	get_input()
	vel = move_and_slide(vel, Vector2.UP)
	if vel.y != 0:
		$AnimatedSprite.play("jump")
	
	if atkFlag:
		$DamageArea/CollisionShape2D.disabled = false
	else:
		$DamageArea/CollisionShape2D.disabled = true
		
	if $AnimatedSprite.flip_h:
		$DamageArea.position.x = -58.667
	else:
		$DamageArea.position.x = 58.667


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"): #or body.is_in_group("boss"):
		hearts -= 1


func _on_AtkTimer_timeout():
	atkFlag = false
	pass # Replace with function body.


func _on_DamageArea_body_entered(body):
	if body.is_in_group("enemy"):
		body.queue_free()
	
	if body.is_in_group("boss"):
		body.hearts -= 1


func _on_HitBox_area_entered(area):
	if area.is_in_group("damage"):
		hearts -= 1
