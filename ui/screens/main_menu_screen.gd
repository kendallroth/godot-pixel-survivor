extends CanvasLayer


func _ready():
    $%QuitButton.pressed.connect(on_quit_pressed)
    $%PlayButton.pressed.connect(on_play_pressed)
    $%OptionsButton.pressed.connect(on_options_pressed)


func on_options_pressed():
    var options_menu_instance = await GameScreens.add_scene(GameScreens.OPTIONS_MENU_SCENE_REF, self, true)
    options_menu_instance.back_pressed.connect(on_options_closed.bind(options_menu_instance))
    # Apparently must hide "Main Menu" to allow "Options Menu" to display (layering issue?)
    visible = false


func on_options_closed(options_instance: Node):
    visible = true
    options_instance.queue_free()


func on_play_pressed():
    GameScreens.change_scene(GameScreens.GAME_SCENE_PATH)


func on_quit_pressed():
    GameScreens.quit_game()
