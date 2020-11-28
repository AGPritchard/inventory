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
var selected_item := {}

var blue_staff_texture := preload("res://assets/items/blue_staff.png")
var green_bow_texture := preload("res://assets/items/green_bow.png")
var orange_sword_texture := preload("res://assets/items/orange_sword.png")
var red_shield_texture := preload("res://assets/items/red_shield.png")

func _ready() -> void:
	randomize()
	
	$GridContainer.columns = columns
	for i in slot_count:
		var item_slot = TextureRect.new()
		item_slot.rect_min_size = Vector2(20, 20)
		item_slot.expand = true
		item_slot.name = str(i)
		
		# pick a random item type
		var choice: int = ITEM_TYPES.values()[randi() % ITEM_TYPES.size()]
		match choice:
			ITEM_TYPES.STAFF:
				item_slot.texture = blue_staff_texture
				item_slot.hint_tooltip = "Blue Staff"
			ITEM_TYPES.BOW:
				item_slot.texture = green_bow_texture
				item_slot.hint_tooltip = "Green Bow"
			ITEM_TYPES.SWORD:
				item_slot.texture = orange_sword_texture
				item_slot.hint_tooltip = "Orange Sword"
			ITEM_TYPES.SHIELD:
				item_slot.texture = red_shield_texture
				item_slot.hint_tooltip = "Red Shield"
		
		inventory[i] = choice
		
		item_slot.connect("gui_input", self, "_on_item_slot_input", [i])
		$GridContainer.add_child(item_slot)
	
	$GridContainer.set_anchors_and_margins_preset(Control.PRESET_CENTER)

func _on_item_slot_input(event: InputEvent, slot_number: int) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		if selected_item.empty():
			selected_item["slot_number"] = slot_number
			selected_item["item_type"] = inventory[slot_number]
		else:
			# swap items
			inventory[selected_item["slot_number"]] = inventory[slot_number]
			inventory[slot_number] = selected_item["item_type"]
			
			# swap textures
			var target_slot: TextureRect = $GridContainer.get_child(slot_number)
			var selected_slot: TextureRect = $GridContainer.get_child(selected_item["slot_number"])
			var selected_item_texture := selected_slot.texture
			selected_slot.texture = target_slot.texture
			target_slot.texture = selected_item_texture
			
			# swap tooltips
			var selected_item_tooltip := selected_slot.hint_tooltip
			selected_slot.hint_tooltip = target_slot.hint_tooltip
			target_slot.hint_tooltip = selected_item_tooltip
			
			# clear selected item
			selected_item = {}
