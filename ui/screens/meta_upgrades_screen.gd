extends CanvasLayer

@export var upgrade_card_scene: PackedScene
@export var meta_upgrades: Array[MetaUpgrade] = []

@onready var upgrade_cards_grid = $%UpgradeCardsGrid
@onready var currency_label = $%ExperienceLabel

var reset_press_count = 0


func _ready():
    $%BackButton.pressed.connect(on_back_pressed)
    $%ResetButton.pressed.connect(on_reset_pressed)

    currency_label.text = str(MetaProgression.upgrade_currency)
    
    # NOTE: May have children for UX mockup reference
    for child in upgrade_cards_grid.get_children():
        child.queue_free()

    for upgrade in meta_upgrades:
        var card_instance: MetaUpgradeCard = upgrade_card_scene.instantiate()
        upgrade_cards_grid.add_child(card_instance)

        card_instance.set_meta_upgrade(upgrade)
        card_instance.purchased.connect(on_upgrade_purchased)


func update_cards():
    currency_label.text = str(MetaProgression.upgrade_currency)

    for card in get_tree().get_nodes_in_group("meta_upgrade_card"):
        if card is MetaUpgradeCard:
            card.update_progress()


func on_back_pressed():
    GameScreens.change_scene(GameScreens.MAIN_MENU_SCENE_PATH)


func on_upgrade_purchased(upgrade: MetaUpgrade):
    update_cards()


func on_reset_pressed():
    reset_press_count += 1
    if reset_press_count <= 2:
        return

    # TODO: Confirmation dialog workflow
    MetaProgression.reset_progression()
    update_cards()
