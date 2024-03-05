extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var animation_player = $AnimationPlayer
@onready var cards_container = $%AbilityCardsContainer


func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS
    get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgradeUI]):
    var delay = 0

    for item in upgrades:
        var card_instance = upgrade_card_scene.instantiate() as AbilityUpgradeCard
        cards_container.add_child(card_instance)
        card_instance.set_ability_upgrade(item)
        card_instance.animate_in(delay)
        card_instance.selected.connect(on_upgrade_selected.bind(item.upgrade))
        delay += 0.2


func on_upgrade_selected(upgrade: AbilityUpgrade):
    upgrade_selected.emit(upgrade)
    animation_player.play("out")
    await animation_player.animation_finished
    get_tree().paused = false
    queue_free()
