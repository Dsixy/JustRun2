extends State

var speed: int = 0

func enter():
	speed = own.speed
	
func physical_process(delta):
	var direction = (self.own.target - self.own.global_position).normalized()
	var velocity = direction * speed
	self.own.move_and_collide(velocity * delta)
