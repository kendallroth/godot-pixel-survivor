extends Node2D
class_name SwordAbility


## NOTE: Must be called *after* adding to scene tree!
func initialize(_damage: float):
    $HitboxComponent.damage = _damage
