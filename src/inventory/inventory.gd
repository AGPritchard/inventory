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
var can_swap := true

var blue_staff_texture := preload("res://assets/items/blue_staff.png")
var green_bow_texture := preload("res://assets/items/green_bow.png")
var orange_sword_texture := preload("res://assets/items/orange_sword.png")
var red_shield_texture := preload("res://assets/items/red_shield.png")

func _ready() -> void:
	VisualServer.set_default_clear_color(Color8(41, 30, 49, 255))
	randomize()
	
	$VBoxContainer/GridContainer.columns = columns
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
		item_slot.connect("mouse_entered", self, "_on_item_slot_mouse_entered", [i])
		item_slot.connect("mouse_exited", self, "_on_item_slot_mouse_exited", [i])
		$VBoxContainer/GridContainer.add_child(item_slot)
	
	$VBoxContainer.set_anchors_and_margins_preset(Control.PRESET_CENTER)

func _on_item_slot_input(event: InputEvent, slot_number: int) -> void:
	if can_swap:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
			if selected_item.empty():
				selected_item["slot_number"] = slot_number
				selected_item["item_type"] = inventory[slot_number]
			else:
				# swap items
				inventory[selected_item["slot_number"]] = inventory[slot_number]
				inventory[slot_number] = selected_item["item_type"]
				
				# swap textures
				var target_slot: TextureRect = $VBoxContainer/GridContainer.get_child(slot_number)
				var selected_slot: TextureRect = $VBoxContainer/GridContainer.get_child(selected_item["slot_number"])
				var selected_item_texture := selected_slot.texture
				selected_slot.texture = target_slot.texture
				target_slot.texture = selected_item_texture
				
				# swap tooltips
				var selected_item_tooltip := selected_slot.hint_tooltip
				selected_slot.hint_tooltip = target_slot.hint_tooltip
				target_slot.hint_tooltip = selected_item_tooltip
				
				# clear selected item
				selected_item = {}

func _on_item_slot_mouse_entered(slot_number: int) -> void:
	var item_slot: TextureRect = $VBoxContainer/GridContainer.get_child(slot_number)
	item_slot.rect_scale = Vector2(1.1, 1.1)

func _on_item_slot_mouse_exited(slot_number: int) -> void:
	var item_slot: TextureRect = $VBoxContainer/GridContainer.get_child(slot_number)
	item_slot.rect_scale = Vector2(1, 1)

func _on_SortButton_pressed() -> void:
	# sort inventory
	for i in range(1, inventory.size(), 1):
		var item = inventory[i]
		var j = i - 1
		while j >= 0 and item < inventory[j]:
			inventory[j + 1] = inventory[j]
			j -= 1
		inventory[j + 1] = item
	
	# update ui
	for i in inventory.size():
		var item_slot: TextureRect = $VBoxContainer/GridContainer.get_child(i)
		match inventory[i]:
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
			ITEM_TYPES.NONE:
				item_slot.texture = null
				item_slot.hint_tooltip = ""
		
		# update alpha if search bar contains data
		if !$VBoxContainer/HBoxContainer/SearchBar.text.empty():
			item_slot.modulate.a = 1.0
			if item_slot.hint_tooltip.to_upper() != $VBoxContainer/HBoxContainer/SearchBar.text.to_upper():
				item_slot.modulate.a = 0.25

func _on_SearchBar_text_changed(new_text: String) -> void:
	if new_text.empty():
		can_swap = true
		for i in inventory.size():
			var item_slot: TextureRect = $VBoxContainer/GridContainer.get_child(i)
			item_slot.modulate.a = 1.0
	else:
		can_swap = false
		for i in inventory.size():
			var item_slot: TextureRect = $VBoxContainer/GridContainer.get_child(i)
			
			# reset alpha and then update if a match occurs
			item_slot.modulate.a = 1.0
			if item_slot.hint_tooltip.to_upper() != new_text.to_upper():
				item_slot.modulate.a = 0.25
