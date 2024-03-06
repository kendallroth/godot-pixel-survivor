extends Node
class_name LevelManager

signal level_time_changed(seconds: int)
signal level_difficulty_changed(difficulty: int)

## How frequently difficulty level is raised (in seconds)
const DIFFICULTY_INTERVAL = 5

## Game length
@export_range(0, 120) var level_time_total = 60
@export var game_over_screen_scene: PackedScene
@export var pause_screen_scene: PackedScene

@onready var level_timer = $LevelTimer

var level_difficulty = 0
## Time elapsed since level started
var level_time_elapsed = 0

var level_time_remaining:
    get:
        return level_time_total - level_time_elapsed


func _ready():
    GameEvents.player_died.connect(on_player_died)
    level_timer.timeout.connect(on_timer_tick)

    set_process_input(true)
    # NOTE: Must wait to emit event until next frame (to allow listeners to attach)
    Callable(func(): level_time_changed.emit(level_time_total)).call_deferred()


func _input(event):
    if event.is_action_pressed("menu_back"):
        pause_game()


func pause_game():
    if get_tree().paused:
        return
    
    var pause_screen_instance = pause_screen_scene.instantiate() as PauseScreen
    add_child(pause_screen_instance)


func show_game_over(win: bool):
    level_timer.paused = true
    var game_over_screen_instance = game_over_screen_scene.instantiate() as GameOverScreen
    add_child(game_over_screen_instance)

    if (win):
        game_over_screen_instance.show_victory()
    else:
        game_over_screen_instance.show_defeat()


func on_timer_tick():
    level_time_elapsed += 1
    level_time_changed.emit(level_time_remaining)

    var target_difficulty = level_time_elapsed / DIFFICULTY_INTERVAL
    if target_difficulty > level_difficulty:
        level_difficulty += 1
        level_difficulty_changed.emit(level_difficulty)
        GameEvents.level_difficulty_changed.emit(level_difficulty)

    if level_time_elapsed >= level_time_total:
        show_game_over(true)
        level_timer.stop()


func on_player_died():
    show_game_over(false)
