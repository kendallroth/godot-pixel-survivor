extends Node
class_name GameManager

signal game_time_changed(seconds: int)
signal game_difficulty_changed(difficulty: int)

## How frequently difficulty level is raised (in seconds)
const DIFFICULTY_RAISE_INTERVAL = 10

## Game length
@export_range(0, 60 * 10) var game_time_total = 120
@export var experience_manager: ExperienceManager

@onready var game_timer = $GameTimer

var game_difficulty = 1
## Time elapsed since game started
var game_time_elapsed = 0

var game_time_remaining:
    get:
        return game_time_total - game_time_elapsed


func _ready():
    GameEvents.player_died.connect(on_player_died)
    game_timer.timeout.connect(on_timer_tick)

    # NOTE: Must wait to emit event until next frame (to allow listeners to attach)
    Callable(func(): game_time_changed.emit(game_time_total)).call_deferred()


func _unhandled_input(event):
    if event.is_action_pressed("menu_back"):
        pause_game()
        # Let Godot know that event has been handled
        get_tree().root.set_input_as_handled()


func pause_game():
    if get_tree().paused:
        return
    
    GameScreens.add_scene(GameScreens.PAUSE_MENU_SCENE_REF, self)


func show_game_over(win: bool):
    MetaProgression.write_save()
    game_timer.paused = true
    var game_over_menu_instance: GameOverScreen = await GameScreens.add_scene(GameScreens.GAME_OVER_SCENE_REF, self)
    game_over_menu_instance.show_screen(win, experience_manager.total_experience)


func on_timer_tick():
    game_time_elapsed += 1
    game_time_changed.emit(game_time_remaining)

    var target_difficulty = game_time_elapsed / DIFFICULTY_RAISE_INTERVAL
    if target_difficulty > game_difficulty:
        game_difficulty += 1
        game_difficulty_changed.emit(game_difficulty)
        GameEvents.game_difficulty_changed.emit(game_difficulty)

    if game_time_elapsed >= game_time_total:
        show_game_over(true)
        game_timer.stop()


func on_player_died():
    show_game_over(false)
