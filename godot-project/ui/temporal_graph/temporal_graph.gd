extends Control

# buffer for points to draw. have to be sorted by time.
# earlier points come last.
# values of Vector2 will be [time,frequency,value].
# TODO : make this a circular buffer if more performance is needed.
# FIXME : sadly at the time PackedVector3Array has no bsearch_custom function
#   implemented. change this after it's implemented.
var Points: Array = []
# clone of above but pre computed to draw notes.
var notePoints: Array = []

var current_time: float = 0.0 :
	set(value):
		if current_time != value:
			current_time = value
			queue_redraw()
@export var time_length: float = 10.0
@export var fr_line_width: float = 2.0
@export var fr_line_color: Color = Color(0.3,0.3,1.0,0.5)
@export var mn_line_width: float = 4.0
@export var mn_line_color: Color = Color(0.3,0.3,1.0,1.0)
@export var upper_frequency: float = 8000.0
@export_range(20.0,22000) var lower_frequency: float = 20.0
@export_range(1000, 20000) var flush_limit: int = 1000
@export var clarity_threshold: float = 0.05
@export var show_octaves: bool = true
@export var show_notes: bool = true

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


func _init():
	current_time = Time.get_ticks_msec()*1000.0


func _ready():
	pass # Replace with function body.


func pcmp(first : Vector3, second : Vector3) -> bool:
	return first.x < second.x


func add_new_point2(p : Vector2):
	add_new_point3(Vector3(current_time, p.x, p.y))


func get_note_point(frpoint : Vector3) -> Vector3:
	var fr : float = frpoint.y
	if fr < mn_lower_bound:
		return frpoint
	else:
		while(fr > mn_uppwer_bound):
			fr /= 2.0
		return Vector3(frpoint.x, fr, frpoint.z)


func add_new_point3(newp : Vector3):
	if(Points.size() == 0):
		Points.append(newp)
		notePoints.append(get_note_point(newp))
		return
	var lastp : Vector3 = Points[Points.size() - 1]
	if lastp.x <= newp.x:
		Points.append(newp)
		notePoints.append(get_note_point(newp))
	else:
		var iidx := Points.bsearch_custom(newp, pcmp, false)
		Points.insert(iidx, newp)
		notePoints.insert(iidx, get_note_point(newp))


# keeps only one out of range point and flushes the rest.
func _flush_out_of_range():
	var etime := current_time - time_length
	
	if Points.size() == 0:
		return
	if Points[0].x > etime:
		return
	
	# looking for expired points.
	var fidx := Points.bsearch_custom(Vector3(etime,0,0), pcmp, true)
	if Points[fidx].x > etime && fidx > 1:
		Points = Points.slice(fidx - 2, Points.size())
		notePoints = notePoints.slice(fidx - 2, notePoints.size())


func _draw():
	var etime := current_time - time_length
	if Points.size() > flush_limit:
		_flush_out_of_range()
		
	# TODO:
	# remove this after implementing a circular buffer.
	# using lidx will exclude out of range points without the need for frequent flushes.
	# however flushes will be cheap when a circular buffer is implemented.
	var lidx = Points.bsearch_custom(Vector3(etime, 0, 0), pcmp, true)
	
	if show_octaves:
		var mlpoints : PackedVector2Array = []
		mlpoints.resize(Points.size()*2)
		
		var tratio = size.x/time_length
		var logfactor = size.y/log(upper_frequency/lower_frequency)
		
		
		var used : int = 0
		for i in range(Points.size() - 2, lidx - 1, -1):
			var p2 : Vector3 = Points[i+1]
			var p1 : Vector3 = Points[i]
			if(p2.z < clarity_threshold || p1.z < clarity_threshold):
				continue
			mlpoints[used] = size - Vector2(
				tratio*(current_time - p1.x), 
				logfactor*log(p1.y/lower_frequency))
			mlpoints[used + 1] = size - Vector2(
				tratio*(current_time - p2.x), 
				logfactor*log(p2.y/lower_frequency))
			used += 2
		mlpoints.resize(used)
		if(mlpoints.size() >= 2):
			draw_multiline(mlpoints, fr_line_color, fr_line_width)
	
	if show_notes:
		var mlpoints : PackedVector2Array = []
		mlpoints.resize(Points.size()*2)
		var tratio = size.x/time_length
		var fratio = size.y/(mn_uppwer_bound - mn_lower_bound)
		
		var rvec := Vector2(tratio, fratio)
		
		var used : int = 0
		for i in range(notePoints.size() - 2, lidx - 1, -1):
			var p2 : Vector3 = notePoints[i+1]
			var p1 : Vector3 = notePoints[i]
			if(p2.z < clarity_threshold || p1.z < clarity_threshold):
				continue
			mlpoints[used] = size - rvec*Vector2(current_time - p1.x, p1.y - mn_lower_bound)
			mlpoints[used + 1] = size - rvec*Vector2(current_time - p2.x, p2.y - mn_lower_bound)
			used += 2
		mlpoints.resize(used)
		if(mlpoints.size() >= 2):
			draw_multiline(mlpoints, mn_line_color, mn_line_width)
