## AUTOLOADED

extends Node

const SAVE_FILE_PATH = "user://game.save"

var blank_save_data: Dictionary = {
    "upgrade_currency": 0,
    "meta_upgrades": {}
}

var save_data: Dictionary = blank_save_data.duplicate(true)

## Current upgrade currency
var upgrade_currency:
    get:
        return save_data["upgrade_currency"]


func _ready():
    GameEvents.player_experience_changed.connect(on_player_experience_changed)

    process_mode = Node.PROCESS_MODE_ALWAYS
    load_save()


## Purchase a meta upgrade (indicates success/failure)
func purchase_meta_upgrade(upgrade: MetaUpgrade, skip_cost = false) -> bool:
    if !skip_cost:
        if upgrade_currency < upgrade.cost:
            push_warning("Cannot purchase upgrade (insufficient currency)!")
            return false

        save_data["upgrade_currency"] -= upgrade.cost

    if !has_purchased_upgrade(upgrade.id):
        save_data["meta_upgrades"][upgrade.id] = {
            "quantity": 0
        }
    
    save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
    write_save()
    return true


## Get whether player has purchased a meta upgrade
func has_purchased_upgrade(upgrade_id: String) -> bool:
    return true if save_data["meta_upgrades"].has(upgrade_id) else false


## Get current quantity of a meta upgrade that player has purchased
func get_purchased_upgrade_quantity(upgrade_id: String) -> int:
    if !has_purchased_upgrade(upgrade_id):
        return 0

    return save_data["meta_upgrades"][upgrade_id]["quantity"]


## Reset players progression
func reset_progression():
    save_data = blank_save_data.duplicate(true)
    write_save()


func load_save():
    if !FileAccess.file_exists(SAVE_FILE_PATH):
        return
    
    var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
    save_data = file.get_var()
    print("Loaded save file", save_data)


func write_save():
    var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
    file.store_var(save_data)


#region Listeners
func on_player_experience_changed(
    current_level_experience: int, current_level_progress: float, change: int, total_experience: int
):
    if change <= 0:
        return

    save_data["upgrade_currency"] += change
    write_save()
#endregion
