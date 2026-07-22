extends Control

@onready var fade_rect = $FadeRect
@onready var anim = $AnimationPlayer

func fade_out():
	anim.play("fade_out")

func fade_in():
	anim.play("fade_in")
