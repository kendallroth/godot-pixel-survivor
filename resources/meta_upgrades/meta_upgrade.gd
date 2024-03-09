extends Resource
class_name MetaUpgrade

# TODO: Consider including quantity with upgrade resource???
@export var id: String
@export var name: String
@export_multiline var description: String
## Base base_cost (not including upgrade level multiplier)
@export var base_cost := 100
## Multiplier for determining cost for next upgrade level (applied against previous cost)
@export_range(1, 20) var level_cost_multiplier := 2
@export_range(0, 100) var max_quantity := 1


## Meta upgrade cost doubles for each level
var cost:
    get:
        var quantity = MetaProgression.get_purchased_upgrade_quantity(self.id)
        return base_cost * pow(level_cost_multiplier, quantity)

