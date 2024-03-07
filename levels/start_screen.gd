extends CanvasLayer


# Pretty transition to "Main Screen" when game loads
func _ready():
    GameScreens.change_scene(GameScreens.MAIN_MENU_SCENE_PATH)
