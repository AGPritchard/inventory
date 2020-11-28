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

var blue_staff_texture := preload("res://assets/items/blue_staff.png")
var green_bow_texture := preload("res://assets/items/green_bow.png")
var orange_sword_texture := preload("res://assets/items/orange_sword.png")
var red_shield_texture := preload("res://assets/items/red_shield.png")

func _ready() -> void:
	randomize()
	
	$GridContainer.columns = columns
	for i in slot_count:
		var texture_rect = TextureRect.new()
		texture_rect.name = str(i)
		
		# pick a random item type
		var choice: int = ITEM_TYPES.values()[randi() % ITEM_TYPES.size()]
		match choice:
			ITEM_TYPES.STAFF:
				texture_rect.texture = blue_staff_texture
			ITEM_TYPES.BOW:
				texture_rect.texture = green_bow_texture
			ITEM_TYPES.SWORD:
				texture_rect.texture = orange_sword_texture
			ITEM_TYPES.SHIELD:
				texture_rect.texture = red_shield_texture
			ITEM_TYPES.NONE:
				continue
		
		$GridContainer.add_child(texture_rect)
