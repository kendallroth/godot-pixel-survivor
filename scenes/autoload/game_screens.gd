# AUTOLOADED
extends Node

const GAME_OVER_SCENE_PATH = "res://scenes/ui/game_over_screen.tscn"
const GAME_SCENE_PATH = "res://levels/game_scene.tscn"
const MAIN_MENU_SCENE_PATH = "res://levels/main_menu.tscn"
const OPTIONS_MENU_SCENE_PATH = "res://levels/options_menu.tscn"
const PAUSE_MENU_SCENE_PATH = "res://scenes/ui/pause_screen.tscn"

const GAME_OVER_SCENE_REF = preload(GAME_OVER_SCENE_PATH)
const OPTIONS_MENU_SCENE_REF = preload(OPTIONS_MENU_SCENE_PATH)
const PAUSE_MENU_SCENE_REF = preload(PAUSE_MENU_SCENE_PATH)


## Change game scene (should use constants provided by `GameScreens`)
func change_scene(path: String):
    get_tree().change_scene_to_file(path)


## Add a game scene to current scene (should use constants provided by `GameScreens`)
func add_scene(scene: PackedScene, parent: Node) -> Node:
    var scene_instance := scene.instantiate()
    if parent:
        parent.add_child(scene_instance)
    return scene_instance


func quit():
    get_tree().quit()
