extends Node

var own
var currentState: State
var stateDict: Dictionary = {}
var initState: String = "Active"

func _ready():
	own = get_parent()
	
	for child in get_children():
		if child is State:
			stateDict[child.name] = child
			child.own = own
			child.connect("toState", _on_state_change)
			
	if initState in stateDict:
		currentState = stateDict[initState]
		currentState.enter()
	
func process(delta):
	if currentState:
		currentState.process(delta)
		
func physics_process(delta):
	if currentState:
		currentState.physical_process(delta)
		
func _change_state(new_state: String):
	if new_state == currentState.name:
		return
	if new_state in stateDict:
		currentState.exit()
		currentState = stateDict[new_state]
		currentState.enter()

func switch_to_state(state: String):
	_change_state(state)

func _on_state_change(old: String, new: String):
	_change_state(new)

