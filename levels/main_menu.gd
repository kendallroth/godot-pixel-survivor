extends CanvasLayer

func _ready():
    $%QuitButton.pressed.connect(on_quit_clicked)
    $%PlayButton.pressed.connect(on_play_clicked)
    $%OptionsButton.pressed.connect(on_options_clicked)


func on_options_clicked():
    pass

func on_play_clicked():
    get_tree().change_scene_to_file("res://levels/game_scene.tscn")

func on_quit_clicked():
    get_tree().quit()
