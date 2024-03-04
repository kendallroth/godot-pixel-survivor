extends Resource
## UI wrapper for `AbilityUpgrade` (for UI configuration)
class_name AbilityUpgradeUI

var upgrade: AbilityUpgrade
var quantity: int = 0


static func create(upgrade: AbilityUpgrade, quantity: int):
    var instance = AbilityUpgradeUI.new()
    instance.upgrade = upgrade
    instance.quantity = quantity
    return instance

