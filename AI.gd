extends Node

signal new_task_given
signal task_succeeded
signal task_failed

var stat_names = [ "lever_flicked", "door_opened", "player_moved", "player_jumped", "player_interacted", "seen_player"]
var stat_values = {}

var is_player_moving = false

var current_task : AITask

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for stat in stat_names :
		stat_values[stat] = 0
	
	for object in get_tree().get_nodes_in_group("lever") :
		object.connect("flicked", self, "_on_lever_flicked")
	
	for object in get_tree().get_nodes_in_group("ai") :
		object.connect("seen_player", self, "_on_seen_player")
	
	for object in get_tree().get_nodes_in_group("door") :
		object.connect("opened", self, "_on_door_opened")
	
	for object in get_tree().get_nodes_in_group("player") :
		object.connect("player_moved", self, "_on_player_moved")
		object.connect("player_jumped", self, "_on_player_jumped")
		object.connect("player_interacted", self, "_on_player_interacted")

func _generate_new_task():
	var new_task : AITask = AITask.new()
	var random_stat_number = randi()%7+1
	var random_count_number = randi()%5+1
	var random_length_number = randi()%15+5
	
	var stat = stat_names[random_stat_number - 1]
	
	if stat == "seen_player" :
		random_count_number = 1
	if stat == "player_moved" :
		random_count_number = 60
	
	new_task.init(stat, random_count_number, random_length_number, _get_task_description(stat, random_count_number) )
	current_task = new_task
	$current_task_timer.wait_time = random_length_number
	$current_task_timer.start()
	emit_signal("new_task_given", new_task)


func _get_task_description(stat_name, count):
	match stat_name:
		"lever_flicked": return "Do me a favour and flick " + str(count) + " levers..."
		"door_opened": return "Time for some door testing. Open " + str(count) + "..."
		"player_moved": return "You need some exercice. Keep moving!"
		"player_jumped": return "I need to test the artificial gravity... Jump " + str(count) + " times"
		"player_interacted": return "Could you fiddle around with some stuff..." + str(count) + " times"
		"seen_player": return "Let me have a good look at you..."

# We need to give a task
func _on_task_give_timer_timeout():
	_generate_new_task()

# the current task has ended
func _on_current_task_timer_timeout():
	emit_signal("task_failed")
	current_task = null

func _add_count(stat_name):
	stat_values[stat_name] += 1

	if current_task :
		if current_task.stat == stat_name :
			current_task.add_progress(1)
			if current_task.current_progress >= current_task.count :
				$current_task_timer.stop()
				current_task = null
				emit_signal("task_succeeded")

func _on_lever_flicked():
	_add_count("lever_flicked")
	
func _on_door_opened():
	_add_count("door_opened")

func _on_player_moved():
	_add_count("player_moved")

func _on_player_jumped():
	_add_count("player_jumped")
	
func _on_player_interacted():
	_add_count("player_interacted")

func _on_seen_player():
	_add_count("seen_player")

func _on_player_moving_timer_timeout():
	pass
