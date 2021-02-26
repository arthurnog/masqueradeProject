extends KinematicBody2D

export (int) var speed = 100
export (int) var grav = 100

onready var player = get_parent().get_node("Player")

var vel = Vector2()

var active = false

func _ready():
	vel.x = 0
	$AnimatedSprite.play("idle")
	active = false

func get_pos():
	vel.x = 0
	#se o inimigo estiver a esquerda do player ele anda pra direita
	#se estiver a direita ele anda pra esquerda
	if position.x > player.position.x:
		vel.x -= 1
		$AnimatedSprite.flip_h = true
	else:
		vel.x += 1
		$AnimatedSprite.flip_h = false
	vel.x = vel.x*speed

# warning-ignore:unused_argument
func _physics_process(delta):
	vel.y = vel.y + grav
	vel = move_and_slide(vel, Vector2.UP)
	if $VisibilityNotifier2D.is_on_screen():
		active = true
	if active:
		get_pos()
		if vel.x != 0:
			$AnimatedSprite.play("run")
		else:
			$AnimatedSprite.play("idle")


func _on_Area2D_area_entered(area):
	if area.is_in_group("damage"):
		queue_free()
	pass # Replace with function body.
