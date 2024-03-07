class_name GameEnums
extends Node

enum PickupItemType {
    ## Default pickup type to workaround issue with Godot refusing to accept `PickupItemType` as a
    ##   property type, even though it was an enum (allowed type). Instead uses `:=` operator to
    ##   assign a valid type.
    NONE,
    HEALTH,
    EXPERIENCE
}
