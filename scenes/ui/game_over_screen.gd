extends CanvasLayer
class_name GameOverScreen

@onready var title_label = $%TitleLabel
@onready var message_label = $%MessageLabel
@onready var restart_button = $%RestartButton
@onready var quit_button = $%QuitButton


func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS
    get_tree().paused = true
    restart_button.pressed.connect(on_restart_button_pressed)
    quit_button.pressed.connect(on_quit_button_pressed)


func show_defeat():
    title_label.text = "Defeat"
    message_label.text = "You lost!"


func show_victory():
    title_label.text = "Victory"
    message_label.text = "You won!"


func on_restart_button_pressed():
    get_tree().paused = false
    get_tree().change_scene_to_file("res://levels/main_scene.tscn")


func on_quit_button_pressed():
    get_tree().quit()
