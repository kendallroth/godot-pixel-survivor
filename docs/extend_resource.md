## Extending Resources

Resources can inherit from other resources, and on occasion it may be beneficial to quickly be able to instantiate a child resource from an existing parent resource. This can be done by instantiating a new child resource, then assigning the applicable parent resource properties to it, before adding the remaining child properties. However, properties from the root `Resource` type **must not** be overridden, as this can cause reference errors (ie. making child appear to refer to parent files, etc). This can be accomplished by skipping any resource properties originating on `Resource` node.

#### `parent_resource.gd`

```gd
extends Resource
class_name ParentResource

var id: string
var name: string
```

#### `child_resource.gd`

```
extends ParentResource
class_name ChildResource

var quantity: int = 0


static func create(upgrade: ParentResource, quantity: int):
    var instance = ParentResource.new()
    instance = ResourceUtils.assign_resource_properties_from_parent(upgrade, instance) as ParentResource

    instance.quantity = quantity
    return instance
```

#### `resource_utils.gd`

```
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
            print("setting %s" % prop.name)
            child_instance.set(prop.name, parent_instance.get(prop.name))

    return child_instance
```