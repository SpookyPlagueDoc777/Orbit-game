extends Button
class_name KeybindRemapButton

@export var action: String
@export var action_event_index: int = 0

var toggled_now: bool

const JOYSTICK: Dictionary[JoyButton, String] = {
	JoyButton.JOY_BUTTON_A: "A",
	JoyButton.JOY_BUTTON_B: "B",
	JoyButton.JOY_BUTTON_X: "X",
	JoyButton.JOY_BUTTON_Y: "Y",
	JoyButton.JOY_BUTTON_LEFT_SHOULDER: "LB",
	JoyButton.JOY_BUTTON_RIGHT_SHOULDER: "RB",
	JoyButton.JOY_BUTTON_LEFT_STICK: "L3",
	JoyButton.JOY_BUTTON_RIGHT_STICK: "L3",
	JoyButton.JOY_BUTTON_DPAD_UP: "↑",
	JoyButton.JOY_BUTTON_DPAD_DOWN: "↓",
	JoyButton.JOY_BUTTON_DPAD_LEFT: "←",
	JoyButton.JOY_BUTTON_DPAD_RIGHT: "→",
	JoyButton.JOY_BUTTON_START: "Start",
	JoyButton.JOY_BUTTON_GUIDE: "Select"
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_mode = true
	_toggled(false)


func _toggled(toggled_on: bool) -> void:
	toggled_now = toggled_on
	if !action || !InputMap.has_action(action):
		return
	
	if toggled_on == true:
		text = "Choose keybind"
		return
	
	if action_event_index >= InputMap.action_get_events(action).size():
		text = "Unassigned"
		return
	var input = InputMap.action_get_events(action)[action_event_index]
	if input is InputEventJoypadButton:
		if JOYSTICK.has(input.button_index) == true:
			text = JOYSTICK.get(input.button_index)
		else:
			text = "Button " + str(input.button_index)
	elif InputEventKey:
		if input.physical_keycode != 0:
			text = OS.get_keycode_string(input.physical_keycode)
		else:
			text = OS.get_keycode_string(input.keycode)

func _unhandled_input(event: InputEvent) -> void:
	if !InputMap.has_action(action) || !is_pressed():
		return
	
	if event.is_pressed() && (event is InputEventKey || event is InputEventJoypadButton):
		var action_events_list: Array = InputMap.action_get_events(action)
		if action_event_index < action_events_list.size():
			InputMap.action_erase_event(action, action_events_list[action_event_index])
		
		InputMap.action_add_event(action, event)
		action_event_index = InputMap.action_get_events(action).size() - 1
		button_pressed = false
		release_focus()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && toggled_now == true:
		button_pressed = false
		release_focus()
	
	
	
	
	
	
