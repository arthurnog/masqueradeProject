extends KinematicBody2D

export (int) var speed = 130
const teleportSpeed = 300
export (int) var grav = 50
export (int) var hearts = 4

onready var player = get_parent().get_node("Player")

var atkFlag = false
var atkReady = true
var atkType
var active = false
var i

var runFlag = true #provavelmente não vou usar

var vel = Vector2()
var dir #direção que o player está
var dif #diferença de distância entre o bos e o player

func _ready():
	dir = 0
	vel.x = 0
	active = false
	atkReady = false
	$Cooldown.start()
	atkFlag = false
	runFlag =  true
	$AnimatedSprite.play("idle")
	$DamageArea0/CollisionShape2D.disabled = true
	$DamageArea1/CollisionShape2D.disabled = true

func atk0():
	if atkReady:
		atkFlag = true
		runFlag = false
		atkType = 0
		vel = Vector2()
		$AnimatedSprite.play("atk0")
		$waitA0.start()

func _on_waitA0_timeout():
	$DamageArea0/CollisionShape2D.disabled = false
	$TimerAtk0.start()

func _on_TimerAtk0_timeout():
	$DamageArea0/CollisionShape2D.disabled = true
	atkFlag = false
	runFlag = true
	$Cooldown.start()

func atk1():
	if atkReady:
		atkFlag = true
		runFlag = false
		atkType = 1
		vel = Vector2()
		$AnimatedSprite.play("atk1")
		$waitA1.start()

func _on_waitA1_timeout():
	$DamageArea1/CollisionShape2D.disabled = false
	$TimerAtk1.start()

func _on_TimerAtk1_timeout():
	$DamageArea1/CollisionShape2D.disabled = true
	atkFlag = false
	runFlag = true
	$Cooldown.start()

func skill0(): #skill de teleporte do boss
	atkType = 2
	if atkReady:
		runFlag = false
		$TimerSkl0.start()
		$AnimatedSprite.play("skill0")
		yield($AnimatedSprite, "animation_finished")
		position.x = player.position.x + 85
	else:
		if dif <= 80:
			runFlag = false
			$TimerSkl0.start()
			$AnimatedSprite.play("skill0")
			yield($AnimatedSprite, "animation_finished")
			position.x = player.position.x + 300

func _on_TimerSkl0_timeout():
	runFlag = true

func randAtk():
	if atkReady:
		randomize()
		i = randi()%3
		if i == 0:
			atk0()
		elif i == 1:
			atk1()
		elif i == 2:
			skill0()
	else:
		skill0()

func get_pos():
	vel = Vector2()
	#se o inimigo estiver a esquerda do player ele anda pra direita
	#se estiver a direita ele anda pra esquerda
	if position.x > player.position.x:
		vel.x -= 1
		$AnimatedSprite.flip_h = true
		$DamageArea1.position.x = -32
	else:
		vel.x += 1
		$AnimatedSprite.flip_h = false
		$DamageArea1.position.x = 32
	vel.x = vel.x*speed
	

# warning-ignore:unused_argument
func _physics_process(delta):
	if hearts == 0:
		vel.x = 0
		$AnimatedSprite.play("die")
		yield($AnimatedSprite, "animation_finished")
		queue_free()
	

func _on_Cooldown_timeout():
	atkReady = true



func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.

