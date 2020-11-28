extends Control

export(int) var slot_count := 9
export(int) var columns := 3

var blue_staff_texture := preload("res://assets/items/blue_staff.png")

func _ready() -> void:
	$GridContainer.columns = columns
	for i in slot_count:
		var texture_rect = TextureRect.new()
		texture_rect.name = str(i)
		texture_rect.texture = blue_staff_texture
		$GridContainer.add_child(texture_rect)
