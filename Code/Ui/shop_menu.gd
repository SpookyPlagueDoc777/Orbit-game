extends Control

@onready var power_purchase: Button = $ActualButtons/ShopContainer/PowerRect/PowerPurchase
@onready var spin_purchase: Button = $ActualButtons/ShopContainer/SpinRect/SpinPurchase
@onready var shield_purchase: Button = $ActualButtons/ShopContainer/ShieldRect/ShieldPurchase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#power_purchase.connect("")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_power_purchase_pressed() -> void:
	pass # Replace with function body.
	# Add sfx here


func _on_spin_purchase_pressed() -> void:
	pass # Replace with function body.
	# Add sfx here


func _on_shield_purchase_pressed() -> void:
	pass # Replace with function body.
	# Add sfx here
