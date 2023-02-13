extends Node

@onready var temporal_graph_pack = %TemporalGraphPack
@onready var tgn = temporal_graph_pack.tgn
@export_range(0.0,100.0) var clarity_threshold := 0.05
@export_range(0.01,1.0) var volume_threshold := 0.01

@onready var audio_stream_player = %AudioStreamPlayer

@onready var show_octaves_cb = %ShowOctavesCb
@onready var show_notes_cb = %ShowNotesCb
@onready var clarity_thr_slider = %ClarityThrSlider
@onready var clarity_threshold_value = %ClarityThresholdValue
@onready var volume_thr_slider = %VolumeThrSlider
@onready var volume_threshold_value = %VolumeThresholdValue

@onready var enable_test_audio = %EnableTestAudio
@onready var t_audio_option_button = %TAudioOptionButton
@onready var t_instrument_option_button = %TInstrumentOptionButton

var microphone_stream = AudioStreamMicrophone.new()


func _ready():
	tgn.current_time = 0.0
	tgn.queue_redraw()
	show_octaves_cb.button_pressed = true
	show_notes_cb.button_pressed = true
	
	clarity_thr_slider.value = clarity_threshold
	_on_clarity_thr_slider_value_changed(clarity_threshold)
	
	volume_thr_slider.value = volume_threshold
	_on_volume_thr_slider_value_changed(volume_threshold)
	
#
	for key in AudioStreams.test_options:
		t_instrument_option_button.add_item(key)
	t_instrument_option_button.select(0)
	_on_t_instrument_option_button_item_selected(0)
	
	audio_stream_player.stream = microphone_stream
	audio_stream_player.play()
	audio_stream_player.stream_paused = false


func _process(delta):
	var arr := AudioServerMgr.get_record_peaks()
	var tgn = temporal_graph_pack.tgn
	tgn.current_time += delta
	var newp : Vector2
	if arr.size() > 0:
		newp = arr[0]
	tgn.add_new_point2(newp)


func _on_show_octaves_cb_toggled(button_pressed):
	var tgn = temporal_graph_pack.tgn
	tgn.show_octaves = button_pressed


func _on_show_notes_cb_toggled(button_pressed):
	var tgn = temporal_graph_pack.tgn
	tgn.show_octaves = button_pressed


func _on_clarity_thr_slider_value_changed(value):
	var clvalue: float = value
	print_debug(clvalue)
	AudioServerMgr.set_record_peaks_clarity(clvalue)
	var clvalue_text := "%.2f" % clvalue
	clarity_threshold_value.text = clvalue_text
	tgn.clarity_threshold = 0.01


func _on_volume_thr_slider_value_changed(value):
	var vvalue: float = value
	var vvalue_text := "%.2f" % vvalue
	volume_threshold_value.text = vvalue_text
	tgn.clarity_threshold = vvalue


func refresh_test_audio_option() -> void:
	var ti_opt: String = t_instrument_option_button.text
	var ta_opt: String = t_audio_option_button.text
	if not AudioStreams.test_options.has(ti_opt):
		return
	var istreams = AudioStreams.test_options[ti_opt]
	if not istreams.has(ta_opt):
		return
	audio_stream_player.stream = istreams[ta_opt]
	audio_stream_player.stream_paused = false
	audio_stream_player.play(0)


func _on_enable_test_audio_toggled(button_pressed):
	if button_pressed:
		AudioServerMgr.mute_analyze(false)
		refresh_test_audio_option()
	else:
		AudioServerMgr.mute_analyze(true)
		audio_stream_player.stream = microphone_stream
		audio_stream_player.play()
		audio_stream_player.stream_paused = false


func _on_t_instrument_option_button_item_selected(index):
	var ti_opt: String = t_instrument_option_button.text
	t_audio_option_button.clear()
	if AudioStreams.test_options.has(ti_opt):
		var aopts = AudioStreams.test_options[ti_opt].keys()
		for opt in aopts:
			t_audio_option_button.add_item(opt)
		t_audio_option_button.select(0)
		if enable_test_audio.button_pressed:
			_on_t_audio_option_button_item_selected(0)


func _on_t_audio_option_button_item_selected(index):
	if enable_test_audio.button_pressed:
		refresh_test_audio_option()
