extends CanvasLayer
class_name DebugOverlay


@onready var debug_list_container = $%DebugListContainer
@onready var debug_list_title = $%TitleLabel

## Dictionary of debug item IDs/objects
var debug_items: Dictionary


func _ready():
    # TODO: Change `DebugOverlay` to use a singleton to instead update from code (can initialize then...)
    GameEvents.enemy_count_changed.connect(on_enemy_count_changed)
    GameEvents.level_difficulty_changed.connect(on_level_difficulty_changed)
    GameEvents.player_experience_changed.connect(on_player_experience_changed)
    GameEvents.player_health_changed.connect(on_player_health_changed)
    GameEvents.player_level_changed.connect(on_player_level_changed)

    set_item_string("health", "Health", "-")
    set_item_string("level", "Level", "-")
    set_item_string("xp", "XP", "-")
    set_item_string("xp_total", "XP (All)", "-")
    set_item_string("difficulty", "Difficulty", "-")
    set_item_string("enemies", "Enemies", "-")


func clear_list():
    debug_items.clear()
    update_list_ui()


func remove_item(id: String):
    debug_items.erase(id)
    update_list_ui()


func set_item(id: String, item: DebugValue):
    debug_items[id] = item
    update_list_ui()


## Shortcut for setting a simple string key/value item
func set_item_string(id: String, label: String, value: String):
    var debug_item = DebugValue.create(label, value)
    set_item(id, debug_item)


## Updating UI clears and then repopulates (not ideal, but works)
func update_list_ui():
    for child in debug_list_container.get_children():
        child.queue_free()

    for key in debug_items.keys():
        var item = debug_items[key] as DebugValue
        if !item.visible:
            continue

        var label_node = debug_list_title.duplicate()
        label_node.text = "%s: %s" % [item.label, item.value]
        debug_list_container.add_child(label_node)


#region Listeners
func on_enemy_count_changed(current_count: int, total_count: int):
    set_item_string("enemies", "Enemies", "%s (%s)" % [current_count, total_count])


func on_level_difficulty_changed(difficulty: int):
    set_item_string("difficulty", "Difficulty", "%s" % difficulty)

func on_player_experience_changed(current_experience: int, target_experience: int, total_experience: int):
    set_item_string("xp", "XP", "%s / %s" % [current_experience, target_experience])
    set_item_string("xp_total", "XP (All)", "%s" % total_experience)


func on_player_health_changed(current_health: float, change: float, max_health: float):
    set_item_string("health", "Health", "%.1d / %d" % [current_health, max_health])


func on_player_level_changed(current_level: int):
    set_item_string("level", "Level", "%s" % current_level)
#endregion
