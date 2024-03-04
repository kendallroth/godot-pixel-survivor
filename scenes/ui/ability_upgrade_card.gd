extends PanelContainer
class_name AbilityUpgradeCard

signal selected()

@onready var amount_label = $%AmountLabel
@onready var description_label = $%DescriptionLabel
@onready var max_amount_label = $%MaxAmountLabel
@onready var name_label = $%NameLabel


func _ready():
    gui_input.connect(on_gui_input)


func get_max_amount_text(item: AbilityUpgradeUI) -> String:
    if item.upgrade.max_quantity <= 0:
        return ""
    elif item.upgrade.max_quantity == 1:
        return "Unique"
    else:
        return "Max  %s" % item.upgrade.max_quantity if item.upgrade.max_quantity else ""


func set_ability_upgrade(item: AbilityUpgradeUI):
    name_label.text = item.upgrade.name
    description_label.text = item.upgrade.description
    max_amount_label.text = get_max_amount_text(item)
    max_amount_label.visible = !!max_amount_label.text
    amount_label.text = "(x%s)" % item.quantity if item.quantity > 0 else ""
    amount_label.visible = !!amount_label.text


func on_gui_input(event: InputEvent):
    if !event.is_action_pressed("menu_select"):
        return

    selected.emit()
