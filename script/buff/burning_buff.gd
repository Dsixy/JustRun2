class_name BurningBuff
extends DotBuff

const DamageTypes = preload("res://script/damage_types.gd")

const maxStack:= 3
var curStack: int = 0

func set_up(source):
	super.set_up(source)
	self.duration = 4.0
	self.tickInterval = 1.0
	
	self.damage = DamageInfo.new(
		2 + source.insight * 0.4 + source.level * 0.2,
		0, false, 1.0, source, DamageTypes.FIRE
	)
	
func stack(buff: Buff):
	super.stack(buff)
	self.curStack = min(self.maxStack, self.curStack + 1)
	_sync_damage_from_stack()

func apply(o):
	super.apply(o)
	self.curStack = 1
	_sync_damage_from_stack()

func reduce_stack(amount: int = 1) -> void:
	if amount <= 0:
		return
	curStack -= amount
	if curStack <= 0:
		expire()
	else:
		_sync_damage_from_stack()

static func apply_stacks_to(target: BaseEnemy, source, stacks: int) -> void:
	if stacks <= 0 or not is_instance_valid(target):
		return
	var scene := preload("res://scene/buff/burning_buff.tscn")
	var buff = scene.instantiate()
	buff.set_up(source)
	target.buffManager.add_buff(buff)
	while buff.curStack < stacks:
		buff.stack(buff)

func _sync_damage_from_stack() -> void:
	if _source == null:
		return
	damage.baseAmount = 2 + curStack * (_source.insight * 0.4 + _source.level * 0.2)
	
func expire():
	super.expire()
