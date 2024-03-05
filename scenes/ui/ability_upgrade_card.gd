extends PanelContainer
class_name AbilityUpgradeCard

signal selected()

@onready var animation_player = $AnimationPlayer
@onready var amount_label = $%AmountLabel
@onready var description_label = $%DescriptionLabel
@onready var max_amount_label = $%MaxAmountLabel
@onready var name_label = $%NameLabel

var disabled := false


func _ready():
    gui_input.connect(on_gui_input)
    mouse_entered.connect(on_mouse_entered)


func animate_in(delay: float = 0):
    modulate = Color.TRANSPARENT
    await get_tree().create_timer(delay).timeout
    animation_player.play("in")
    await get_tree().process_frame
    modulate = Color.WHITE


func animate_discard():
    animation_player.play("discarded")


func animate_out():
    # animation_player.play("out")
    pass


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


func select_card():
    disabled = true
    animation_player.play("selected")
    
    for other_card in get_tree().get_nodes_in_group("upgrade_card"):
        if other_card == self || !other_card is AbilityUpgradeCard:
            continue
        
        (other_card as AbilityUpgradeCard).animate_discard()
    
    await animation_player.animation_finished
    selected.emit()


func on_gui_input(event: InputEvent):
    if disabled || !event.is_action_pressed("menu_select"):
        return

    select_card()


func on_mouse_entered():
    if disabled:
        return

    $HoverAnimationPlayer.play("hover")
