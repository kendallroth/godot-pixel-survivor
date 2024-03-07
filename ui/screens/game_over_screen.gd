extends CanvasLayer
class_name GameOverScreen

@onready var content_container = $%ContentContainer
@onready var title_label = $%TitleLabel
@onready var message_label = $%MessageLabel
@onready var restart_button = $%RestartButton
@onready var main_menu_button = $%MainMenuButton


func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS
    
    content_container.pivot_offset = content_container.size / 2
    var tween = create_tween()
    # NOTE: Workaround for Godot
    tween.tween_property(content_container, "scale", Vector2.ZERO, 0)
    tween.tween_property(content_container, "scale", Vector2.ONE, 0.3)\
        .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
    
    get_tree().paused = true
    restart_button.pressed.connect(on_restart_button_pressed)
    main_menu_button.pressed.connect(on_quit_button_pressed)


func _exit_tree():
    # Ensure game is always unpaused when leaving "Game Over Screen"
    get_tree().paused = false


func show_defeat():
    title_label.text = "Defeat"
    message_label.text = "You lost!"
    play_jingle(false)


func show_victory():
    title_label.text = "Victory"
    message_label.text = "You won!"
    play_jingle(true)


func play_jingle(win := true):
    if win:
        $VictoryAudioPlayer.play()
    else:
        $DefeatAudioPlayer.play()


func on_restart_button_pressed():
    GameScreens.change_scene(GameScreens.GAME_SCENE_PATH)


func on_quit_button_pressed():
    GameScreens.change_scene(GameScreens.MAIN_MENU_SCENE_PATH)
