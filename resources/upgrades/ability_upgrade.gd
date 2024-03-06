extends Resource
class_name AbilityUpgrade

# TODO: Implemente item weighting

@export var id: String
@export var name: String
@export_multiline var description: String
## Required ability for this upgrade to be an option
@export var required_ability: AbilityUpgrade
## Maximum quantity of this upgrade (`0` is unlimited)
@export var max_quantity: int = 0
