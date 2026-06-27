extends HBoxContainer

@onready var line_edit: LineEdit = $LineEdit
@onready var sprite: AnimatedSprite2D = $SatelliteSprite
@onready var upgrade_num: Label = $UpgradeNum
@onready var upgrade_button: Button = $UpgradeContainer/UpgradeButton
var current_price: int = 100

var the_satellite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.updatelist.connect(_on_update_necessary)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_info(satellites) -> void:
	match satellites.satellitetype:
		"Spin":
			sprite.animation = "spin_satellite"
		"Shield":
			sprite.animation = "shield_satellite"
		"Power":
			sprite.animation = "power_satellite"
	sprite.play()
	line_edit.text = satellites.satellitename
	the_satellite = satellites
	#Global.upgrade_all += the_satellite.upgrade * 50 + 100
	upgrade_num.text = str(the_satellite.upgrade)
	current_price = the_satellite.upgrade * 50 + 100
	upgrade_button.text = "Upgrade\n" + str(current_price)


func _on_line_edit_text_changed(new_text: String) -> void:
	the_satellite.satellitename = new_text


func _on_upgrade_button_pressed() -> void:
	if current_price <= Global.energy:
		SoundManager.successful_push()
		Global.energy -= current_price
		the_satellite.upgrade += 1
		upgrade_num.text = str(the_satellite.upgrade)
	else:
		SoundManager.unsuccessful_push()
	Global.upgrade_all += 50
	current_price = the_satellite.upgrade * 50 + 100
	upgrade_button.text = "Upgrade\n" + str(current_price)

func _on_update_necessary() -> void:
	line_edit.text = the_satellite.satellitename
	upgrade_num.text = str(the_satellite.upgrade)
	current_price = the_satellite.upgrade * 50 + 100
	upgrade_button.text = "Upgrade\n" + str(current_price)
	
