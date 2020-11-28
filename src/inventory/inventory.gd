extends Control

enum ITEM_TYPES {
	STAFF,
	BOW,
	SWORD,
	SHIELD,
	NONE,
}

export(int) var slot_count := 9
export(int) var columns := 3

var inventory := {}

var blue_staff_texture := preload("res://assets/items/blue_staff.png")
var green_bow_texture := preload("res://assets/items/green_bow.png")
var orange_sword_texture := preload("res://assets/items/orange_sword.png")
var red_shield_texture := preload("res://assets/items/red_shield.png")

func _ready() -> void:
	randomize()
	
	$GridContainer.columns = columns
	for i in slot_count:
		var item_slot = TextureRect.new()
		item_slot.name = str(i)
		
		# pick a random item type
		var choice: int = ITEM_TYPES.values()[randi() % ITEM_TYPES.size()]
		match choice:
			ITEM_TYPES.STAFF:
				item_slot.texture = blue_staff_texture
			ITEM_TYPES.BOW:
				item_slot.texture = green_bow_texture
			ITEM_TYPES.SWORD:
				item_slot.texture = orange_sword_texture
			ITEM_TYPES.SHIELD:
				item_slot.texture = red_shield_texture
		
		inventory[i] = choice
		
		item_slot.connect("gui_input", self, "_on_item_slot_input", [i])
		$GridContainer.add_child(item_slot)

func _on_item_slot_input(event: InputEvent, slot_number: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print(inventory[slot_number])
