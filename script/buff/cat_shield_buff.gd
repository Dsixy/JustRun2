extends Buff
var stackNum: int = 0
var maxStack: int = 1

func stack(_buff: Buff):
	self.stackNum = min(self.stackNum+1, self.maxStack)
	
func modify_damage(damage: DamageInfo):
	damage.baseAmount = 0
	self.stackNum -= 1
	if self.stackNum <= 0:
		expire()
	return damage
