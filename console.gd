extends Node2D


signal give_resource

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const RATE_OF_OPEN_PROGRESS_DROP = 60

export var RESOURCE_A_SECOND = 5.0
export var give_resource_name = "power"

var progress = 0

onready var progress_bar = $progress_bar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if progress > 0 :
		$progress_bar.visible = true
		progress -= RATE_OF_OPEN_PROGRESS_DROP * delta
		progress_bar.animate_to_value(progress)
		
		if progress_bar.get_value() >= progress_bar.get_max_value() :
			$arrow_up.visible = true
			emit_signal("give_resource", give_resource_name, RESOURCE_A_SECOND * delta)
		else :
			$arrow_up.visible = false
	else :
		$arrow_up.visible = false
		$progress_bar.visible = false
		progress = 0
		progress_bar.animate_to_value(0)


func _on_interact_area_interacted():
	if progress <= 100 :
		progress += 10
