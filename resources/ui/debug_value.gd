extends Resource
class_name DebugValue

var label: String
var value: String
var visible := true


static func create(label: String, value: String) -> DebugValue:
    var instance = DebugValue.new()
    instance.label = label
    instance.value = value
    return instance


func set_value(value: String):
    self.value = value


func set_display(show: bool):
    visible = show


func toggle_display():
    visible = !visible
