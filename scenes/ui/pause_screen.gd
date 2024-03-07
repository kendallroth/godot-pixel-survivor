extends CanvasLayer
class_name PauseScreen

@onready var animation_player = $AnimationPlayer
@onready var content_container = $ContentContainer
@onready var resume_button = $%ResumeButton
@onready var options_button = $%OptionsButton
@onready var main_menu_button = $%MainMenuButton

var closing := false


func _ready():
    resume_button.pressed.connect(on_resume_button_pressed)
    options_button.pressed.connect(on_options_button_pressed)
    main_menu_button.pressed.connect(on_main_menu_button_pressed)

    process_mode = Node.PROCESS_MODE_ALWAYS
    # set_process_input(true)
    get_tree().paused = true
    animation_player.play("default")
    closing = false

    content_container.pivot_offset = content_container.size / 2
    tween_content(true)


func _exit_tree():
    # Ensure game is always unpaused when leaving "Pause Screen"
    get_tree().paused = false


func _unhandled_input(event):
    if event.is_action_pressed("menu_back"):
        close_menu()
        # Let Godot know that event has been handled
        get_tree().root.set_input_as_handled()


func close_menu():
    if closing:
        return
    
    closing = true
    animation_player.play_backwards("default")

    var tween = tween_content(false)
    await tween.finished

    queue_free()


func tween_content(tweening_in: bool) -> Tween:
    var base_scale = Vector2.ZERO if tweening_in else Vector2.ONE
    var target_scale = Vector2.ONE if tweening_in else Vector2.ZERO
    var ease_type = Tween.EASE_OUT if tweening_in else Tween.EASE_IN

    var tween = create_tween()
    # Fix for animating control node that is child of container node
    tween.tween_property(content_container, "scale", base_scale, 0)
    tween.tween_property(content_container, "scale", target_scale, 0.3)\
        .set_ease(ease_type).set_trans(Tween.TRANS_BACK)
    return tween



func on_main_menu_button_pressed():
    GameScreens.change_scene(GameScreens.MAIN_MENU_SCENE_PATH)


func on_options_button_pressed():
    var options_menu_instance: OptionsMenu = GameScreens.add_scene(GameScreens.OPTIONS_MENU_SCENE_REF, self)
    options_menu_instance.back_pressed.connect(on_options_menu_back_pressed.bind(options_menu_instance))


func on_options_menu_back_pressed(options_menu_instance: Node):
    options_menu_instance.queue_free()


func on_resume_button_pressed():
    close_menu()
