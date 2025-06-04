class_name Buff extends Node

@export var ID: int
var _owner
var _source
signal on_expired(buff)

func set_up(source):
	self._source = source
	
func apply(o):
	self._owner = o
	
func process(_delta):
	return
	
func stack(buff: Buff):
	return

func modify_damage(damage: DamageInfo):
	return damage
		
func expire():
	emit_signal("on_expired", self)
