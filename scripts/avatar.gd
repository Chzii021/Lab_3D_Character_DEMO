extends Node3D

const SKIN := preload("res://assets/gojo.png")
const PIXEL_SCALE := 0.1

var pose_name := "idle"
var base_material: StandardMaterial3D
var overlay_material: StandardMaterial3D
var player: AnimationPlayer


func _ready() -> void:
	_build_materials()
	_build_character()
	_build_animations()
	player.play(pose_name)


func _build_materials() -> void:
	base_material = StandardMaterial3D.new()
	base_material.albedo_texture = SKIN
	base_material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	base_material.roughness = 0.9
	base_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	base_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	base_material.alpha_scissor_threshold = 0.5
	overlay_material = base_material.duplicate() as StandardMaterial3D


func _build_character() -> void:
	var body := _pivot("Body", Vector3(0, 1.8, 0), self)
	_add_box(body, "Torso", 16, 16, 8, 12, 4, 0.0, 1.0, Vector3.ZERO)
	_add_box(body, "Jacket", 16, 32, 8, 12, 4, 0.0, 1.0, Vector3.ZERO, true)

	var head := _pivot("Head", Vector3(0, 2.4, 0), self)
	_add_box(head, "Face", 0, 0, 8, 8, 8, 0.0, 1.0, Vector3(0, 0.4, 0))
	_add_box(head, "Hair", 32, 0, 8, 8, 8, 0.0, 1.0, Vector3(0, 0.4, 0), true)

	_build_limb("LeftArm", Vector3(-0.6, 2.4, 0), 32, 48, 48, 48, true)
	_build_limb("RightArm", Vector3(0.6, 2.4, 0), 40, 16, 40, 32, true)
	_build_limb("LeftLeg", Vector3(-0.2, 1.2, 0), 16, 48, 0, 48, false)
	_build_limb("RightLeg", Vector3(0.2, 1.2, 0), 0, 16, 0, 32, false)


func _build_limb(limb_name: String, pivot_position: Vector3, x: int, y: int, overlay_x: int, overlay_y: int, is_arm: bool) -> void:
	var upper := _pivot(limb_name, pivot_position, self)
	var width_px := 4
	var depth_px := 4
	_add_box(upper, "Upper", x, y, width_px, 12, depth_px, 0.0, 0.5, Vector3(0, -0.3, 0))
	_add_box(upper, "UpperOverlay", overlay_x, overlay_y, width_px, 12, depth_px, 0.0, 0.5, Vector3(0, -0.3, 0), true)
	var lower_name := "Forearm" if is_arm else "Shin"
	var lower := _pivot(limb_name + lower_name, Vector3(0, -0.6, 0), upper)
	_add_box(lower, "Lower", x, y, width_px, 12, depth_px, 0.5, 1.0, Vector3(0, -0.3, 0))
	_add_box(lower, "LowerOverlay", overlay_x, overlay_y, width_px, 12, depth_px, 0.5, 1.0, Vector3(0, -0.3, 0), true)


func _pivot(node_name: String, at: Vector3, parent: Node3D) -> Node3D:
	var node := Node3D.new()
	node.name = node_name
	node.position = at
	parent.add_child(node)
	return node


func _add_box(parent: Node3D, node_name: String, atlas_x: int, atlas_y: int, width_px: int, height_px: int, depth_px: int, section_from: float, section_to: float, at: Vector3, overlay: bool = false) -> void:
	var part := MeshInstance3D.new()
	part.name = node_name
	part.mesh = _box_mesh(atlas_x, atlas_y, width_px, height_px, depth_px, section_from, section_to, 1.06 if overlay else 1.0)
	part.material_override = overlay_material if overlay else base_material
	part.position = at
	parent.add_child(part)


func _box_mesh(atlas_x: int, atlas_y: int, width_px: int, height_px: int, depth_px: int, section_from: float, section_to: float, size_multiplier: float) -> ArrayMesh:
	var x := width_px * PIXEL_SCALE * size_multiplier * 0.5
	var y := height_px * (section_to - section_from) * PIXEL_SCALE * size_multiplier * 0.5
	var z := depth_px * PIXEL_SCALE * size_multiplier * 0.5
	var side_y := atlas_y + depth_px + height_px * section_from
	var side_h := height_px * (section_to - section_from)
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	_face(st, [Vector3(-x, y, z), Vector3(x, y, z), Vector3(x, -y, z), Vector3(-x, -y, z)], Vector2(atlas_x + depth_px, side_y), Vector2(width_px, side_h), Vector3.FORWARD)
	_face(st, [Vector3(x, y, -z), Vector3(-x, y, -z), Vector3(-x, -y, -z), Vector3(x, -y, -z)], Vector2(atlas_x + depth_px * 2 + width_px, side_y), Vector2(width_px, side_h), Vector3.BACK)
	_face(st, [Vector3(-x, y, -z), Vector3(-x, y, z), Vector3(-x, -y, z), Vector3(-x, -y, -z)], Vector2(atlas_x, side_y), Vector2(depth_px, side_h), Vector3.LEFT)
	_face(st, [Vector3(x, y, z), Vector3(x, y, -z), Vector3(x, -y, -z), Vector3(x, -y, z)], Vector2(atlas_x + depth_px + width_px, side_y), Vector2(depth_px, side_h), Vector3.RIGHT)
	_face(st, [Vector3(-x, y, -z), Vector3(x, y, -z), Vector3(x, y, z), Vector3(-x, y, z)], Vector2(atlas_x + depth_px, atlas_y), Vector2(width_px, depth_px), Vector3.UP)
	_face(st, [Vector3(-x, -y, z), Vector3(x, -y, z), Vector3(x, -y, -z), Vector3(-x, -y, -z)], Vector2(atlas_x + depth_px + width_px, atlas_y), Vector2(width_px, depth_px), Vector3.DOWN)
	return st.commit()


func _face(st: SurfaceTool, points: Array, origin: Vector2, size: Vector2, normal: Vector3) -> void:
	var uv := [origin, origin + Vector2(size.x, 0), origin + size, origin + Vector2(0, size.y)]
	for i in [0, 1, 2, 0, 2, 3]:
		st.set_normal(normal)
		st.set_uv(uv[i] / 64.0)
		st.add_vertex(points[i])


func _build_animations() -> void:
	player = AnimationPlayer.new()
	player.name = "AnimationPlayer"
	player.root_node = NodePath("..")
	add_child(player)
	var lib := AnimationLibrary.new()
	lib.add_animation("idle", _make_idle())
	lib.add_animation("walk", _make_walk())
	lib.add_animation("run", _make_run())
	lib.add_animation("wave", _make_wave())
	lib.add_animation("tpose", _make_tpose())
	player.add_animation_library("", lib)


func _new_loop(length: float) -> Animation:
	var animation := Animation.new()
	animation.length = length
	animation.loop_mode = Animation.LOOP_LINEAR
	return animation


func _rotation_keys(animation: Animation, node_path: String, keys: Array) -> void:
	var track := animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track, NodePath(node_path + ":rotation_degrees"))
	for key in keys:
		animation.track_insert_key(track, key[0], Vector3(key[1], key[2], key[3]))


func _position_keys(animation: Animation, node_path: String, keys: Array) -> void:
	var track := animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track, NodePath(node_path + ":position"))
	for key in keys:
		animation.track_insert_key(track, key[0], Vector3(key[1], key[2], key[3]))


func _make_idle() -> Animation:
	var animation := _new_loop(2.0)
	_rotation_keys(animation, "LeftArm", [[0.0, 3, 0, -6], [1.0, -3, 0, -3], [2.0, 3, 0, -6]])
	_rotation_keys(animation, "RightArm", [[0.0, -3, 0, 6], [1.0, 3, 0, 3], [2.0, -3, 0, 6]])
	_rotation_keys(animation, "Head", [[0.0, 0, -6, 0], [1.0, 0, 6, 0], [2.0, 0, -6, 0]])
	_position_keys(animation, "Body", [[0.0, 0, 1.8, 0], [1.0, 0, 1.82, 0], [2.0, 0, 1.8, 0]])
	return animation


func _make_walk() -> Animation:
	var animation := _new_loop(1.0)
	_rotation_keys(animation, "LeftArm", [[0.0, -25, 0, -5], [0.5, 25, 0, -5], [1.0, -25, 0, -5]])
	_rotation_keys(animation, "RightArm", [[0.0, 25, 0, 5], [0.5, -25, 0, 5], [1.0, 25, 0, 5]])
	_rotation_keys(animation, "LeftLeg", [[0.0, 32, 0, 0], [0.5, -32, 0, 0], [1.0, 32, 0, 0]])
	_rotation_keys(animation, "RightLeg", [[0.0, -32, 0, 0], [0.5, 32, 0, 0], [1.0, -32, 0, 0]])
	_rotation_keys(animation, "LeftLeg/LeftLegShin", [[0.0, 10, 0, 0], [0.25, 35, 0, 0], [0.5, 5, 0, 0], [1.0, 10, 0, 0]])
	_rotation_keys(animation, "RightLeg/RightLegShin", [[0.0, 5, 0, 0], [0.5, 10, 0, 0], [0.75, 35, 0, 0], [1.0, 5, 0, 0]])
	_position_keys(animation, "Body", [[0.0, 0, 1.8, 0], [0.25, 0, 1.86, 0], [0.5, 0, 1.8, 0], [0.75, 0, 1.86, 0], [1.0, 0, 1.8, 0]])
	return animation


func _make_run() -> Animation:
	var animation := _new_loop(0.6)
	_rotation_keys(animation, "LeftArm", [[0.0, -48, 0, -8], [0.3, 48, 0, -8], [0.6, -48, 0, -8]])
	_rotation_keys(animation, "RightArm", [[0.0, 48, 0, 8], [0.3, -48, 0, 8], [0.6, 48, 0, 8]])
	_rotation_keys(animation, "LeftLeg", [[0.0, 50, 0, 0], [0.3, -50, 0, 0], [0.6, 50, 0, 0]])
	_rotation_keys(animation, "RightLeg", [[0.0, -50, 0, 0], [0.3, 50, 0, 0], [0.6, -50, 0, 0]])
	_rotation_keys(animation, "LeftArm/LeftArmForearm", [[0.0, -28, 0, 0], [0.6, -28, 0, 0]])
	_rotation_keys(animation, "RightArm/RightArmForearm", [[0.0, -28, 0, 0], [0.6, -28, 0, 0]])
	_position_keys(animation, "Body", [[0.0, 0, 1.8, 0], [0.15, 0, 1.93, 0], [0.3, 0, 1.8, 0], [0.45, 0, 1.93, 0], [0.6, 0, 1.8, 0]])
	return animation


func _make_wave() -> Animation:
	var animation := _new_loop(1.6)
	_rotation_keys(animation, "RightArm", [[0.0, 0, 0, 130], [0.4, 0, 0, 165], [0.8, 0, 0, 130], [1.2, 0, 0, 165], [1.6, 0, 0, 130]])
	_rotation_keys(animation, "RightArm/RightArmForearm", [[0.0, 0, 0, 25], [0.4, 0, 0, -25], [0.8, 0, 0, 25], [1.2, 0, 0, -25], [1.6, 0, 0, 25]])
	_rotation_keys(animation, "Head", [[0.0, 0, -8, 0], [0.8, 0, 8, 0], [1.6, 0, -8, 0]])
	return animation


func _make_tpose() -> Animation:
	var animation := _new_loop(1.0)
	_rotation_keys(animation, "LeftArm", [[0.0, 0, 0, -90], [1.0, 0, 0, -90]])
	_rotation_keys(animation, "RightArm", [[0.0, 0, 0, 90], [1.0, 0, 0, 90]])
	return animation
