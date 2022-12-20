extends Control

@onready var temporal_graph_pack = %TemporalGraphPack
@onready var frequency_slider = %FrequencySlider
@onready var volume_slider = %VolumeSlider
@onready var frequency_value = %FrequencyValue
@onready var show_octaves_checkbox = %ShowOctavesCheckbox
@onready var show_tones_checkbox = %ShowTonesCheckbox

func _ready():
	var tgn = temporal_graph_pack.tgn
	tgn.current_time = 0.0
	tgn.queue_redraw()
	show_octaves_checkbox.button_pressed = temporal_graph_pack.show_octaves
	show_tones_checkbox.button_pressed = temporal_graph_pack.show_notes
	

func _process(delta):
	var tgn = temporal_graph_pack.tgn
	tgn.current_time += delta
	
	var fv = pow(frequency_slider.value, 3.0)
	fv = fv*tgn.upper_frequency
	var newp := Vector2(fv, volume_slider.value)
	tgn.add_new_point2(newp)
	
	frequency_value.text = "%dHz" % (fv)

func _on_show_octaves_checkbox_toggled(button_pressed):
	temporal_graph_pack.show_octaves = button_pressed


func _on_show_tones_checkbox_toggled(button_pressed):
	temporal_graph_pack.show_notes = button_pressed
