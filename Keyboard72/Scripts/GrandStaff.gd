extends Control
class_name GrandStaff

onready var notes: Node2D = get_node("Notes")
onready var ledgers: Node2D = get_node("Ledgers")
onready var debug_draw: Node2D = get_node("GrandStaffDebugDraw")

const CLEF_MARGIN: float = 172.0 #169.0
const UPPER_NOTE_2ND_SPACING: float = 26.0 # In a major or minor 2nd (i.e. a cluster),
# the upper note of the chord is 26 pixels right of the lower note.
const A4_STAFF_NUMBER: int = 33 # The staff_number of A above treble clef (first ledger line).
const E1_STAFF_NUMBER: int = 9 # The staff_number of E below bass clef (first ledger line).
const EXTRA_ACCIDENTAL_OFFSET_ON_LEDGER_LINES: float = -6.0
const DEFAULT_ACCIDENTAL_OFFSET: Vector2 = Vector2(-25, -54)
const SECONDARY_ACCIDENTAL_OFFSET: Vector2 = Vector2(-25 - UPPER_NOTE_2ND_SPACING, -54)

const SPACE_WIDTH: float = 21.0 # 21 pixels to next ledger line.
const STEP_WIDTH: float = SPACE_WIDTH * 0.5 # 10.5
const NOTEHEAD_WIDTH: float = 30.0

const C4_Y_POS: float = 343.0 # Third space of the treble clef
const C0_Y_POS: float = 707.0 # Lowest C on piano. C0.
const MIDDLE_C_Y_POS: float = 416.5 # First ledger line below treble clef.
const B3_Y_POS: float = 353.5 # Third line of the treble clef
const E2_Y_POS: float = 539.0 # Third space of the bass clef
const D2_Y_POS: float = 549.5 # Third line of the bass clef
const LEDGER_X_OFFSET: float = -6.0 # Ledger line sprite is 32pix left of note.
const DOUBLE_LEDGER_X_OFFSET: float = -16.0 # Ledger line when a 2nd is present is 16pix left of note.
const WHITE_KEYS: Array = ["C", "D", "E", "F", "G", "A", "B"]
# All these integers are used over and over again, so we might as well make them consts.
const THREE_INT: int = 3
const SIX_INT: int = 6
const SEVEN_INT: int = 7
const EIGHT_INT: int = 8
const TWELVE_INT: int = 12
const EIGHTEEN_INT: int = 18
const TWENTY_FOUR_INT: int = 24
const ZERO_POINT_FIVE: float = 0.5
var note_group_spacing: float = 80.0 # Default separation between each note group.

var prefer_sharps: bool = false setget set_prefer_sharps

# All these arrays should be the same size.
var active_pitches: Array
var min_spacing_for_accidentals: float = 4.0
var scenes: Dictionary

var note_groups: Dictionary 
# Keys are note_group_indices, values are NoteGroup objects.
# First twelve are treble clef, back twelve are bass clef.

# Rank  : -3 -3 -2 -2 -1 -1 +0 +0 +1 +1 +2 +2
# NG_Idx:  0  1  2  3  4  5  6  7  8  9 10 11 # Treble clef
# NG_Idx: 12 13 14 15 16 17 18 19 20 21 22 23 # Bass clef.


var accidental_queue_tl: Vector2 = Vector2(-500, -500)
var accidental_queue_spacing: float = 100.0
var offsets_from_accidentals: Dictionary
var ng_resulting_x_positions: Dictionary # Only used for debug draw.
const LEDGER_LINE_DEFAULT_X_OFFSET: float = -32.0
const WIDE_LEDGER_LINE_DEFAULT_X_OFFSET: float = -16.0

signal placed_notes(ng_idx)

# The x_position of a NoteGroup works differently depending on if the note stem is up or down.
# This is relevant for the notehead position as well as get_pos_of_accidental() func.
# x is NoteGroup.x_position. s is UPPER_NOTE_2ND_SPACING.
# This is important even though we're not showing any stems.

#  STEM DOWN                          STEM UP
#  x - s    x        x + s            x - s    x        x + s
#  |        |        |                |        |        |
#  V        V        V                V        V        V
#            #######                           
#           #########                                   #
#   ####### ########                                    #
#  ##########                                           #
#   ####### #                                           #
#           #                                           #
#           #                                           #
#           #                                           #
#           #                                           #        
#           #                                           # #######
#           #                                           ##########
#           #                                   ####### # #######
#           #                                  ##########      
#                                               #######  



func reset_ledger_line_x_positions() -> void:
	for i in range(TWELVE_INT):
		var ledger: Position2D = ledgers.get_node("Ledger"+str(i))
		ledger.position.x = note_groups[i].x_position
		
func reset_offsets_from_accidentals() -> void:
	for i in range(TWELVE_INT):
		offsets_from_accidentals[i] = 0.0

func reset_note_group_x_positions() -> void:
	for i in range(TWENTY_FOUR_INT):
		var note_group: NoteGroup = note_groups[i]
		note_group.x_position = note_group.DEFAULT_X_POSITION + float(i % TWELVE_INT) * note_group_spacing



func reset_ng_resulting_x_positions() -> void:
	for i in range(TWELVE_INT):
		ng_resulting_x_positions[i] = note_groups[i].x_position

func update_staff() -> void:
	var idx: int
	var x: float
	var draw_idx: int
	var opp_idx: int
	reset_note_group_x_positions()
	reset_ng_resulting_x_positions()
	reset_ledger_line_x_positions()
	reset_offsets_from_accidentals()
#	print("\nJust reset everything. note_group x positions: ")
#	for i in range(TWENTY_FOUR_INT):
#		print("    ", i, ": x_position: ", note_groups[i].x_position, ", offset: ", offsets_from_accidentals[i % TWELVE_INT])
	for ng_idx in note_groups:
		if ng_idx == TWELVE_INT: # Bass clef starts at ng 12.
			draw_idx = 0
		opp_idx = posmod(ng_idx + TWELVE_INT, TWENTY_FOUR_INT)
		if note_groups[ng_idx].pitches.empty() && note_groups[opp_idx].pitches.empty():
			continue
		for pitch in note_groups[ng_idx].pitches:
			idx = pitch.active_pitches_idx
			# NOTEHEAD
			var notehead: Sprite = notes.get_node("Notehead_"+str(idx))
			# X
			x = note_groups[draw_idx].x_position
#			x = note_groups[draw_idx].DEFAULT_X_POSITION
			if note_groups[ng_idx].is_stem_down:
				if pitch.is_right_of_stem: # Primary
					notehead.position.x = x
				else: # Secondary
					notehead.position.x = x - UPPER_NOTE_2ND_SPACING
			else: # Stem up.
				if pitch.is_right_of_stem: # Secondary
					notehead.position.x = x + UPPER_NOTE_2ND_SPACING
				else: # Primary
					notehead.position.x = x
			# Y
			notehead.position.y = pitch.staff_y_pos
			notehead.visible = true
			# ACCIDENTAL
			var acc_sprite: Sprite = notes.get_node("Accidental_" + str(idx))
			acc_sprite.visible = true
			acc_sprite.position = get_pos_of_accidental(pitch, notehead.position, x)
		
		var diff: float = move_clashing_accidentals(ng_idx, draw_idx)
		var s_idx: int = posmod(ng_idx, TWELVE_INT)
		if diff > offsets_from_accidentals[s_idx]:
			offsets_from_accidentals[s_idx] = diff
		draw_idx += 1
	
#	print("\nMidway thru update_staff(). note_group x positions: ")
#	for i in range(TWENTY_FOUR_INT):
#		print("    ", i, ": x_position: ", note_groups[i].x_position,\
#			", offset: ", offsets_from_accidentals[i % TWELVE_INT])
	update_ledger_lines_v3()

#	var sum: float = 0.0
	draw_idx = 0

	var last_t_idx_with_pitches: int = -1
	for t_idx in range(TWELVE_INT):
		var t: NoteGroup = note_groups[t_idx]
		var b: NoteGroup = note_groups[t_idx + TWELVE_INT]
		if t.pitches.empty() && b.pitches.empty():
			continue
		
		var diff: float = offsets_from_accidentals[t_idx]
		var amount: float = 0.0
		var our_x: float = get_x_pos_of_tip_of_furthest_left_notehead(t_idx)
#		print("our_x: ", our_x, ", diff: ", diff, ", our_x - diff: ", our_x - diff)
		if draw_idx >= 1: # There are notes left of us.
			var left_x: float = get_x_pos_of_tip_of_furthest_right_notehead(last_t_idx_with_pitches)
#			print("left_x + min_spacing_for_accidentals: ", left_x + min_spacing_for_accidentals)
			if our_x - diff <= left_x + min_spacing_for_accidentals:
				amount = (left_x + min_spacing_for_accidentals) - (our_x - diff)
		else:
			
#			print("CLEF_MARGIN + min_spacing_for_accidentals: ", CLEF_MARGIN + min_spacing_for_accidentals)
			if our_x - diff <= CLEF_MARGIN + min_spacing_for_accidentals:
				amount = (CLEF_MARGIN + min_spacing_for_accidentals) - (our_x - diff)
#		print("amount: ", amount)
		if amount != 0.0:
			for pitch in t.pitches:
				idx = pitch.active_pitches_idx
				var notehead: Sprite = notes.get_node("Notehead_"+str(idx))
				var acc: Sprite = notes.get_node("Accidental_" + str(idx))
				notehead.position.x += amount
				acc.position.x += amount
			for pitch in b.pitches:
				idx = pitch.active_pitches_idx
				var notehead: Sprite = notes.get_node("Notehead_"+str(idx))
				var acc: Sprite = notes.get_node("Accidental_" + str(idx))
				notehead.position.x += amount
				acc.position.x += amount
			var ledger: Position2D = ledgers.get_node("Ledger"+str(t_idx))
			ledger.position.x += amount
			ng_resulting_x_positions[draw_idx] += amount
		last_t_idx_with_pitches = t_idx
		draw_idx += 1


	for i in range(active_pitches.size(), 32): # TODO: 32 should be max_num_of_pitches in MainScene.gd
		var notehead: Sprite = notes.get_node("Notehead_"+str(i))
		var accidental: Sprite = notes.get_node("Accidental_"+str(i))
		notehead.visible = false
		hide_accidental(accidental)
	debug_draw.update()
	
static func sort_accs_by_pos_priority(_a: Sprite, _b: Sprite) -> bool:
	return _a.pos_priority <= _b.pos_priority

static func areas_overlap(_a: Array, _b: Array) -> bool:
	# Both arrays should have exactly 2 elements.
	# 0 is topleft corner of rect, 1 is bottomright corner of rect.
	# Note: This will return false if the rects are "kissing" (i.e. they share an edge or vertice.)
	if _a[1].x < _b[0].x || _b[1].x < _a[0].x || _a[1].y < _b[0].y || _b[1].y < _a[0].y:
		return false
	return true
	
func get_x_pos_of_tip_of_furthest_right_notehead(_t_idx: int) -> float:
	var t: NoteGroup = note_groups[_t_idx]
	var b: NoteGroup = note_groups[_t_idx + TWELVE_INT]
	var idx: int
	var furthest_right_x: float
	var furthest_right_idx: int = -1
	for pitch in t.pitches:
		idx = pitch.active_pitches_idx
		var notehead: Sprite = notes.get_node("Notehead_"+str(idx))
		if furthest_right_idx == -1:
			furthest_right_idx = idx
			furthest_right_x = notehead.position.x
		else:
			if notehead.position.x > furthest_right_x:
				furthest_right_idx = idx
				furthest_right_x = notehead.position.x
	for pitch in b.pitches:
		idx = pitch.active_pitches_idx
		var notehead: Sprite = notes.get_node("Notehead_"+str(idx))
		if furthest_right_idx == -1:
			furthest_right_idx = idx
			furthest_right_x = notehead.position.x
		else:
			if notehead.position.x > furthest_right_x:
				furthest_right_idx = idx
				furthest_right_x = notehead.position.x
	return notes.get_node("Notehead_"+str(furthest_right_idx)).position.x + NOTEHEAD_WIDTH

func get_x_pos_of_tip_of_furthest_left_notehead(_t_idx: int) -> float:
	var t: NoteGroup = note_groups[_t_idx]
	var b: NoteGroup = note_groups[_t_idx + TWELVE_INT]
	var idx: int
	var furthest_left_x: float
	var furthest_left_idx: int = -1
	for pitch in t.pitches:
		idx = pitch.active_pitches_idx
		var notehead: Sprite = notes.get_node("Notehead_"+str(idx))
		if furthest_left_idx == -1:
			furthest_left_idx = idx
			furthest_left_x = notehead.position.x
		else:
			if notehead.position.x < furthest_left_x:
				furthest_left_idx = idx
				furthest_left_x = notehead.position.x
	for pitch in b.pitches:
		idx = pitch.active_pitches_idx
		var notehead: Sprite = notes.get_node("Notehead_"+str(idx))
		if furthest_left_idx == -1:
			furthest_left_idx = idx
			furthest_left_x = notehead.position.x
		else:
			if notehead.position.x < furthest_left_x:
				furthest_left_idx = idx
				furthest_left_x = notehead.position.x
	return furthest_left_x #notes.get_node("Notehead_"+str(furthest_left_idx)).position.x

func move_clashing_accidentals(_ng_idx: int, _draw_idx: int) -> float:

	# Returns the width of the accidentals after shifting them so they're
	# no longer clashing, which will be used to offset the x position of the NoteGroup.
#	print("move_clashing_accidentals(", _ng_idx, ")")
	var accs: Array
	if note_groups[_ng_idx].pitches.empty():
		return 0.0
	else:
		for pitch in note_groups[_ng_idx].pitches:
			accs.append(notes.get_node("Accidental_" + str(pitch.active_pitches_idx)))
	accs.sort_custom(self, "sort_accs_by_pos_priority")
	
	var areas: Array
	for acc in accs:
		areas.append([acc.get_tl(), acc.get_br(), acc.position])
	var furthest_left_pos: float = note_groups[_draw_idx].x_position
	var furthest_right_pos: float = accs[0].get_br().x
	var acc_b_tl_x: float
	if accs.size() == 1:
		furthest_left_pos = areas[0][0].x
	for i in range(accs.size() - 1):
		var acc_a: Sprite = accs[i]
		for j in range(i + 1, accs.size()):
			var acc_b: Sprite = accs[j]
			# We know that acc_a has better pos_priority than acc_b.
			assert(acc_a.pos_priority < acc_b.pos_priority)
			if areas_overlap(areas[i], areas[j]):
				# Need to move B while A stays.
				var old_b_tl_x: float = areas[j][0].x
				var b_width: float = areas[j][1].x - areas[j][0].x
				areas[j][0].x = areas[i][0].x - b_width
				var dist: float = old_b_tl_x - areas[j][0].x
				areas[j][1].x -= dist
				areas[j][2].x -= dist
				if areas[j][0].x < furthest_left_pos:
					furthest_left_pos = areas[j][0].x
					
	for i in range(areas.size()):
		var acc: Sprite = accs[i]
		acc.position.x = areas[i][2].x
	return furthest_right_pos - furthest_left_pos



func update_ledger_lines_v3() -> void:
	var draw_idx: int = 0
	var x: float
	for t_idx in range(12):
		var t: NoteGroup = note_groups[t_idx]
		var b: NoteGroup = note_groups[t_idx + TWELVE_INT]
		var ledger: Position2D = ledgers.get_node("Ledger"+str(t_idx))
		if t.pitches.empty() && b.pitches.empty():
			ledger.set_all_states_to_none()
			continue
		
		if not t.has_ledger_lines_above && not t.has_ledger_lines_below\
			&& not b.has_ledger_lines_below: # No ledger lines in either clef.
			ledger.set_all_states_to_none()
			draw_idx += 1
			continue
		
		var state_arr: Array = [t.has_ledger_lines_above, t.has_ledger_lines_below,\
			b.has_ledger_lines_below, int(t.is_stem_down), int(b.is_stem_down)]
#		print("state_arr: ", state_arr)
		
		# I know this is horrible, but there are so many possible states, and the pattern
		# of when/when not to display certain ledger lines is difficult to see.
		# If a certain chord comes back with an incorrect ledger line display,
		# you can uncomment the print("state_arr: ", state_arr) above,
		# then find that state in this list, and make the adjustment.
		
		# TLDR: It's horrible, but it works, damnit!
		match state_arr:
			[0,0,1,0,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[0,0,1,0,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[0,0,1,1,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[0,0,1,1,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[0,0,2,0,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE
			[0,0,2,0,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE
			[0,0,2,1,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE_OFFSET_RIGHT#ledger.State.WIDE_OFFSET_LEFT
			[0,0,2,1,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE_OFFSET_LEFT
				
				
			[0,1,0,0,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[0,1,0,0,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[0,1,0,1,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[0,1,0,1,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[0,1,1,0,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[0,1,1,0,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[0,1,1,1,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[0,1,1,1,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[0,1,2,0,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			[0,1,2,0,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			[0,1,2,1,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			[0,1,2,1,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			
			[0,2,0,0,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NONE
			[0,2,0,0,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NONE
			[0,2,0,1,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NONE
			[0,2,0,1,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NONE
			[0,2,1,0,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NORMAL
			[0,2,1,0,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NORMAL
			[0,2,1,1,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NORMAL
			[0,2,1,1,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NORMAL
			[0,2,2,0,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.WIDE
			[0,2,2,0,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.WIDE
			[0,2,2,1,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.WIDE
			[0,2,2,1,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.WIDE
				
				
				
				
				
				
			[1,0,0,0,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NONE
			[1,0,0,0,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NONE
			[1,0,0,1,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NONE
			[1,0,0,1,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NONE
			[1,0,1,0,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[1,0,1,0,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[1,0,1,1,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[1,0,1,1,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[1,0,2,0,0]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE
			[1,0,2,0,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE
			[1,0,2,1,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE
			[1,0,2,1,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE
				
				
			[1,1,0,0,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[1,1,0,0,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[1,1,0,1,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[1,1,0,1,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[1,1,1,0,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[1,1,1,0,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[1,1,1,1,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[1,1,1,1,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[1,1,2,0,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			[1,1,2,0,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			[1,1,2,1,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			[1,1,2,1,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			
			[1,2,0,0,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NONE
			[1,2,0,0,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NONE
			[1,2,0,1,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NONE
			[1,2,0,1,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NONE
			[1,2,1,0,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NORMAL
			[1,2,1,0,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NORMAL
			[1,2,1,1,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_1 = ledger.State.NORMAL
			[1,2,1,1,1]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NORMAL
			[1,2,2,0,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.WIDE
			[1,2,2,0,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.WIDE
			[1,2,2,1,0]:
				ledger.state_3 = ledger.State.NORMAL
				ledger.state_2 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_1 = ledger.State.WIDE
			[1,2,2,1,1]:
				ledger.state_3 = ledger.State.NONE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.WIDE
			[2,0,0,0,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NONE
			[2,0,0,0,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NONE
			[2,0,0,1,0]:
				ledger.state_3 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NONE
			[2,0,0,1,1]:
				ledger.state_3 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NONE
			[2,0,1,0,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[2,0,1,0,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[2,0,1,1,0]:
				ledger.state_3 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[2,0,1,1,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.NORMAL
			[2,0,2,0,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE
			[2,0,2,0,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE
			[2,0,2,1,0]:
				ledger.state_3 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE
			[2,0,2,1,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NONE
				ledger.state_1 = ledger.State.WIDE
			[2,1,0,0,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[2,1,0,0,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[2,1,0,1,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[2,1,0,1,1]:
				ledger.state_3 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NONE
			[2,1,1,0,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[2,1,1,0,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[2,1,1,1,0]:
				ledger.state_3 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[2,1,1,1,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.NORMAL
			[2,1,2,0,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			[2,1,2,0,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			[2,1,2,1,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			[2,1,2,1,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.NORMAL
				ledger.state_1 = ledger.State.WIDE
			
			[2,2,0,0,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NONE
			[2,2,0,0,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NONE
			[2,2,0,1,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NONE
			[2,2,0,1,1]:
				ledger.state_3 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_2 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_1 = ledger.State.NONE
			[2,2,1,0,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NORMAL
			[2,2,1,0,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NORMAL
			[2,2,1,1,0]:
				ledger.state_3 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_2 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_1 = ledger.State.NORMAL
			[2,2,1,1,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.NORMAL
			[2,2,2,0,0]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.WIDE
			[2,2,2,0,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.WIDE
			[2,2,2,1,0]:
				ledger.state_3 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_2 = ledger.State.WIDE_OFFSET_LEFT
				ledger.state_1 = ledger.State.WIDE
			[2,2,2,1,1]:
				ledger.state_3 = ledger.State.WIDE
				ledger.state_2 = ledger.State.WIDE
				ledger.state_1 = ledger.State.WIDE

		x = note_groups[draw_idx].x_position# + note_group_x_offsets[t_idx + TWELVE_INT]
		ledger.position.x = x
		
		# Now figure out number of ledger lines to show.
		if not b.pitches.empty():
			if b.pitches[0].staff_number <= E1_STAFF_NUMBER: # has at least 1 ledger line below bass clef.
				var sn_diff: int = E1_STAFF_NUMBER - b.pitches[0].staff_number
				ledger.lines_visible_1 = int(floor(float(sn_diff) * 0.5)) + 1
		if not t.pitches.empty():
			if t.pitches.back().staff_number >= A4_STAFF_NUMBER: # has at least 1 ledger line above treble clef.
				var sn_diff: int = t.pitches.back().staff_number - A4_STAFF_NUMBER
				ledger.lines_visible_3 = int(floor(float(sn_diff) * 0.5)) + 1
				
		draw_idx += 1
		
		
		


func get_pos_of_accidental(_pitch: Pitch, _notehead_pos: Vector2, _stem_x_pos: float) -> Vector2:
	# Note: This does not account for x offset due to accidentals.
#	print("get_pos_of_accidental(), _pitch: ", _pitch.title, ", _notehead_pos: ", _notehead_pos, ", _stem_x_pos: ", _stem_x_pos)
	var p: Vector2 = _notehead_pos
	var note_group: NoteGroup = note_groups[_pitch.note_group_idx]
	if not _pitch.is_right_of_stem && not note_group.is_stem_down:
		p += DEFAULT_ACCIDENTAL_OFFSET
	elif not _pitch.is_right_of_stem && note_group.is_stem_down:
		assert(_pitch.is_part_of_cluster)
		p += DEFAULT_ACCIDENTAL_OFFSET
	elif _pitch.is_right_of_stem && not note_group.is_stem_down:
		assert(_pitch.is_part_of_cluster)
		p += SECONDARY_ACCIDENTAL_OFFSET
	elif _pitch.is_right_of_stem && note_group.is_stem_down:
		if _pitch.is_part_of_cluster:
			p += SECONDARY_ACCIDENTAL_OFFSET
		elif note_group.has_any_clusters:
			p += SECONDARY_ACCIDENTAL_OFFSET
		else:
			p += DEFAULT_ACCIDENTAL_OFFSET
	if note_group.has_ledger_lines_above: 
		# Must be treble clef, because we stopped bass clef at B2.
		if _pitch.staff_number >= note_group.TCLEF_LEDGER_LINE_ABOVE_PSN - 1:
			p.x += LEDGER_X_OFFSET
	if note_group.has_ledger_lines_below:
		if not note_group.is_bass_clef: # treble clef
			if _pitch.staff_number <= note_group.TCLEF_LEDGER_LINE_BELOW_PSN + 1:
				p.x += LEDGER_X_OFFSET
		else: # bass clef
			if _pitch.staff_number <= note_group.BCLEF_LEDGER_LINE_BELOW_PSN + 1:
				p.x += LEDGER_X_OFFSET
	return p


func get_y_pos_and_staff_num_of_pitch(_pitch: Pitch) -> Array:
	var y: float
	var white_key: String = _pitch.note_name[0]
	var wk_idx: int = WHITE_KEYS.find(white_key)
	assert(wk_idx != -1)
	var pitch_staff_num: int = (_pitch.octave * SEVEN_INT) + wk_idx
	if _pitch.octave >= THREE_INT: # In treble clef.
		var octs_above_mid_c: int = _pitch.octave - THREE_INT
		var steps: int = (octs_above_mid_c * SEVEN_INT) + wk_idx
		y = MIDDLE_C_Y_POS - (float(steps) * STEP_WIDTH)
	else: # In bass clef.
		var steps: int = (_pitch.octave * SEVEN_INT) + wk_idx
		y = C0_Y_POS - (float(steps) * STEP_WIDTH)
	return [y, pitch_staff_num]



func get_accidental_str(_pitch: Pitch) -> String:
	var note_group: NoteGroup = note_groups[_pitch.note_group_idx]
	var acc_str: String
	if _pitch.is_black_key:
		if _pitch.enharmonic == _pitch.Enharm.FLAT:
			acc_str = "flat"
		else:
			acc_str = "sharp"
	else: # This is a white key.
		acc_str = "natural"
	var rank: int = posmod(_pitch.sevtwo_pitch_class, SIX_INT)
	if rank >= THREE_INT:
		rank -= SIX_INT
	match rank:
		-3: acc_str = acc_str + "_down_3"
		-2: acc_str = acc_str + "_down_2"
		-1: acc_str = acc_str + "_down_1"
		1: acc_str = acc_str + "_up_1"
		2: acc_str = acc_str + "_up_2"
		3: acc_str = acc_str + "_up_3" # Should never see up_3, but putting it here anyway.
	return acc_str
	
func set_prefer_sharps(_prefer_sharps: bool) -> void:
	prefer_sharps = _prefer_sharps
	assess_pitches()
	update_staff()
	
	
func assess_pitches() -> void:
	for ng_idx in note_groups:
		note_groups[ng_idx].clear()

	for idx in range(active_pitches.size()):
		var pitch: Pitch = active_pitches[idx]
		pitch.active_pitches_idx = idx
		if not prefer_sharps:
			pitch.enharmonic = pitch.Enharm.FLAT
		else:
			pitch.enharmonic = pitch.Enharm.SHARP
		var y_arr: Array = get_y_pos_and_staff_num_of_pitch(pitch)
		pitch.staff_y_pos = y_arr[0]
		pitch.staff_number = y_arr[1]
		#print("pitch ", pitch.title)
		var start_ng_idx: int
		var ng_idx: int
		if pitch.octave >= THREE_INT: # treble clef
			start_ng_idx = SIX_INT # Rank 0 of tclef
		else:
			start_ng_idx = EIGHTEEN_INT # Rank 0 of bclef
		var rank: int = pitch.sevtwo_pitch_class % SIX_INT
		if rank >= THREE_INT:
			rank -= SIX_INT
		ng_idx = rank * 2
		#print("adding pitch: ", pitch.title, ", start ng_idx: ", ng_idx)
		var accepted: bool = note_groups[start_ng_idx + ng_idx].add_pitch(pitch)
		var attempts: int = 0
		while not accepted:
			attempts += 1
			if attempts >= TWELVE_INT:
				break
			ng_idx += 1
			accepted = note_groups[start_ng_idx + ng_idx].add_pitch(pitch)
		pitch.note_group_idx = start_ng_idx + ng_idx
	for idx in range(active_pitches.size()):
		var pitch: Pitch = active_pitches[idx]
		pitch.accidental_str = get_accidental_str(pitch)
		var acc_sprite: Sprite = notes.get_node("Accidental_"+str(idx))
		hide_accidental(acc_sprite) # We'll make it visible later in update_staff().
		acc_sprite.accidental = pitch.accidental_str
#	print("end of assess_pitches")

	
static func sort_active_pitches(_a: Pitch, _b: Pitch) -> bool:
	return _a.freq <= _b.freq

func _on_MainScene_pitch_activated(_pitch: Pitch) -> void:
#	print("\nactivate ", _pitch.title)
	active_pitches.append(_pitch)
	active_pitches.sort_custom(self, "sort_active_pitches")
	assess_pitches()
	update_staff()
	
	
func _on_MainScene_pitch_deactivated(_pitch: Pitch) -> void:
#	print("\ndeactivate ", _pitch.title)
	var idx: int = active_pitches.find(_pitch)
	
	note_groups[_pitch.note_group_idx].remove_pitch(_pitch)
	active_pitches.remove(idx)
	assess_pitches()
	update_staff()
	
func _on_MainScene_keyboard_cleared() -> void:
	for ng_idx in note_groups:
		note_groups[ng_idx].clear()
		#note_group_x_offsets[ng_idx] = 0.0
	active_pitches.clear()
	update_staff()
	
func make_sprite(_thing: String) -> Sprite:
	var thing: Sprite = scenes[_thing].instance().duplicate()
	return thing
	
func hide_accidental(_accidental: Sprite) -> void:
	_accidental.position = Vector2(accidental_queue_tl.x + (_accidental.index * accidental_queue_spacing),\
		accidental_queue_tl.y)
	_accidental.visible = false
	
func initialize_scenes() -> void:
	var arr: Array = ["notehead", "accidental"]
	for s in arr:
		var capped: String = s.capitalize().replace(" ", "")
		var scene: PackedScene = load("res://Scenes/" + capped + ".tscn")
		scenes[s] = scene
		for i in range(32): # TODO: max_num_of_pitches in MainScene.gd
			var instance: Sprite = scenes[s].instance().duplicate()
			instance.name = instance.name + "_" + str(i)
			instance.visible = false
			notes.add_child(instance)
			if s == "accidental":
				instance.index = i
				instance.connect("area_clash", self, "_on_Accidental_area_clash")
				instance.connect("area_exit", self, "_on_Accidental_area_exit")
				hide_accidental(instance)
				
	# Ledger lines
	var ledger_scene: PackedScene = load("res://Scenes/Ledger.tscn")
	for i in range(TWELVE_INT):
		var ledger: Position2D = ledger_scene.instance().duplicate()
		ledger.name = "Ledger"+str(i)
		ledger.index = i
		ledgers.add_child(ledger)


func initialize_note_groups() -> void:
	for i in range(TWENTY_FOUR_INT):
		var note_group: NoteGroup = NoteGroup.new()
		note_groups[i] = note_group
		note_groups[i].grand_staff = self
		note_group.x_position = note_group.DEFAULT_X_POSITION + float(i % TWELVE_INT) * note_group_spacing
		#note_group_x_offsets[i] = 0.0
		if i >= 12:
			note_groups[i].is_bass_clef = true


func _ready():
	initialize_scenes()
	initialize_note_groups()
	debug_draw.parent = self
	debug_draw.update_ng_label_texts()

	



