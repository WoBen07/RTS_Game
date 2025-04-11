extends Node2D

var selected_unit: Node = null

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var clicked = get_global_mouse_position()
		var space_state = get_world_2d().direct_space_state

		var query = PhysicsPointQueryParameters2D.new()
		query.position = clicked
		query.collision_mask = 1  # Match your unit's selection Area2D collision layer

		var result = space_state.intersect_point(query)

		if result.size() > 0 and result[0].collider.has_method("set_selected"):
			if selected_unit:
				selected_unit.set_selected(false)
			selected_unit = result[0].collider
			selected_unit.set_selected(true)
		else:
			if selected_unit:
				selected_unit.set_selected(false)
			selected_unit = null

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if selected_unit:
			selected_unit.set_target(get_global_mouse_position())
