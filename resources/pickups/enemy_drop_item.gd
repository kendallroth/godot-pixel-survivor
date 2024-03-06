extends WeightedResource
class_name EnemyDropItem

@export var item_scene: PackedScene
## Amount of dropped item (ie. xp vial amount, etc)
@export_range(1, 100) var drop_amount: int = 1
