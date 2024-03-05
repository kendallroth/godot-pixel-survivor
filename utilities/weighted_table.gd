class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum = 0


func add_item(item, weight: int):
    items.append({ "item": item, "weight": weight })
    weight_sum += weight


func get_item() -> Variant:
    var chosen_weight := randi_range(1, weight_sum)
    var iteration_sum := 0
    for item in items:
        iteration_sum += item["weight"]
        if chosen_weight <= iteration_sum:
            return item["item"]

    # Last-ditch effort to pick something (should never happen)
    return items.pick_random()


func remove_item(item_to_remove: Variant):
    items = items.filter(func(item): return item["item"] != item_to_remove)
    weight_sum = 0
    for item in items:
        weight_sum += item["weight"]
