extends Node

@onready var temporal_graph_pack = %TemporalGraphPack
@onready var tgn = temporal_graph_pack.tgn
@export_range(0.0,100.0) var clarity_threshold := 0.05

@onready var show_octaves_cb = %ShowOctavesCb
@onready var show_notes_cb = %ShowNotesCb
@onready var clarity_thr_slider = %ClarityThrSlider
@onready var clarity_threshold_value = %ClarityThresholdValue

func _ready():
	tgn.current_time = 0.0
	tgn.queue_redraw()
	
	clarity_thr_slider.value = 0.2

func _process(delta):
	var arr := AudioServerMgr.get_record_peaks()
	var tgn = temporal_graph_pack.tgn
	tgn.current_time += delta
	var newp : Vector2
	if arr.size() > 0:
		newp = arr[0]
	tgn.add_new_point2(newp)
	print_debug(newp)


func _on_show_octaves_cb_toggled(button_pressed):
	var tgn = temporal_graph_pack.tgn
	tgn.show_octaves = button_pressed


func _on_show_notes_cb_toggled(button_pressed):
	var tgn = temporal_graph_pack.tgn
	tgn.show_octaves = button_pressed


func _on_clarity_thr_slider_value_changed(value):
	var clvalue : float = pow(value, 3.0) * 5.0
	print_debug(clvalue)
	AudioServerMgr.set_record_peaks_clarity(clvalue)
	var clvalue_text := "%.2f" % clvalue
	clarity_threshold_value.text = clvalue_text
	tgn.clarity_threshold = clvalue
