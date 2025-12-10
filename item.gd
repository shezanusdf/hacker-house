extends Area2D

@export var item_name: String = "Item"

signal collected(item_name)

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("collected", item_name)
		queue_free()


func _on_collected(item_name: Variant) -> void:
	pass # Replace with function body.
