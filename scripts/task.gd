# task.gd

class_name AITask

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal success

var stat #stat we're tracking
var count #how much it has to go up by
var length #in seconds
var instructions #in seconds

var current_progress = 0

func init(stat, count, length, instructions):
	self.stat = stat
	self.count = count
	self.length = length
	self.instructions = instructions


func add_progress(count) :
	current_progress += count
