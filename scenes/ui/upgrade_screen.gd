extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var cards_container = $%AbilityCardsContainer


func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS
    get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgradeUI]):
    for item in upgrades:
        var card_instance = upgrade_card_scene.instantiate() as AbilityUpgradeCard
        cards_container.add_child(card_instance)
        card_instance.set_ability_upgrade(item)
        card_instance.selected.connect(on_upgrade_selected.bind(item.upgrade))


func on_upgrade_selected(upgrade: AbilityUpgrade):
    upgrade_selected.emit(upgrade)
    get_tree().paused = false
    queue_free()
