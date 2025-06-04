extends Node2D

@onready var animationPlayer = $AnimationPlayer
var direction: Vector2 = Vector2(0, 0)
var speed: int = 450
signal click

func _ready():
	init()

func init():
	direction = Vector2(1, 0)
	animationPlayer.play("Move")
	await get_tree().create_timer(2).timeout
	direction = Vector2(0, 0)
	animationPlayer.play("Idle")
	
	
func _process(delta):
	position += direction * speed * delta

func _on_button_pressed():
	emit_signal("click")
	call_deferred("queue_free")
