extends Control
## Menu principal — Jogar, Árvore Sagrada, Sair.

@onready var luar_label: Label = $Center/VBox/LuarLabel
@onready var play: Button = $Center/VBox/Play
@onready var tree: Button = $Center/VBox/Tree
@onready var quit: Button = $Center/VBox/Quit

func _ready() -> void:
	luar_label.text = "❖ Cristais de Luar: %d" % SaveManager.luar
	play.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/world/World.tscn"))
	tree.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/SacredTree.tscn"))
	quit.pressed.connect(func(): get_tree().quit())
	play.grab_focus()
