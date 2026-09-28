@tool
extends Node3D

@export_enum("Shooter", "Melee", "Punch") var animation_set := "Shooter"
@export var animation_name := "idle"
@export_range(0.1, 3.0, 0.05) var playback_speed := 1.0
@export var play_on_start := true
@export var repeat_once_clips := true

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if Engine.is_editor_hint() or not play_on_start:
		return
	animation_player.animation_finished.connect(_on_animation_finished)
	play_selected_animation()


func play_selected_animation() -> void:
	var full_name := animation_set + "/" + animation_name
	if not animation_player.has_animation(full_name):
		push_warning("Animation missing: " + full_name)
		return
	animation_player.speed_scale = playback_speed
	animation_player.play(full_name)


func _on_animation_finished(finished_name: StringName) -> void:
	if repeat_once_clips and finished_name == StringName(animation_set + "/" + animation_name):
		play_selected_animation()
