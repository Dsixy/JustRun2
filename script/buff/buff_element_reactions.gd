extends RefCounted
class_name BuffElementReactions

const DamageTypes = preload("res://script/damage_types.gd")
const BuffIds = preload("res://script/buff/buff_ids.gd")

class ReactionContext:
	var damage: DamageInfo
	var lightning_chain_range: float = -1.0
	var lightning_max_targets: int = -1
	var spread_burning_stacks: int = 0

static func apply(enemy: BaseEnemy, damage: DamageInfo) -> ReactionContext:
	var ctx := ReactionContext.new()
	ctx.damage = damage
	if damage.skip_element_reactions:
		return ctx

	var manager = enemy.buffManager
	var dtype := DamageTypes.normalize(damage.damageType)
	var level := _source_stat(damage.source, "level", 0)
	var insight := _source_stat(damage.source, "insight", 0)

	match dtype:
		DamageTypes.FIRE:
			_apply_fire(manager, ctx, level, insight)
		DamageTypes.ICE:
			_apply_ice(manager, ctx, level, insight)
		DamageTypes.PHYSICAL:
			_apply_physical(manager, ctx, level, insight)
		DamageTypes.LIGHTNING:
			_apply_lightning(enemy, manager, ctx, insight)

	return ctx

static func _apply_fire(manager, ctx: ReactionContext, level: int, insight: int) -> void:
	if manager.has_buff(BuffIds.POISON):
		var poison = manager.get_buff(BuffIds.POISON)
		if poison:
			poison.tickInterval = 0.4
	if manager.has_buff(BuffIds.FROST_BITE):
		ctx.damage.bonus += (150.0 + 2.5 * level + 5.0 * insight) / 100.0
		manager.get_buff(BuffIds.FROST_BITE).expire()

static func _apply_ice(manager, ctx: ReactionContext, level: int, insight: int) -> void:
	if manager.has_buff(BuffIds.POISON):
		var poison = manager.get_buff(BuffIds.POISON)
		if poison:
			poison.duration = 7.0
			poison.elapsed = 0.0
	if manager.has_buff(BuffIds.BURNING):
		ctx.damage.bonus += (50.0 + level + 1.2 * insight) / 100.0
		var burning = manager.get_buff(BuffIds.BURNING)
		if burning:
			burning.reduce_stack(1)

static func _apply_physical(manager, ctx: ReactionContext, level: int, insight: int) -> void:
	if manager.has_buff(BuffIds.FROST_BITE):
		ctx.damage.baseAmount += 2.0 + level + 0.4 * insight

static func _apply_lightning(enemy: BaseEnemy, manager, ctx: ReactionContext, insight: int) -> void:
	if manager.has_buff(BuffIds.POISON):
		var poison = manager.get_buff(BuffIds.POISON)
		if poison and poison.get("damage"):
			poison.damage.baseAmount *= 1.5
	if manager.has_buff(BuffIds.FROST_BITE):
		ctx.lightning_chain_range = 450.0
		ctx.lightning_max_targets = 6
	if manager.has_buff(BuffIds.WEAKEN):
		manager.get_buff(BuffIds.WEAKEN).expire()
		var extra := DamageInfo.new(
			20.0 + 3.0 * insight, 0, false, 1.0, ctx.damage.source, DamageTypes.PSYCHIC
		)
		extra.skip_element_reactions = true
		extra.apply_lightning_buff = false
		enemy._apply_bonus_damage(extra)
	if manager.has_buff(BuffIds.BURNING):
		var burning = manager.get_buff(BuffIds.BURNING)
		if burning:
			ctx.spread_burning_stacks = burning.curStack

static func _source_stat(source, prop: String, default_value: int) -> int:
	if source == null:
		return default_value
	if source.get(prop) != null:
		return int(source.get(prop))
	if source is BaseWeapon and source.player and source.player.get(prop) != null:
		return int(source.player.get(prop))
	return default_value
