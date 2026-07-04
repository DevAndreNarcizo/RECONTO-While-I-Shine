extends Control
## Menu principal — Jogar (seleção de lenda/bioma), Árvore Sagrada, Opções,
## Créditos e Sair.

const CREDITS_TEXT := "RECONTO: Enquanto Eu Brilhar

Um jogo de folclore brasileiro.
Enquanto as histórias forem contadas, os Encantados não morrem.

Design e desenvolvimento: André Narcizo
Feito com Godot Engine e Claude Code."

@onready var luar_label: Label = $Center/VBox/LuarLabel
@onready var play: Button = $Center/VBox/Play
@onready var tree: Button = $Center/VBox/Tree
@onready var options: Button = $Center/VBox/Options
@onready var credits: Button = $Center/VBox/Credits
@onready var quit: Button = $Center/VBox/Quit
@onready var credits_dialog: AcceptDialog = $CreditsDialog

func _ready() -> void:
	luar_label.text = "❖ Cristais de Luar: %d" % SaveManager.luar
	play.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/LegendSelect.tscn"))
	tree.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/SacredTree.tscn"))
	options.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/OptionsScreen.tscn"))
	credits.pressed.connect(func(): credits_dialog.popup_centered())
	quit.pressed.connect(func(): get_tree().quit())
	credits_dialog.dialog_text = CREDITS_TEXT
	play.grab_focus()
