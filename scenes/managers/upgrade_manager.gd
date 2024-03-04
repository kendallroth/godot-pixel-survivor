extends Node
class_name UpgradeManager

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

const UPGRADE_OPTIONS = 2

var current_upgrades = {}

func _ready():
    experience_manager.leveled_up.connect(on_leveled_up)


func check_has_upgrade(upgrade: AbilityUpgrade) -> bool:
    return current_upgrades.has(upgrade.id)


func is_upgrade_available(upgrade: AbilityUpgrade) -> bool:
    if upgrade.required_ability && !check_has_upgrade(upgrade.required_ability):
        return false

    # NOTE: Could also simply remove these items from upgrade pool when max is reached instead
    if upgrade.max_quantity > 0:
        var existing_upgrade = current_upgrades.get(upgrade.id)
        if existing_upgrade && existing_upgrade.quantity >= upgrade.max_quantity:
            return false

    return true


func get_available_upgrades() -> Array[AbilityUpgrade]:
    var available_upgrades = upgrade_pool.duplicate()
    # Ensure received unique items cannot be selected again
    available_upgrades = available_upgrades.filter(is_upgrade_available)
    available_upgrades.shuffle()

    var show_count = min(available_upgrades.size(), UPGRADE_OPTIONS)
    available_upgrades = available_upgrades.slice(0, show_count)

    return available_upgrades


func apply_upgrade(upgrade: AbilityUpgrade):
    if !check_has_upgrade(upgrade):
        current_upgrades[upgrade.id] = {
            "resource": upgrade,
            "quantity": 1
        }
    else:
        current_upgrades[upgrade.id]["quantity"] += 1

    GameEvents.player_upgraded_ability.emit(upgrade, current_upgrades)
    print(current_upgrades)


func map_upgrade_for_ui(upgrade: AbilityUpgrade) -> AbilityUpgradeUI:
    var current_upgrade = current_upgrades.get(upgrade.id)
    var quantity = current_upgrade.quantity if current_upgrade else 0
    return AbilityUpgradeUI.create(upgrade, quantity)


func on_leveled_up(level: int):
    var random_upgrades = get_available_upgrades()
    if !random_upgrades.size():
        return

    var upgrade_screen_instance = upgrade_screen_scene.instantiate() as UpgradeScreen
    add_child(upgrade_screen_instance)

    var _upgrade_options = random_upgrades.map(map_upgrade_for_ui)
    @warning_ignore("unassigned_variable") # Necessary workaround for Array typing bug...
    var upgrade_options: Array[AbilityUpgradeUI]
    upgrade_options.assign(_upgrade_options)
    upgrade_screen_instance.set_ability_upgrades(upgrade_options)
    upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
    apply_upgrade(upgrade)
