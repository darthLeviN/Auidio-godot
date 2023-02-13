@tool
extends PanelContainer

@export var upper_frequency: float = 8000.0
@export var lower_frequency: float = 20.0
@export var tick0_step: float = 5000

@export var fr_tick_width: float = 1.0
@export var fr_tick_color: Color = Color(0.5,0.5,0.5, 0.5)

@export var note_tick_width: float = 2.0
@export var note_tick_color: Color = Color(0.5,0.5,0.5, 1.0)

@export var show_notes: bool = true
@export var show_octaves: bool = true

const mn_lower_bound := 15.89
const mn_C := 16.351
const mn_Db :=17.324
const mn_D := 18.354
const mn_Eb := 19.445
const mn_E := 20.601
const mn_F := 21.827
const mn_Gb := 23.124
const mn_G := 24.499
const mn_Ab := 25.956
const mn_A := 27.5
const mn_Bb := 29.135
const mn_B := 30.868
const mn_uppwer_bound := 31.785

var mn_notes := {
	"C": mn_C,
	"Db": mn_Db,
	"D": mn_D,
	"Eb": mn_Eb,
	"E": mn_E,
	"F": mn_F,
	"Gb": mn_Gb,
	"G": mn_G,
	"Ab": mn_Ab,
	"A": mn_A,
	"Bb": mn_Bb,
	"B": mn_B,
}


func _draw():
	
	if(show_octaves):
		var sratio = size.y/(upper_frequency - lower_frequency)
		var vtpos = mn_lower_bound*2.0
		var octave_index = 1
		var logfactor = size.y/log(upper_frequency/lower_frequency)
		
		while(vtpos < upper_frequency):
			var rvtpos = size.y - logfactor*log(vtpos/lower_frequency)
			var p1 = Vector2(0, rvtpos)
			var p2 = Vector2(size.x, rvtpos)
			draw_line(p1, p2, fr_tick_color, fr_tick_width, true)
			
			octave_index += 1
			vtpos *= 2.0
	
	if(show_notes):
		var sratio = size.y/(mn_uppwer_bound - mn_lower_bound)
		for n in mn_notes:
			var np: float = mn_notes[n]
			var rvtpos = size.y - (np - mn_lower_bound)*sratio
			var p1 = Vector2(0, rvtpos)
			var p2 = Vector2(size.x, rvtpos)
			draw_line(p1, p2, note_tick_color, note_tick_width, true)
