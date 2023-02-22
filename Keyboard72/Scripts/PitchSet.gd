extends Resource

class_name PitchSet

const SEVENTY_TWO_INT: int = 72
const MAX_NUMBER_OF_PITCHES: int = 32

var file_name: String
var pitch_set_name: String
var pitches: Array # Array of different Pitch objects.
var intervals: Array # Array of Interval objects
var note_numbers: Array
var last_note_numbers: Array
var pc_set: Array
var normal_form: Array
var prime_form: Array
var interval_vector: Array
var is_inversion_of_prime_form: bool = false
var is_inversionally_symmetrical: bool = false
var transposition_index_string: String = "T0"
# The number of Intervals with n Pitches is n(n-1) / 2
# If we put a cap on the number of simultaneous pitches to say, 32, 
# that would be 496 total Intervals. Let's see how she handles it.
var main_scene: Node2D


signal pitch_set_changed(_pitch_set)


static func sort_pitches(_a: Pitch, _b: Pitch) -> bool:
	return _a.freq <= _b.freq
	
static func sort_intervals(_a: Interval, _b: Interval) -> bool:
	if _a.pitch_a.freq < _b.pitch_a.freq:
		return true
	if _a.pitch_a.freq > _b.pitch_a.freq:
		return false
	# Got here? Same pitch_a.
	return _a.sevtwo <= _b.sevtwo # smaller intervals first.

static func sort_sets_of_smallest_range(_a: Array, _b: Array) -> bool:
	assert(_a.size() == _b.size())
	var ivls_a: Array
	var ivls_b: Array
	for i in range(_a.size() - 1):
		ivls_a.append(_a[i + 1] - _a[i])
		ivls_b.append(_b[i + 1] - _b[i])
	var comp_idx: int = _a.size() - 2
	while comp_idx >= 1:
		var ivl_a: int = _a[comp_idx] - _a[0]
		var ivl_b: int = _b[comp_idx] - _b[0]
		if ivl_a < ivl_b:
			return true
		elif ivl_b < ivl_a:
			return false
		comp_idx -= 1
	# Got here? The sets are inversionally symmetrical.
	return _a[0] <= _b[0]

func update_pc_set() -> void:
	pc_set.clear()
	for p in pitches:
		if not pc_set.has(p.sevtwo_pitch_class):
			pc_set.append(p.sevtwo_pitch_class)
	pc_set.sort()
	is_inversionally_symmetrical = false
	if pc_set.size() <= 1:
		is_inversionally_symmetrical = true
		is_inversion_of_prime_form = false
		normal_form = pc_set.duplicate()
		if pc_set.size() == 1:
			transposition_index_string = "T"+str(normal_form[0])
		else:
			transposition_index_string = "T0"
		prime_form = [0]
		return
		
	# Now update normal_form
	normal_form = pc_set.duplicate()
	var smallest_rnge: int
	var sets_at_smallest_rnge: Array
	for i in range(pc_set.size()):
		var rnge: int = normal_form.back() - normal_form[0]
		if i == 0:
			smallest_rnge = rnge
			sets_at_smallest_rnge.append(normal_form.duplicate())
		else:
			if rnge == smallest_rnge:
				sets_at_smallest_rnge.append(normal_form.duplicate())
			elif rnge < smallest_rnge:
				smallest_rnge = rnge
				sets_at_smallest_rnge.clear()
				sets_at_smallest_rnge.append(normal_form.duplicate())
		# Rotate the set.
		var front: int = normal_form[0]
		normal_form.pop_front()
		normal_form.push_back(front + SEVENTY_TWO_INT)
	if pc_set.empty():
		prime_form.clear()
		is_inversion_of_prime_form = false
		return
	sets_at_smallest_rnge.sort_custom(self, "sort_sets_of_smallest_range")
	normal_form = sets_at_smallest_rnge[0].duplicate()
	for i in range(normal_form.size()):
		while normal_form[i] >= SEVENTY_TWO_INT:
			normal_form[i] = normal_form[i] - SEVENTY_TWO_INT
	# Now update prime_form
	prime_form.clear()
	var prime_set_a: Array = normal_form.duplicate()
	# Transpose prime_set_a so that the first note is pc 0.
	var diff: int = prime_set_a[0]
	for i in range(prime_set_a.size()):
		prime_set_a[i] = posmod(prime_set_a[i] - diff, SEVENTY_TWO_INT)
	# Now make prime_set_b prime_set_a at TI0.
	var prime_set_b: Array
	var zero: int = 0
	for i in range(prime_set_a.size()):
		prime_set_b.append(posmod(zero - prime_set_a[i], SEVENTY_TWO_INT))
	prime_set_b.invert()
	# Now transpose prime_set_b so that the first note is pc_0.
	diff = prime_set_b[0]
	for i in range(prime_set_b.size()): # prime_set_b is an inversion of prime_set_a.
		prime_set_b[i] = posmod(prime_set_b[i] - diff, SEVENTY_TWO_INT)
	# Now compare the intervals of prime_set_a and prime_set_b.
	var got_prime_form: bool = false
	if prime_set_a.size() <= 2:
		prime_form = prime_set_a.duplicate()
		is_inversion_of_prime_form = false
		got_prime_form = true
	if not got_prime_form:
		var comp_idx: int = prime_set_a.size() - 2
		
		while comp_idx >= 1:
			var ivl_a: int = prime_set_a[comp_idx] - prime_set_a[0]
			var ivl_b: int = prime_set_b[comp_idx] - prime_set_b[0]
			if ivl_a < ivl_b:
				prime_form = prime_set_a.duplicate()
				is_inversion_of_prime_form = false
				got_prime_form = true
				break
			elif ivl_b < ivl_a:
				prime_form = prime_set_b.duplicate()
				is_inversion_of_prime_form = true
				got_prime_form = true
				break
			comp_idx -= 1
	if got_prime_form:
		# Now update transposition_index_string
		var n: int
		if not is_inversion_of_prime_form:
			n = normal_form[0] - prime_form[0]
			transposition_index_string = "T"+str(n)
		else: # is inversion
			#n = posmod(normal_form.back() + prime_form[0], SEVENTY_TWO_INT) 
			# Commented above line out because prime_form[0] is always 0. Replaced with below line.
			n = normal_form.back()
			transposition_index_string = "T"+str(n)+"I"
		return
	# Got here? The sets are inversionally symmetrical.
	prime_form = prime_set_a.duplicate()
	is_inversionally_symmetrical = true
	is_inversion_of_prime_form = false
	transposition_index_string = "T"+str(normal_form[0])#"T"+str(normal_form[0] - prime_form[0])
	#interval_vector = get_interval_vector(prime_form)
	return

func set_normal_form(_arr: Array) -> void:
	# We don't allow this variable to be set outside the class.
	return
	
func set_prime_form(_arr: Array) -> void:
	# We don't allow this variable to be set outside the class.
	return
	
#func set_pc_set(_arr: Array) -> void:
#	# TODO: THIS
#	return

func get_interval_idx(_pitch_a: Pitch, _pitch_b: Pitch) -> int:
	if _pitch_a.sevtwo_note_num == _pitch_b.sevtwo_note_num:
		return -1 # No unison intervals will be listed.
	var note_idx_of_lower_note: int
	var note_idx_of_higher_note: int
	if _pitch_a.sevtwo_note_num < _pitch_b.sevtwo_note_num: # A is lower
		note_idx_of_lower_note = note_numbers.find(_pitch_a.sevtwo_note_num)
		note_idx_of_higher_note = note_numbers.find(_pitch_b.sevtwo_note_num)
	else: # B is lower
		note_idx_of_lower_note = note_numbers.find(_pitch_b.sevtwo_note_num)
		note_idx_of_higher_note = note_numbers.find(_pitch_a.sevtwo_note_num)
	if note_idx_of_lower_note == -1 || note_idx_of_higher_note == -1:
		return -1
	var num_of_notes: int = pitches.size()
	var num_of_intervals: int = intervals.size() #Also could've been calculated by ((pitches.size() - 1) * pitches.size()) / 2, but we can just use intervals.size()
	var r: int = num_of_notes - (note_idx_of_lower_note + 1)
	var t: int = (r * (r + 1)) / 2
	var ivl_idx_of_lower_note: int = num_of_intervals - t
	return ivl_idx_of_lower_note + ((note_idx_of_higher_note - note_idx_of_lower_note) - 1)





func update_pitch_set_data() -> void:
	update_interval_vector()
	update_pc_set()
			




func empty() -> bool:
	return pitches.size() == 0

func has(_pitch: Pitch) -> bool:
	for p in pitches:
		if p.sevtwo_note_num == _pitch.sevtwo_note_num:
			return true
	return false
	
func find_pitch_string(_pitch_string: String, _middle_c_is_c4: bool = false) -> int:
	# Note: does NOT account for enharmonics.
	if not _middle_c_is_c4:
		for i in range(pitches.size()):
			var p: Pitch = pitches[i]
			if p.title == _pitch_string:
				return i
	else:
		for i in range(pitches.size()):
			var p: Pitch = pitches[i]
			if p.get_title_c4() == _pitch_string:
				return i
	return -1
	
func get_pitch_strings() -> Array:
	var arr: Array
	for p in pitches:
		arr.push_back(p.title)
	return arr

func get_note_numbers() -> Array:
	var arr: Array
	for p in pitches:
		arr.push_back(p.sevtwo_note_num)
	return arr
	
func get_midi_numbers() -> Array:
	var arr: Array
	for p in pitches:
		arr.push_back(p.midi_number)
	return arr
	
func add_multiple_pitches(_new_pitches: Array) -> void:
	last_note_numbers = note_numbers.duplicate()
	for new_pitch in _new_pitches:
		pitches.push_back(new_pitch)
		for i in range(pitches.size() - 1):
			var ivl: Interval = Interval.new()
			if pitches[i].sevtwo_note_num < new_pitch.sevtwo_note_num:
				ivl.pitch_a = pitches[i]
				ivl.pitch_b = new_pitch
			else:
				ivl.pitch_a = new_pitch
				ivl.pitch_b = pitches[i]
			intervals.append(ivl)
			ivl.connect("pulse", main_scene, "_on_Interval_pulse", [self])
		note_numbers.push_back(new_pitch.sevtwo_note_num)
	note_numbers.sort()
	pitches.sort_custom(self, "sort_pitches")
	intervals.sort_custom(self, "sort_intervals")
	update_pitch_set_data()
	emit_signal("pitch_set_changed", self)

func add_frequency(_freq: float, _round_to_sevtwo: bool) -> void:
	var pitch: Pitch = Pitch.new()
	pitch.freq = _freq
	if _round_to_sevtwo:
		pitch.sevtwo_note_num = pitch.sevtwo_note_num # The setter will round the freq
		# to the nearest twelfth step.
		

func add_pitch(_pitch: Pitch, _emit_changed_signal: bool = true) -> void:
	last_note_numbers = note_numbers.duplicate()
	pitches.append(_pitch)
	note_numbers.push_back(_pitch.sevtwo_note_num)
	
	for i in range(pitches.size() - 1):
		var ivl: Interval = Interval.new()
		if pitches[i].sevtwo_note_num < _pitch.sevtwo_note_num:
			ivl.pitch_a = pitches[i]
			ivl.pitch_b = _pitch
		else:
			ivl.pitch_a = _pitch
			ivl.pitch_b = pitches[i]
		intervals.append(ivl)
		ivl.connect("pulse", main_scene, "_on_Interval_pulse", [self])
	note_numbers.sort()
	pitches.sort_custom(self, "sort_pitches")
	intervals.sort_custom(self, "sort_intervals")
	update_pitch_set_data()
	if _emit_changed_signal:
		emit_signal("pitch_set_changed", self)
	
func remove_pitch(_pitch: Pitch, _emit_changed_signal: bool = true) -> void:
	last_note_numbers = note_numbers.duplicate()
	# First, need to unpair and remove any Intervals this Pitch was part of.
	var intervals_to_remove: Array
	for i in range(intervals.size()):
		if intervals[i].pitch_a == _pitch\
			|| intervals[i].pitch_b == _pitch:
			intervals_to_remove.append(intervals[i])

	for ivl in intervals_to_remove:
		ivl.disconnect("pulse", main_scene, "_on_Interval_pulse")
		intervals.remove(intervals.find(ivl))
		
	var idx: int = pitches.find(_pitch)
	if idx != -1:
		pitches.remove(idx)
		note_numbers.remove(idx)
	update_pitch_set_data()
	# Shouldn't need to re-sort pitches nor note_numbers nor intervals.
	if _emit_changed_signal:
		emit_signal("pitch_set_changed", self)

func get_dict_for_saving() -> Dictionary:
	var dict: Dictionary = {
		"file_name": file_name,
		"note_numbers": note_numbers,
		"pitch_classes": pc_set,
		"prime_form": prime_form,
		"normal_form": normal_form,
		"transposition_index_string": transposition_index_string
	}
	return dict
	
static func get_pitch_class_distance(_pc_a: int, _pc_b: int, _absolute: bool) -> int:
	var diff: int = posmod(_pc_b - _pc_a, SEVENTY_TWO_INT)
	if diff >= 36:
		if _absolute:
			return int(abs(diff - SEVENTY_TWO_INT))
		else:
			return diff - SEVENTY_TWO_INT
	if _absolute:
		return diff
	return _pc_b - _pc_a

func update_interval_vector() -> void:
	interval_vector.clear()
	for ivl in intervals:
		var n: int = ivl.sevtwo % SEVENTY_TWO_INT
		if n > SEVENTY_TWO_INT / 2:
			interval_vector.append(SEVENTY_TWO_INT - n)
		else:
			interval_vector.append(n)
	interval_vector.sort()

static func get_interval_vector(_prime_form: Array) -> Array:
	var arr: Array
	if _prime_form.size() <= 1:
		return arr
	var pc_a: int
	var pc_b: int
	var dist: int
#	for i in range(1, 36 + 1):
	for j in range(_prime_form.size() - 1):
		pc_a = _prime_form[j]
		for k in range(j + 1, _prime_form.size()):
			pc_b = _prime_form[k]
			dist = get_pitch_class_distance(pc_a, pc_b, true)
			arr.push_back(dist)
	arr.sort()
	return arr

func _init():
	pass

func _ready():
	pass
