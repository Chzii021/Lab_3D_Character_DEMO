extends Node3D

const AVATAR := preload("res://LegacyGojoCharacter.tscn")
const POSES := ["idle", "walk", "run", "wave"]
const TITLES := ["IDLE", "WALK", "RUN", "WAVE"]
const ACCENTS := [Color("76d8ff"), Color("b1a0ff"), Color("fba6d2"), Color("a0f7ca")]
const X_POSITIONS := [-3.9, -1.3, 1.3, 3.9]

var avatars: Array[Node3D] = []
var time_passed := 0.0


func _ready() -> void:
	_make_environment()
	_make_stage()
	_make_camera()
	_make_lights()
	_make_characters()
	_make_title()


func _process(delta: float) -> void:
	time_passed += delta
	if avatars.size() == 4:
		avatars[0].rotation.y = sin(time_passed * 0.7) * 0.12
		avatars[1].rotation.y = -0.15
		avatars[2].rotation.y = 0.12
		avatars[3].rotation.y += delta * 0.45


func _make_environment() -> void:
	var world := WorldEnvironment.new()
	world.name = "WorldEnvironment"
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("0b1020")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("a7b9de")
	env.ambient_light_energy = 0.65
	world.environment = env
	add_child(world)


func _make_stage() -> void:
	var floor := _box("Stage", Vector3(11.5, 0.28, 4.2), Color("1a2440"))
	floor.position = Vector3(0, -0.27, 0)
	for i in range(4):
		var pedestal := MeshInstance3D.new()
		pedestal.name = "Pedestal_%d" % (i + 1)
		var cylinder := CylinderMesh.new()
		cylinder.top_radius = 0.95
		cylinder.bottom_radius = 1.05
		cylinder.height = 0.2
		pedestal.mesh = cylinder
		pedestal.material_override = _material(Color("273453"))
		pedestal.position = Vector3(X_POSITIONS[i], -0.06, 0)
		add_child(pedestal)
		var rim := MeshInstance3D.new()
		rim.name = "Rim_%d" % (i + 1)
		var torus := TorusMesh.new()
		torus.inner_radius = 0.91
		torus.outer_radius = 1.01
		rim.mesh = torus
		var rim_mat := _material(ACCENTS[i])
		rim_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		rim.material_override = rim_mat
		rim.position = Vector3(X_POSITIONS[i], 0.045, 0)
		add_child(rim)
		var plate := _box("Plate_%d" % (i + 1), Vector3(2.0, 0.08, 0.68), Color("111a2c"))
		plate.position = Vector3(X_POSITIONS[i], -0.1, 1.68)


func _make_camera() -> void:
	var camera := Camera3D.new()
	camera.name = "Camera3D"
	camera.position = Vector3(0, 3.4, 11.9)
	camera.fov = 58.0
	add_child(camera)
	camera.look_at(Vector3(0, 1.64, 0))
	camera.current = true


func _make_lights() -> void:
	var key := DirectionalLight3D.new()
	key.name = "KeyLight"
	key.light_color = Color("f0f5ff")
	key.light_energy = 1.35
	key.shadow_enabled = true
	key.rotation_degrees = Vector3(-45, -27, 0)
	add_child(key)
	for i in range(4):
		var light := OmniLight3D.new()
		light.name = "AccentLight_%d" % (i + 1)
		light.position = Vector3(X_POSITIONS[i], 3.8, -1.3)
		light.light_color = ACCENTS[i]
		light.light_energy = 0.65
		light.omni_range = 4.5
		add_child(light)


func _make_characters() -> void:
	for i in range(4):
		var avatar := AVATAR.instantiate() as Node3D
		avatar.name = "Gojo_%s" % TITLES[i]
		avatar.pose_name = POSES[i]
		avatar.position = Vector3(X_POSITIONS[i], 0.05, 0)
		add_child(avatar)
		avatars.append(avatar)
		var label := Label3D.new()
		label.name = "PoseLabel_%d" % (i + 1)
		label.text = TITLES[i]
		label.font_size = 48
		label.pixel_size = 0.006
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		label.modulate = ACCENTS[i]
		label.position = Vector3(X_POSITIONS[i], -0.02, 1.72)
		add_child(label)


func _make_title() -> void:
	var title := Label3D.new()
	title.name = "Title"
	title.text = "GOJO  /  ANIMATION DEMO"
	title.font_size = 60
	title.pixel_size = 0.008
	title.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	title.modulate = Color("e3ecff")
	title.position = Vector3(0, 4.05, 0)
	add_child(title)


func _box(node_name: String, size: Vector3, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size
	node.mesh = mesh
	node.material_override = _material(color)
	add_child(node)
	return node


func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.88
	return material
