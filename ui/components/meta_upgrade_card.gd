extends PanelContainer
class_name MetaUpgradeCard

signal purchased(upgrade: MetaUpgrade)

@onready var animation_player = $AnimationPlayer
@onready var amount_label = $%AmountLabel
@onready var cost_label = $%CostLabel
@onready var experience_progress_bar = $%ExperienceProgressBar
@onready var description_label = $%DescriptionLabel
@onready var name_label = $%NameLabel
@onready var purchase_button = $%PurchaseButton

var upgrade: MetaUpgrade


func _ready():
    purchase_button.pressed.connect(on_purchase_button_pressed)


func get_amount_text(upgrade: MetaUpgrade, quantity: int) -> String:
    if upgrade.max_quantity <= 0:
        return "(x%s)" % quantity
    elif upgrade.max_quantity == 1:
        return "Unique"
    else:
        return "%s / %s" % [quantity, upgrade.max_quantity]


func set_meta_upgrade(upgrade: MetaUpgrade):
    self.upgrade = upgrade
    name_label.text = upgrade.name
    description_label.text = upgrade.description
    update_progress()


## Update card progress values (ie. after making purchases, etc)
func update_progress():
    if !upgrade:
        return

    var purchased_quantity := MetaProgression.get_purchased_upgrade_quantity(upgrade.id)
    var max_quantity := upgrade.max_quantity
    var has_max_quantity := purchased_quantity >= max_quantity if max_quantity > 0 else false

    var cost = upgrade.cost
    var cost_percent := clampf(MetaProgression.upgrade_currency / cost, 0, 1)
    experience_progress_bar.value = cost_percent if !has_max_quantity else 0.0

    amount_label.text = get_amount_text(upgrade, purchased_quantity)

    cost_label.visible = !has_max_quantity
    if !has_max_quantity:
        cost_label.text = "%s / %s" % [MetaProgression.upgrade_currency, cost]

    purchase_button.disabled = cost_percent < 1 || has_max_quantity


func on_purchase_button_pressed():
    if !upgrade:
        return

    var success := MetaProgression.purchase_meta_upgrade(upgrade)
    if !success:
        return

    purchased.emit(upgrade)

    animation_player.play("selected")
    await animation_player.animation_finished
