class_name Brick
extends StaticBody2D

func _ready():
	update_collision_layer()

func update_collision_layer():
	#is_visible_in_tree() instead of visible because a node cannot be visible but visible is still true
	set_collision_layer_value(1, is_visible_in_tree())

func _on_visibility_changed():
	update_collision_layer()
