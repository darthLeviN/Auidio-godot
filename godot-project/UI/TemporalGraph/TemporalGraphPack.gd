@tool
extends Control

const tg_scene := preload("res://UI/TemporalGraph/TemporalGraph.tscn")

var current_time : float = 0.0 :
	set(value):
		current_time = value
		_refresh_variables()
	
@export var time_length : float = 10.0
@export var line_width : float = 4.0
@export var line_color : Color = Color(0.3,0.3,1.0,1.0)
@export var upper_frequency : float = 8000.0
@export_range(20.0, 22000) var lower_frequency : float = 20.0
@export var clarity_threshold : float = 0.05
@export var show_octaves : bool = true :
	set(value):
		if(show_octaves != value):
			show_octaves = value
			if(is_ready):
				_refresh_variables()
	
@export var show_notes : bool = true :
	set(value):
		if(show_notes != value):
			show_notes = value
			if(is_ready):
				_refresh_variables()
		

@onready var tfg = %TemporalFrequencyGrid

var tgn : Node

var is_ready := false
func _ready():
	tgn = tg_scene.instantiate()
	tfg.grid.add_child(tgn)
	_refresh_variables()
	is_ready = true
	
func _refresh_variables():
	for c in tfg.grid.get_children():
		c.set("time_length", time_length)
		c.set("upper_frequency", upper_frequency)
		c.set("lower_frequency", lower_frequency)
		c.set("clarity_threshold", clarity_threshold)
		c.set("show_octaves", show_octaves)
		c.set("show_notes", show_notes)
		c.set("current_time", current_time)
		c.queue_redraw()
	
	tfg.grid.set("upper_frequency", upper_frequency)
	tfg.grid.set("lower_frequency", lower_frequency)
	tfg.grid.set("show_octaves", show_octaves)
	tfg.grid.set("show_notes", show_notes)
	tfg.grid.set("current_time", current_time)
	tfg.grid.queue_redraw()
	
	tfg.ruler.set("upper_frequency", upper_frequency)
	tfg.ruler.set("lower_frequency", lower_frequency)
	tfg.ruler.set("show_octaves", show_octaves)
	tfg.ruler.set("show_notes", show_notes)
	tfg.ruler.set("current_time", current_time)
	tfg.ruler.queue_redraw()
