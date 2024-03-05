class_name ResourceUtils


## Get `Resource` property names (as `Dictionary` with prop name). Can be used to compare against other
##   property lists to avoid overriding resource-specific fields (will cause reference errors)!
static func get_resource_properties() -> Dictionary:
    var prop_names: Dictionary = {}
    for prop in Resource.new().get_property_list():
        prop_names[prop.name] = true
    return prop_names


## Assign a parent resource's property values to a child instance (ie. when using inheritance), which
##   can then be modified afterwards to fulfill child-specific properties. Will not assign `Resource` props!
static func assign_resource_properties_from_parent(
    parent_instance: Variant,
    child_instance: Variant
) -> Variant:
    var resource_prop_names = get_resource_properties()

    for prop in parent_instance.get_property_list():
        if !resource_prop_names.has(prop.name):
            child_instance.set(prop.name, parent_instance.get(prop.name))

    return child_instance
