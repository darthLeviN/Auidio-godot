extends Control

@onready var temporal_graph: = %TemporalGraph
@onready var frequency_slider = %FrequencySlider
@onready var frequency_value = %FrequencyValue


func _ready():
	temporal_graph.current_time = 0.0
	temporal_graph.queue_redraw()


func _process(delta):
	temporal_graph.current_time += delta
	var fv = frequency_slider.value*temporal_graph.upper_frequency
	var newp := Vector2(fv, 1.0)
	print_debug(fv)
	temporal_graph.add_new_point2(newp)
	
	frequency_value.text = "%dHz" % (fv)
	

