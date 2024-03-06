extends PickupItem

@onready var pickup_component := $PickupItemComponent

func _ready():
    pickup_component.collected.connect(on_collected)


func on_collected():
    # TODO: Find better way of handling (perhaps player pickup component?), as using intermediary
    #         game events feels wrong/bad...
    GameEvents.event_health_collected.emit(pickup_amount)
