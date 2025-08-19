extends State

var knockBackVelocity: Vector2

func enter():
	knockBackVelocity = own.extraVel
	await get_tree().create_timer(own.staggerTime).timeout
	emit_signal("toState", "Staggered", "Active")
	
func physical_process(delta):
	var velocity = knockBackVelocity
	self.own.move_and_collide(velocity * delta)

func exit():
	own.extraVel = Vector2.ZERO
	own.staggerTime = 0.0
