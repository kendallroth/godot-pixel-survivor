extends CanvasLayer
class_name GameOverScreen

@onready var content_container = $%ContentContainer
@onready var title_label = $%TitleLabel
@onready var message_label = $%MessageLabel
@onready var experience_label = $%ExperienceLabel
@onready var continue_button = $%ContinueButton
@onready var main_menu_button = $%MainMenuButton


func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

    continue_button.pressed.connect(on_continue_button_pressed)
    main_menu_button.pressed.connect(on_quit_button_pressed)
    
    content_container.pivot_offset = content_container.size / 2
    var tween = create_tween()
    # NOTE: Workaround for Godot
    tween.tween_property(content_container, "scale", Vector2.ZERO, 0)
    tween.tween_property(content_container, "scale", Vector2.ONE, 0.3)\
        .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
    
    get_tree().paused = true


func _exit_tree():
    # Ensure game is always unpaused when leaving "Game Over Screen"
    get_tree().paused = false


func show_screen(win: bool, xp_earned: int):
    if win:
        title_label.text = "Victory"
        message_label.text = "You won!"
    else:
        title_label.text = "Defeat"
        message_label.text = "You lost!"

    experience_label.text = "%s XP Earned" % xp_earned
    play_jingle(win)


func play_jingle(win := true):
    if win:
        $VictoryAudioPlayer.play()
    else:
        $DefeatAudioPlayer.play()


func on_continue_button_pressed():
    GameScreens.change_scene(GameScreens.META_UPGRADES_SCENE_PATH)


func on_quit_button_pressed():
    GameScreens.change_scene(GameScreens.MAIN_MENU_SCENE_PATH)
