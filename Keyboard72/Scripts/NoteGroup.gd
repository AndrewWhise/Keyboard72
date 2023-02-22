extends Resource

class_name NoteGroup
# This class is exclusively for GrandStaff.tscn.

const DEFAULT_X_POSITION: float = 216.0 #232.0 #216.0
const TCLEF_LEDGER_LINE_ABOVE_PSN: int = 33
const TCLEF_LEDGER_LINE_BELOW_PSN: int = 21
const BCLEF_LEDGER_LINE_BELOW_PSN: int = 9

var grand_staff #: GrandStaff # Can't use GrandStaff type without cyclic dependency.

var pitches: Array
var is_bass_clef: bool = false
var has_ledger_lines_above: int = 0 # 0 means no LLs above, 1 means single LLs, 2 means wide LLs.
var has_ledger_lines_below: int = 0
var ledger_lines_above: int = 0 # The number of ledger lines to draw above the staff.
var ledger_lines_below: int = 0 # The number of ledger lines to draw below the staff.
var psns: Array # pitch staff numbers
var is_stem_down: bool = true
var has_any_clusters: bool = false
var x_position: float = DEFAULT_X_POSITION
var accidental_order: Array # indexes of pitch in pitches in which to assess the accidentals' x positions.
# Goes in a zigzag pattern starting from last index, first index, 2nd to last index, 2nd index, etc.

func _init():
	pass

static func sort_pitches(_a: Pitch, _b: Pitch) -> bool:
	if _a.staff_number < _b.staff_number:
		return true
	if _a.staff_number > _b.staff_number:
		return false
	return  _a.freq <= _b.freq



func clear():
	pitches.clear()
	psns.clear()
	has_ledger_lines_above = 0
	has_ledger_lines_below = 0

func make_room_for_pitch(_pitch: Pitch) -> bool:
	# The assess_pitches() func in grand_staff adds the pitches in order from lowest to highest.
	if _pitch.is_black_key:
		if _pitch.enharmonic == _pitch.Enharm.FLAT:
			if not psns.has(_pitch.staff_number - 1):
				# We can fit this pitch if we flip the enharmonic.
				_pitch.enharmonic = _pitch.Enharm.SHARP
				_pitch.staff_number -= 1
				_pitch.staff_y_pos += 10.5
				return true
		else: # SHARP
			if not psns.has(_pitch.staff_number + 1):
				_pitch.enharmonic = _pitch.Enharm.FLAT
				_pitch.staff_number += 1
				_pitch.staff_y_pos -= 10.5
				return true
	else: # This is a white key.
		var g: int = 1
		var sz: int = pitches.size()
		var can_be_done: bool = false
		while true:
			# Because we're adding these pitches from lowest to highest, the conflicting pitch MUST
			# be the most recently added pitch.
			if pitches[sz - g].is_black_key: 
				if pitches[sz - g].enharmonic == _pitch.Enharm.FLAT:
					# Can we respell it as a sharp?
					if not psns.has(pitches[sz - g].staff_number - 1):
						# Yes, we can.
						can_be_done = true
						break
					g += 1
					if g > sz:
						break
				else:
					break
			else:
				break
		if can_be_done:
			for i in range(sz - g, sz):
				var other_pitch: Pitch = pitches[i]
				assert(other_pitch.enharmonic == _pitch.Enharm.FLAT)
				assert(other_pitch.is_black_key)
				var psn_idx: int = psns.find(other_pitch.staff_number)
				other_pitch.enharmonic = _pitch.Enharm.SHARP
				other_pitch.staff_number -= 1
				other_pitch.staff_y_pos += grand_staff.STEP_WIDTH
				psns[psn_idx] = other_pitch.staff_number
			return true
	return false

func add_pitch(_pitch: Pitch) -> bool:
	if psns.has(_pitch.staff_number):
		if not make_room_for_pitch(_pitch):
			return false

	pitches.append(_pitch)
	pitches.sort_custom(self, "sort_pitches")
	assert(not psns.has(_pitch.staff_number))
	psns.append(_pitch.staff_number)
	update_is_stem_down()
	update_note_sides()
	update_ledger_line_status()
	update_accidental_order()
	return true

func remove_pitch(_pitch: Pitch) -> void:
	pitches.remove(pitches.find(_pitch))
	psns.remove(psns.find(_pitch.staff_number))
	update_is_stem_down()
	update_note_sides()
	update_ledger_line_status()
	update_accidental_order()

func update_ledger_line_status() -> void:
	has_ledger_lines_above = false
	has_ledger_lines_below = false
	if not is_bass_clef: # treble clef
		for i in range(pitches.size()):
			var pitch: Pitch = pitches[i]
			if pitch.staff_number >= TCLEF_LEDGER_LINE_ABOVE_PSN:
				has_ledger_lines_above = 1
				if pitch.is_part_of_cluster:
					# There is a 2nd in the ledger lines.
					has_ledger_lines_above = 2
				
			elif pitch.staff_number <= TCLEF_LEDGER_LINE_BELOW_PSN:
				has_ledger_lines_below = 1
				if pitch.is_part_of_cluster:
					# There is a 2nd in the ledger lines.
					has_ledger_lines_below = 2
		# To check how many ledger lines above, we only need to check the last pitch,
		# because pitches is always sorted from lowest to highest staff numbers.
		if not pitches.empty():
			var psn_dist: int = pitches.back().staff_number - TCLEF_LEDGER_LINE_ABOVE_PSN
			ledger_lines_above = max(int(floor(float(psn_dist) / 2.0)) + 1, 0)
			psn_dist = TCLEF_LEDGER_LINE_BELOW_PSN - pitches[0].staff_number
			ledger_lines_below = max(int(floor(float(psn_dist) / 2.0)) + 1, 0)
			
	else: # bass clef
		for i in range(pitches.size()):
			var pitch: Pitch = pitches[i]
			if pitch.staff_number <= BCLEF_LEDGER_LINE_BELOW_PSN:
				has_ledger_lines_below = 1
				if pitch.is_part_of_cluster:
					# There is a 2nd in the ledger lines.
					has_ledger_lines_below = 2
				break
		if not pitches.empty():
			var psn_dist: int = BCLEF_LEDGER_LINE_BELOW_PSN - pitches[0].staff_number
			ledger_lines_below = max(int(floor(float(psn_dist) / 2.0)) + 1, 0)
	
func update_accidental_order() -> void:
	if pitches.size() == 1:
		var idx: int = grand_staff.active_pitches.find(pitches[0])
		var acc: Sprite = grand_staff.notes.get_node("Accidental_"+str(idx))
		acc.pos_priority = 1
		return
	var p_idx: int = pitches.size() - 1
	var g: int = pitches.size() - 1 # The distance to jump for the next idx.
	# This is to zigzag thru pitches.
	var dir: int = -1
	var pos_priority: int = 1
	while g >= 0:
		var pitch: Pitch = pitches[p_idx]
		var idx: int = grand_staff.active_pitches.find(pitch)
		var acc: Sprite = grand_staff.notes.get_node("Accidental_"+str(idx))
		acc.pos_priority = pos_priority
		
		pos_priority += 1
		p_idx += dir * g
		dir = -dir
		g -= 1
	
func update_is_stem_down() -> void:
	var dist: float
	var y: float
	var tug: float = grand_staff.B3_Y_POS
	if not is_bass_clef:
		for pitch in pitches:
			y = pitch.staff_y_pos
			dist = abs(y - grand_staff.B3_Y_POS) + grand_staff.STEP_WIDTH # Add an extra step so that
			# Notes on the center line count for stem down.
			if y <= grand_staff.B3_Y_POS: # Would be stem down.
				tug -= dist
			else: # Would be stem up.
				tug += dist
		is_stem_down = tug <= grand_staff.B3_Y_POS
	else: # Bass clef
		tug = grand_staff.D2_Y_POS
		for pitch in pitches:
			y = pitch.staff_y_pos
			dist = abs(y - grand_staff.D2_Y_POS) + grand_staff.STEP_WIDTH # Add an extra step so that
			# Notes on the center line count for stem down.
			if y <= grand_staff.D2_Y_POS: # would be stem down.
				tug -= dist
			else: # Would be stem up.
				tug += dist
		is_stem_down = tug <= grand_staff.D2_Y_POS


func update_note_sides() -> void:
	if pitches.empty():
		return
	# Updates if each of the notes is on the left or right side of the stem.
	
	# If stem is UP, then the bottom note of any cluster of 2nds is
	# ALWAYS on the left of the stem, and then you alternate sides going up the cluster.
	
	# If stem is DOWN, if the number of notes in the cluster of 2nds is EVEN, the bottom note
	# of the cluster is on the left of the stem. If the number of notes in the cluster is ODD,
	# the bottom note of the cluster is on the right of the stem.
	# Alternate sides going up the cluster.
	has_any_clusters = false
	# pitches should be in order from bottom note to top note.
	var p_idx: int
	var current_cluster_count: int = 1
	var cluster_bottom_p_idx: int = -1
	var psn: int
	while true:
		var pitch: Pitch = pitches[p_idx]
		if p_idx == pitches.size() - 1: # If last pitch in pitches.
			if cluster_bottom_p_idx == -1: # We aren't part of a cluster.
				pitch.is_part_of_cluster = false
				pitch.is_right_of_stem = is_stem_down
			else: # We're the last pitch in a cluster.
				pitch.is_part_of_cluster = true
				has_any_clusters = true
				var side: bool
				if current_cluster_count % 2 == 0 || not is_stem_down:
					# If even number of notes in cluster.
					# Bottom note is left.
					side = false
				else: # Odd number of notes in cluster or stem up
					# Bottom note is right.
					side = true
				for i in range(cluster_bottom_p_idx, p_idx + 1):
					pitches[i].is_right_of_stem = side
					side = !side # Flip side.
			break
				
		else: # NOT last pitch in pitches.
			psn = pitch.staff_number
			var next_psn: int = pitches[p_idx + 1].staff_number
			if next_psn == psn + 1: # Part of a cluster
				pitch.is_part_of_cluster = true
				has_any_clusters = true
				if cluster_bottom_p_idx == -1: # We're the bottom note of a cluster
					cluster_bottom_p_idx = p_idx
				current_cluster_count += 1
			else: # Next note is NOT part of this cluster.
				if cluster_bottom_p_idx == -1: # We aren't part of a cluster.
					pitch.is_part_of_cluster = false
					pitch.is_right_of_stem = is_stem_down
				else: # We're the last pitch in a cluster.
					pitch.is_part_of_cluster = true
					has_any_clusters = true
					var side: bool
					if current_cluster_count % 2 == 0 || not is_stem_down:
						# If even number of notes in cluster.
						# Bottom note is left.
						side = false
					else: # Odd number of notes in cluster or stem up.
						# Bottom note is right.
						side = true
					for i in range(cluster_bottom_p_idx, p_idx + 1):
						pitches[i].is_right_of_stem = side
						side = !side # Flip side.
				# Reset cluster variables.
				cluster_bottom_p_idx = -1
				current_cluster_count = 1
		p_idx += 1
	


func _ready():
	pass
