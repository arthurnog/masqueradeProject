extends KinematicBody2D

export (int) var speed = 100
export (int) var grav = 50

onready var player = get_parent().get_node("Player")

var vel = Vector2()

func get_pos():
	vel = Vector2()
	#se o inimigo estiver a esquerda do player ele anda pra direita
	#se estiver a direita ele anda pra esquerda
	if position.x > player.position.x:
		vel.x -= 1
		$AnimatedSprite.flip_h = true
	else:
		vel.x += 1
		$AnimatedSprite.flip_h = false
	vel.x = vel.x*speed

func _physics_process(delta):
	vel.y = vel.y + grav
	get_pos()
	vel = move_and_slide(vel, Vector2.UP)
	pass
