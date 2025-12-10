extends Node

var total_items := 3
var collected_items := 0

@onready var ui_label = get_node("/root/World/CanvasLayer/Label")

func win_game():
	ui_label.text = "YOU WIN!"
	get_tree().create_timer(1.5).timeout.connect(func():
		print("Game Complete!")
	)


func _on_item_collected(item_name: Variant) -> void:
	collected_items += 1
	ui_label.text = "Items: %d / %d" % [collected_items, total_items]

	if collected_items >= total_items:
		win_game()
	pass # Replace with function body.
