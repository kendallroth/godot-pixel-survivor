extends Resource
class_name WeightedResource

@export_range(0, 100) var weight: int = 1


# NOTE: Unfortunately cannot type input as passing subclasses (of `WeightedResource`) does not work
#         due to GD Script limitation with array types (passed by reference, retaining original type)
static func get_item(items: Array) -> WeightedResource:
    # Filter out non-WeightedResource items since array arg cannot be typed 🤦‍♀️
    var filtered_items = items.filter(func (item): return item is WeightedResource)

    var weight_sum: int = filtered_items.reduce(func(accum, item): return accum + item.weight, 0)
    var chosen_weight := randi_range(1, weight_sum)
    var iteration_sum := 0
    for item in items:
        iteration_sum += item.weight
        if chosen_weight <= iteration_sum:
            return item

    # Last-ditch effort to pick something (should never happen)
    return items.pick_random()
