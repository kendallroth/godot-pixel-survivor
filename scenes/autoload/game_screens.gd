# AUTOLOADED
extends Node


## Transition has fully covered screen (other scenes can be loaded)
signal transition_filled()

const GAME_OVER_SCENE_PATH = "res://ui/screens/game_over_screen.tscn"
const GAME_SCENE_PATH = "res://scenes/levels/game_scene.tscn"
const MAIN_MENU_SCENE_PATH = "res://ui/screens/main_menu_screen.tscn"
const META_UPGRADES_SCENE_PATH = "res://ui/screens/meta_upgrades_screen.tscn"
const OPTIONS_MENU_SCENE_PATH = "res://ui/screens/options_menu.tscn"
const PAUSE_MENU_SCENE_PATH = "res://ui/screens/pause_menu.tscn"

const GAME_OVER_SCENE_REF = preload(GAME_OVER_SCENE_PATH)
const OPTIONS_MENU_SCENE_REF = preload(OPTIONS_MENU_SCENE_PATH)
const PAUSE_MENU_SCENE_REF = preload(PAUSE_MENU_SCENE_PATH)

## Whether to skip transition emission (would happen again when playing animation backwards)
var skip_emit := false


func _ready():
    # Ensure transition screen is never affected by game pause state
    process_mode = Node.PROCESS_MODE_ALWAYS


## Transition to another screen (emits `transitioned_halfway` signal that can be awaited to change scene)
func transition():
    skip_emit = false
    $AnimationPlayer.play("default")
    # Signal is called/emitted at end of animation
    await transition_filled
    skip_emit = true
    $AnimationPlayer.play_backwards("default")


func emit_transitioned_halfway():
    if skip_emit:
        skip_emit = false
        return
    transition_filled.emit()


## Add a game scene to current scene (should use constants provided by `GameScreens`)
func add_scene(scene: PackedScene, parent: Node, should_transition := false) -> Node:
    if should_transition:
        transition()
        await transition_filled
    var scene_instance := scene.instantiate()
    if parent:
        parent.add_child(scene_instance)
    return scene_instance


## Change game scene (should use constants provided by `GameScreens`)
func change_scene(path: String, should_transition := true):
    if should_transition:
        transition()
        await transition_filled
    get_tree().change_scene_to_file(path)


func quit_game():
    transition()
    await transition_filled
    get_tree().quit()
