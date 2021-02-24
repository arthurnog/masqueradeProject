extends KinematicBody2D

export (int) var speed = 130
export (int) var grav = 50
export (int) var jump = -1000

var vel = Vector2() #movimentação do personagem (x,y)

func get_input():
	vel.x = 0
	var R = Input.is_action_pressed("ui_right")
	var L = Input.is_action_pressed("ui_left")
	var U = Input.is_action_just_pressed("jump")
	
	if R:
		vel.x += 1
		$AnimatedSprite.flip_h = false
	if L:
		vel.x -= 1
		$AnimatedSprite.flip_h = true
	if U:
		vel.y += jump
	
	if vel.x != 0 && vel.y == 0:
		$AnimatedSprite.play("run")
	elif vel.y != 0:
		$AnimatedSprite.play("jump")
	else:
		$AnimatedSprite.play("idle")
	
	vel.x = vel.x*speed

# warning-ignore:unused_argument
func _physics_process(delta):
	vel.y = vel.y + grav
	get_input()
	vel = move_and_slide(vel)
	print(vel.y)
