extends Node2D

var version: String = "0.3.3"

var forcing_control_value: bool = false

onready var canvas_layer: CanvasLayer = get_node("CanvasLayer")
onready var camera: Camera2D = get_node("Camera2D")
onready var mouse_label: Label = get_node("CanvasLayer/TopMenu/PanelContainer/MouseLabel")
onready var audio_stream_players: Node = get_node("AudioStreamPlayers")
onready var tri_glow_tween: Tween = get_node("TriGlowTween")
onready var grand_staff_panel: PanelContainer = get_node("CanvasLayer/GrandStaffPanelContainer")#get_node("CanvasLayer/GrandStaffPanelContainer")
onready var settings_panel: PanelContainer = get_node("CanvasLayer/SettingsPanelContainer")
onready var settings_button: Button = get_node("CanvasLayer/TopMenu/PanelContainer/HBoxContainer/SettingsButton")
onready var notation_button: Button = get_node("CanvasLayer/TopMenu/PanelContainer/HBoxContainer/NotationButton")
onready var transform_button: Button = get_node("CanvasLayer/TopMenu/PanelContainer/HBoxContainer/TransformButton")
onready var chord_analysis_panel: PanelContainer = get_node("CanvasLayer/ChordAnalysisPanelContainer")
onready var chord_analysis_button: Button = get_node("CanvasLayer/TopMenu/PanelContainer/HBoxContainer/AnalysisButton")
onready var help_panel: PanelContainer = get_node("CanvasLayer/HelpPanelContainer")
onready var help_button: Button = get_node("CanvasLayer/TopMenu/PanelContainer/HBoxContainer/HelpButton")

# Note: Some of these variables are called "label" when they're actually
# LineEdit objects. This is because these line edits are never actually editable,
# but we keep them as LineEdits so the user can select and copy the data if they wish.
onready var ca_pitches_text_edit: TextEdit = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/PitchesHBoxContainer/PitchesTextEdit")
onready var ca_note_numbers_text_edit: TextEdit = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/NoteNumbersHBoxContainer/NoteNumbersTextEdit")
onready var ca_frequencies_text_edit: TextEdit = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/FrequenciesHBoxContainer/FrequenciesTextEdit")
#onready var ca_frequencies_label: Label = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/FrequenciesHBoxContainer/FrequenciesLabel")
onready var ca_pitch_classes_label: LineEdit = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/PitchClassesHBoxContainer/PitchClassesLabel")
onready var ca_number_of_pitches_label: Label = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/NumberOfPitchesHBoxContainer/NumberOfPitchesLabel")
onready var ca_number_of_pitch_classes_label: Label = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/NumberOfPitchClassesHBoxContainer/NumberOfPitchClassesLabel")
onready var ca_normal_form_heading: Label = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/NormalFormHBoxContainer/Label")
onready var ca_normal_form_label: LineEdit = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/NormalFormHBoxContainer/NormalFormLabel")
onready var ca_prime_form_label: LineEdit = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/PrimeFormHBoxContainer/PrimeFormLabel")
onready var ca_12th_step_intervals_label: LineEdit = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/TwelfthStepIntervalsHBoxContainer/TwelfthStepIntervalsLabel")
onready var ca_normal_form_12th_step_intervals_label: LineEdit = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/NormalFormTwelfthStepIntervalsHBoxContainer/NormalFormTwelfthStepIntervalsLabel")
onready var ca_interval_vector_label: LineEdit = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IntervalVectorHBoxContainer/IntervalVectorLabel")
onready var ca_ivl_pitch_a_vbox: VBoxContainer = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IvlScrollContainer/IntervalHBoxContainer2/IvlPitchAVBoxContainer")
onready var ca_ivl_pitch_b_vbox: VBoxContainer = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IvlScrollContainer/IntervalHBoxContainer2/IvlPitchBVBoxContainer")
onready var ca_ivl_freq_ratio_vbox: VBoxContainer = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IvlScrollContainer/IntervalHBoxContainer2/IvlFreqRatioVBoxContainer")
onready var ca_ivl_freq_ratio_error_vbox: VBoxContainer = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IvlScrollContainer/IntervalHBoxContainer2/IvlFreqRatioErrorVBoxContainer")
onready var ca_ivl_dist_vbox: VBoxContainer = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IvlScrollContainer/IntervalHBoxContainer2/IvlDistanceVBoxContainer")
onready var ca_ivl_total_12th_steps_vbox: VBoxContainer = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IvlScrollContainer/IntervalHBoxContainer2/IvlTotalTwelfthStepsVBoxContainer")
onready var ca_ivl_scroll_container: ScrollContainer = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IvlScrollContainer")
onready var ca_ivl_hbox: HBoxContainer = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IvlScrollContainer/IntervalHBoxContainer2")
onready var ca_ivl_pitch_lock_vbox: VBoxContainer = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IvlScrollContainer/IntervalHBoxContainer2/IvlPitchLockVBoxContainer")
onready var ca_ivl_interval_lock_vbox: VBoxContainer = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IvlScrollContainer/IntervalHBoxContainer2/IvlIntervalLockVBoxContainer")

const TRIANGLE_SPRITE_PATH: String = "res://Sprites/white_triangle.png"
const SAVED_CHORDS_FOLDER_PATH: String = "user://Saved Chords/"
const C_PITCH_CLASSES: Array = [0,1,71]
const WHITE: Color = Color.white
const ORANGE: Color = Color(1, 0.75, 0.1, 1)
const SEVEN_INT: int = 7
const SEVENTY_TWO_INT: int = 72
const SEVENTY_FIVE_INT: int = 75
const SEVENTY_FIVE_FL: float = 75.0
const BOTTOM_LEFT_BUTTON_NUM: int = 525 # The button on the bottom left corner
const HIGHEST_SEVTWO_NOTE_NUM: int = 577 # 8 octaves * 72 + 1
const AUDIO_FORMAT_VARIABLES: Array = ["flat_note_name", "sharp_note_name", "octave", "octave_c4",\
	"midi_number"] # Possible strings that can be between dollar signs in
	# the path format for an instrument.


var instrument_strings: PoolStringArray = PoolStringArray(["Sine Wave", "Bowed Piano"])
var instrument_colors: PoolColorArray = PoolColorArray([Color(0.0,0.6,0.4), Color.orangered])
var instrument_data: Dictionary = { # When making new instruments, make sure they have
	# a range of at least 1 octave.
	"Sine Wave": {
		"path": "res://Audio/SineWaves/",
		"format": "SineWave $flat_note_name$$octave$.wav",
		"lowest_midi_number": 24, # Lowest C on piano.
		"highest_midi_number": 108, # I'm stopping it at 108; no need to go any further.
		"lowest_sevtwo_number": -1, # Lowest C on piano -16.67c
		"highest_sevtwo_number": 505, # Highest C on piano +16.67c
		"color": Color.darkturquoise.to_html(false)
	},
	"Bowed Piano": {
		"path": "res://Audio/PianoFreeze/",
		"format": "PianoFreeze $flat_note_name$$octave$.wav",
		"lowest_midi_number": 21, # Lowest A on piano.
		"highest_midi_number": 108,
		"lowest_sevtwo_number": -19, # Lowest A on piano - 16.67c 
		"highest_sevtwo_number": 505, # Highest C on piano +16.67c
		"color": ORANGE.to_html(false)
	}
#	"Bowed Guitar": {
#		"path":"res://Audio/GuitarFreezeAmp/",
#		"format": "GuitarFreeze $flat_note_name$$octave$ -0 cents Amp A.wav",
#		"lowest_midi_number": 38,
#		"highest_midi_number": 98
#	},
#	"Bowed Bass Guitar": {
#		"path":"res://Audio/BassFreezePreamp/",
#		"format": "BassFreeze $flat_note_name$$octave$ -0 cents Preamp.wav",
#		"lowest_midi_number": 23,
#		"highest_midi_number": 72
#	}
}


var audio_note_paths: Dictionary
var audio_note_paths_sevtwo: Dictionary

const DEFAULT_TRI_SIDE_LENGTH: float = 146.817
var tri_side_length: float = DEFAULT_TRI_SIDE_LENGTH
const TRI_SIDE_LENGTH_TO_ROW_HEIGHT_RATIO: float = 0.86857947005908079445840740513701
var tri_row_height: float = tri_side_length * TRI_SIDE_LENGTH_TO_ROW_HEIGHT_RATIO
var tri_top_margin: float = 20.0


var point_list: Array
var point_offset: Vector2 = Vector2(6, 18)
var points: Array
var row_offsets: Array = [Vector2(0, 0), Vector2(0, 0.375), Vector2(0, 0.75),\
	Vector2(0, 1.125), Vector2(0, 1.5), Vector2(0, 1.875), Vector2(0, 2.25),\
	Vector2(0, 3)]
var pitches: Dictionary # Key is sevtwo note num, value is Pitch object.
var tri_glow_min_max: Array = [0.5, 0.9]
var tri_glow: float = tri_glow_min_max[0]
var tri_glow_duration: float = 2.0

var screen_size: Vector2 = OS.get_screen_size()

var cam_zooms: Array = [0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0, 1.1, 1.15, 1.2,\
	1.25, 1.3, 1.35, 1.4, 1.45, 1.5]
var cam_zoom: float = 1.0
var cam_size: Vector2 = OS.window_size#screen_size
var cam_size_default: Vector2 = OS.window_size
var cam_move_speed: float = 6.0
var cam_pos: Vector2
var cam_limit_tl: Vector2 = Vector2(0, -50)
var cam_limit_br: Vector2 = Vector2(screen_size.x - OS.window_size.x, screen_size.y - OS.window_size.y)
var cam_move_dir: Vector2


var current_instrument: int = 1 # Will be the index of the instrument in instrument_strings.

var mouse_top_menu_y_threshold: int
var mouse_closest_point: Vector2
var mouse_closest_button: int
var mouse_is_inside_chord_analysis_panel: bool = false

var octave_shift: int = -1 #0
var max_num_of_pitches: int = PitchSet.MAX_NUMBER_OF_PITCHES
var engaged_notes_dict: Dictionary
var audio_players_available: Array = range(max_num_of_pitches)
var active_note_nums: Dictionary

var subtle_cent_randomization: bool = true
var cent_random_width: float = 3.0 # range in cents that the randomized pitch can be offset by.

var active_tris: Array # Array of instance ids of active triangle sprites.

var current_pitch_set: PitchSet = PitchSet.new()

signal pitch_activated(_pitch)
signal pitch_deactivated(_pitch)
signal keyboard_cleared

var grand_staff: GrandStaff

var middle_c_is_c4: bool = false
var settings_panel_is_open: bool = false

enum HalfStepName {HALF_STEP, HALF_TONE, SEMI_TONE}
var half_step_name: int = HalfStepName.HALF_STEP
enum DefaultIntervalsToDisplay {FROM_LOWEST, TO_TOP, FROM_LAST, ALL}
var default_interval_display_method: int = DefaultIntervalsToDisplay.ALL
enum IvlDistanceFormat {DOTS, O_H_T, V_H_T, OC_HS_TS, OCT_HS_TS, DOTS_CENTS, O_H_C, V_H_C, OC_HS_C, OCT_HS_C}
var ivl_distance_format: int = IvlDistanceFormat.DOTS
# 0.0.0
# 0o 0h 0t
# 0v 0h 0t
# 0oc 0hs 0ts
# 0oct 0hs 0ts
# 0.0.00 (cents instead of twelfth steps)
# 0o 0h 00c
# 0v 0h 00c
# 0oc 0hs 00c
# 0oct 0hs 00c
var ca_try_to_keep_last_ivl_rows_on_pitch_set_change: bool = false
var ca_last_ivl_mouse_row: int = -1
var ca_ivl_mouse_row: int
var ca_ivl_row_map: Dictionary # row -> Interval
var ca_ivl_max_denominator: int = Interval.DEFAULT_MAX_DENOMINATOR

var ca_ivl_line_width: float = 5.0
var ca_ivl_circle_radius: float = 10.0
var ca_ivl_text_color: Color = Color.orangered 
var ca_ivl_draw_color: Color = Color.orangered
var ca_ivl_row_height: float = 30.0 # y size of the interval rows in the chord analysis window.
var op_file_row_height: float = 20.0
var is_dragging_select_box: bool = false
enum SelectBoxAction {REPLACE_SELECTION, ADD_TO_SELECTION, REMOVE_FROM_SELECTION}
var select_box_action: int = SelectBoxAction.REPLACE_SELECTION
var select_box_first_corner: Vector2
var select_box_second_corner: Vector2
var select_box_tl: Vector2 # Top-left corner of select box
var select_box_br: Vector2 # Bottom-right corner of select box.
var selected_note_nums: Array # Total selection
var select_box_note_nums: Array
var selection_color: Color = Color.fuchsia
var select_box_alpha: float = 0.3
var shift_held: bool = false
var ctrl_held: bool = false
var alt_held: bool = false
var copied_note_nums: Array




#var trans_data: Dictionary = {
#	Transformation.TRANSPOSE: {
#		"interval_12th_steps_string": "72",
#		"interval_dots_string": "1.0.0"
#	},
#	Transformation.INVERT: {
#		"index_note_number_string": "216",
#		"index_note_name_string": "C3 +0.00c"
#	},
#	Transformation.INVERT_PC: {
#		"index_pitch_class_string": "0"
#	}
#}


static func modulo(_a: int, _b: int):
	if (_a < 0):
		var amodb: int = _a % _b
		var absolute: int = int(abs(float(amodb)))
		return (_b - absolute) % _b;
	else:
		return _a % _b;
		
func randomize_cents(_cents):
	var a: float = _cents - (float(cent_random_width) / 2.0)#25.5
	var b: float = _cents + (float(cent_random_width) / 2.0)
	return (randf() * (b-a)) + a


		

func initialize_grand_staff() -> void:
	grand_staff = get_node("CanvasLayer/GrandStaffPanelContainer/GrandStaff")

	connect("pitch_activated", grand_staff, "_on_MainScene_pitch_activated")
	connect("pitch_deactivated", grand_staff, "_on_MainScene_pitch_deactivated")
	connect("keyboard_cleared", grand_staff, "_on_MainScene_keyboard_cleared")

func ca_remove_placeholders() -> void:
	forcing_control_value = true
	ca_pitches_text_edit.text = ""
	ca_note_numbers_text_edit.text = ""
#	ca_frequencies_label.text = ""
	ca_prime_form_label.text = ""
	ca_normal_form_heading.text = "Normal form (T0): "
	ca_normal_form_label.text = ""
	ca_12th_step_intervals_label.text = ""
	ca_normal_form_12th_step_intervals_label.text = ""
	forcing_control_value = false

func initialize_about() -> void:
	var version_label: Label = get_node("CanvasLayer/HelpPanelContainer/VBoxContainer/HBoxContainer18/VersionLabel")
	version_label.text = "Version " + version
	var title_label: Label = get_node("CanvasLayer/HelpPanelContainer/VBoxContainer/HBoxContainer15/TitleLabel")
	title_label.add_color_override("font_color", Color.orangered)
	version_label.add_color_override("font_color", ORANGE)
	var description_label: RichTextLabel = get_node("CanvasLayer/HelpPanelContainer/VBoxContainer/HBoxContainer17/DescriptionLabel")
	description_label.bbcode_enabled = true
	var hex: String = ORANGE.to_html(false)
	description_label.bbcode_text = "\n    [color=#"+hex+"]" + "Keyboard72[/color]"
	description_label.bbcode_text +=\
		""" is a digital tool for musicians composing in the 72-Tone-Equal-Temperament tuning system. Each half-step is divided into 6 discrete pitches, turning the standard 12-note octave into 72 notes. This allows for exotic harmonies (both consonant and dissonant), as well as a much more accurate realization of the harmonic series.\n"""
	
func ca_update_ivl_ratio_tooltip() -> void:
	var s: String = "The approximate ratio freq_b/freq_a of this interval. The ratio must be 1 or greater, and the denominator cannot be greater than the Max Denominator in the Settings Window (current Max Denominator is " + str(ca_ivl_max_denominator) + ")."
	forcing_control_value = true
	for i in range(ca_ivl_pitch_a_vbox.get_child_count()):
		var freq_ratio_line_edit: LineEdit = ca_ivl_freq_ratio_vbox.get_node("FreqRatioLineEdit"+str(i))
		freq_ratio_line_edit.hint_tooltip = s
	forcing_control_value = false

func initialize_camera() -> void:
	camera.position.y = -32.0
	cam_pos = camera.position
	
	
func find_all_z_relations_OLD(_num_of_pitches: int) -> void:
	var ps: PitchSet = PitchSet.new()
	for i in range(_num_of_pitches):
		var pitch: Pitch = Pitch.new()
		pitch.sevtwo_pitch_class = i
		ps.add_pitch(pitch)
	var ivs: Dictionary
	
	ivs[ps.interval_vector] = ps.prime_form.duplicate()
	var prime_forms_checked: Array = ps.prime_form.duplicate()
	
	var p: int = _num_of_pitches - 1
	# Can the note in slot p be incremented by 1?
	var limit: int
	if p == _num_of_pitches - 1:
		limit = 72
	else:
		limit = ps.normal_form[p + 1] # The place on the right.
	if ps.normal_form[p] + 1 < limit:
		# Yes, it CAN be incremented by 1
		# Which pitch is this?
		var pitch_to_remove: Pitch
		for pitch in ps.pitches:
			if pitch.sevtwo_pitch_class == ps.normal_form[p]:
				pitch_to_remove = pitch
				break
		assert(pitch_to_remove != null)
		ps.remove_pitch(pitch_to_remove)
		# Now increment it and put it back in the pitch set.

static func check_and_maybe_append_interval_vector_dictionaries(\
	_iv_dictionaries: Array, _qpcs: Dictionary) -> bool:
	
	var found: bool = false
	var found_idx: int
	for i in range(_iv_dictionaries.size()):
		var interval_vectors: Dictionary = _iv_dictionaries[_iv_dictionaries.size() - 1 - i] # latest dict.
		
		if interval_vectors.has(_qpcs["interval_vector"]):
			found = true
			found_idx = _iv_dictionaries.size() - 1 - i
			break
	var appended: bool = false
	if not found:
		if _iv_dictionaries.back().size() < 32768: # There's room in the newest dictionary.
			_iv_dictionaries.back()[_qpcs["interval_vector"].duplicate()] = [_qpcs["prime_form"].duplicate()]
		else: # No room in newest dictionary. Add a new dictionary, then add the entry into that new dict.
			_iv_dictionaries.push_back({})
			_iv_dictionaries.back()[_qpcs["interval_vector"].duplicate()] = [_qpcs["prime_form"].duplicate()]
	else:
		var interval_vectors: Dictionary = _iv_dictionaries[found_idx]
		if not interval_vectors[_qpcs["interval_vector"]].has(_qpcs["prime_form"]):
			interval_vectors[_qpcs["interval_vector"].duplicate()].push_back(_qpcs["prime_form"].duplicate())
			appended = true

	return appended

static func factorial(_n: int) -> int:
	var product: int = _n
	var x: int = _n - 1
	while x > 1:
		product *= x
		x -= 1
	return product

func search_for_z_relation(_prime_form: Array, _interval_vector: Array) -> Array:
	# Note: This is slow. TODO: Let the user be able to cancel it if they wish.
	var arr: Array
	var num_of_pitch_classes: int = _prime_form.size()
	for i in range(num_of_pitch_classes):
		arr.push_back(i)
	var p: int = num_of_pitch_classes - 1

	# Can the pitch class in position p be incremented by 1?
	var limit: int
	var v: int
	var prime_forms_checked: Array
	var last_penultimate: int = -1
	while true:
		if p == num_of_pitch_classes - 1:
			limit = 72
		else:
			limit = arr[p + 1] # The place on the right.
		if arr[p] + 1 < limit:
			# Yes, it CAN be incremented by 1
			# Increment it, then set p back to _num_of_pitch_classes - 1.
			arr[p] = arr[p] + 1 # I'm not sure if arr[p] += 1 works.
			print(arr)
			var qpcs: Dictionary = get_quick_pitch_class_set(arr)
			if qpcs["interval_vector"] == _interval_vector && qpcs["prime_form"] != _prime_form:
				return qpcs["prime_form"]

			p = num_of_pitch_classes - 1
		else:
			# No, it CAN'T be incremented by 1.
			while true:
				if p != 1: # If not the leftmost position. # We don't care about position 0
					# because these sets are gonna be put in prime form anyway.
					p -= 1 # Move one position left.
					# Now can THAT value be incremented by 1?
					limit = (72 - num_of_pitch_classes) + p + 1
					if arr[p] + 1 < limit:
						# Increment that position.
						arr[p] = arr[p] + 1
						v = arr[p] + 1
						# Make every position to the right of p sequential from the value at p.
						# e.g., if num_of_pitch_classes == 7, and p == 3, and arr[3] = 5,
						# make arr[4] = 6, arr[5] = 7, and arr[6] = 8.
						for i in range(p + 1, num_of_pitch_classes):
							arr[i] = v
							v += 1
						print(arr)
						var qpcs: Dictionary = get_quick_pitch_class_set(arr)
						if qpcs["interval_vector"] == _interval_vector && qpcs["prime_form"] != _prime_form:
							return qpcs["prime_form"]
						# Now set p back to num_of_pitch_classes - 1.
						p = num_of_pitch_classes - 1
						break
				else:
					p = -1
					break
			if p == -1:
				break
	return []
		
func get_interval_vectors_dictionaries(_num_of_pitches: int) -> Array:
	var arr: Array
	for i in range(_num_of_pitches):
		arr.push_back(i)
	var p: int = _num_of_pitches - 1
	var interval_vector_dictionaries: Array = [{}]
	# Can the pitch class in position p be incremented by 1?
	var limit: int
	var v: int
	var prime_forms_checked: Array
	var last_penultimate: int = -1
	while true:
		if p == _num_of_pitches - 1:
			limit = 72
		else:
			limit = arr[p + 1] # The place on the right.
		if arr[p] + 1 < limit:
			# Yes, it CAN be incremented by 1
			# Increment it, then set p back to _num_of_pitches - 1.
			arr[p] = arr[p] + 1 # I'm not sure if arr[p] += 1 works.
			
			var qpcs: Dictionary = get_quick_pitch_class_set(arr)
			if arr[3] != last_penultimate:
				print(arr, ", prime_form: ", qpcs["prime_form"], ", current interval_vectors dictionary size: ", \
					interval_vector_dictionaries.back().size(), ", total dictioaries: ", interval_vector_dictionaries.size() )
				last_penultimate = arr[3]
#			if not prime_forms_checked.has(qpcs["prime_form"]):
			var appended: bool =\
				check_and_maybe_append_interval_vector_dictionaries(interval_vector_dictionaries, qpcs)

			p = _num_of_pitches - 1
		else:
			# No, it CAN'T be incremented by 1.
			while true:
				if p != 1: # If not the leftmost position. # We don't care about position 0
					# because these sets are gonna be put in prime form anyway.
					p -= 1 # Move one position left.
					# Now can THAT value be incremented by 1?
					limit = (72 - _num_of_pitches) + p + 1
					if arr[p] + 1 < limit:
						# Increment that position.
						arr[p] = arr[p] + 1
						v = arr[p] + 1
						# Make every position to the right of p sequential from the value at p.
						# e.g., if _num_of_pitches == 7, and p == 3, and arr[3] = 5,
						# make arr[4] = 6, arr[5] = 7, and arr[6] = 8.
						for i in range(p + 1, _num_of_pitches):
							arr[i] = v
							v += 1
						var qpcs: Dictionary = get_quick_pitch_class_set(arr)
						var appended: bool =\
							check_and_maybe_append_interval_vector_dictionaries(interval_vector_dictionaries, qpcs)
						# Now set p back to _num_of_pitches - 1.
						p = _num_of_pitches - 1
						break
				else:
					p = -1
					break
			if p == -1:
				break
	return interval_vector_dictionaries
	
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
	
func get_quick_pitch_class_set(_pcs: Array) -> Dictionary:
	# Similar to PitchClassSet, except there's no Pitch objects or Interval objects in it,
	# just pitch classes.
	var normal_form: Array
	var prime_form: Array
	var is_inversion_of_prime_form: bool = false
	var is_inversionally_symmetrical: bool = false
	var transposition_index_string: String
	var pc_set: Array
	for p in _pcs: # pc_set will be _pcs but without any duplicates.
		if not pc_set.has(p):
			pc_set.push_back(p)
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
		var dict: Dictionary = {
			"normal_form": normal_form,
			"prime_form": prime_form,
			"is_inversionally_symmetrical": is_inversionally_symmetrical,
			"is_inversion_of_prime_form": is_inversion_of_prime_form,
			"transposition_index_string": transposition_index_string,
			"interval_vector": PitchSet.get_interval_vector(prime_form)
		}
		return dict
		
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
		var dict: Dictionary = {
			"normal_form": normal_form,
			"prime_form": prime_form,
			"is_inversionally_symmetrical": is_inversionally_symmetrical,
			"is_inversion_of_prime_form": is_inversion_of_prime_form,
			"transposition_index_string": transposition_index_string,
			"interval_vector": PitchSet.get_interval_vector(prime_form)
		}
		return dict
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
		var dict: Dictionary = {
			"normal_form": normal_form,
			"prime_form": prime_form,
			"is_inversionally_symmetrical": is_inversionally_symmetrical,
			"is_inversion_of_prime_form": is_inversion_of_prime_form,
			"transposition_index_string": transposition_index_string,
			"interval_vector": PitchSet.get_interval_vector(prime_form)
		}
		return dict
	# Got here? The sets are inversionally symmetrical.
	prime_form = prime_set_a.duplicate()
	is_inversionally_symmetrical = true
	is_inversion_of_prime_form = false
	transposition_index_string = "T"+str(normal_form[0])#"T"+str(normal_form[0] - prime_form[0])
	#interval_vector = get_interval_vector(prime_form)
	var dict: Dictionary = {
		"normal_form": normal_form,
		"prime_form": prime_form,
		"is_inversionally_symmetrical": is_inversionally_symmetrical,
		"is_inversion_of_prime_form": is_inversion_of_prime_form,
		"transposition_index_string": transposition_index_string,
		"interval_vector": PitchSet.get_interval_vector(prime_form)
	}
	return dict
	
func initialize_trans_pitch_line_edits() -> void:
	forcing_control_value = true
	pitch_line_edit_forcing_format_change = true
	trans_norm_dist_mean_pitch_line_edit.pitch.sevtwo_note_num = 216 # Middle C
	trans_norm_dist_deviation_line_edit.text = "6.00"
	trans_random_range_low_pitch_line_edit.pitch.sevtwo_note_num = instrument_data[instrument_strings[current_instrument]]["lowest_sevtwo_number"]
	trans_random_range_high_pitch_line_edit.pitch.sevtwo_note_num = instrument_data[instrument_strings[current_instrument]]["highest_sevtwo_number"]
	trans_norm_dist_mean_pitch_line_edit.pitch_format_only = true
	trans_random_range_low_pitch_line_edit.pitch_format_only = true
	trans_random_range_high_pitch_line_edit.pitch_format_only = true
	trans_norm_dist_mean_pitch_line_edit.force_update_text()
	trans_random_range_low_pitch_line_edit.force_update_text()
	trans_random_range_high_pitch_line_edit.force_update_text()

	forcing_control_value = false
	pitch_line_edit_forcing_format_change = false

func _ready():
	randomize()
	make_points()
	make_pitches()
	initialize_audio_note_paths()
	initialize_audio_stream_players()
	start_tri_glow_tween()
	initialize_camera()
	initialize_grand_staff()
	current_pitch_set.connect("pitch_set_changed", self, "_on_PitchSet_pitch_set_changed")
	current_pitch_set.main_scene = self
	var top_panel: PanelContainer = get_node("CanvasLayer/TopMenu/PanelContainer")
	mouse_top_menu_y_threshold = top_panel.rect_size.y
	ca_remove_placeholders()
	update()
	initialize_about()
	get_node("CanvasLayer/SettingsPanelContainer/VBoxContainer/HBoxContainer6/MaxDenominatorSpinBox").value = ca_ivl_max_denominator
	get_node("CanvasLayer/SettingsPanelContainer/VBoxContainer/HBoxContainer3/IvlDistanceFormatOptionButton").selected = ivl_distance_format
	initialize_trans_pitch_line_edits()
	

func get_all_z_relations(_num_of_pitch_classes: int) -> Dictionary:
	var arr: Array = get_interval_vectors_dictionaries(_num_of_pitch_classes)
	var dict: Dictionary
	for ivs in arr:
		for iv in ivs:
			if ivs[iv].size() >= 2:
				dict[iv] = ivs[iv].duplicate(true)
#				print(iv, ": ")
#				for pf in ivs[iv]:
#					print("    ", pf)
	return dict

func save_z_relations(_num_of_pitch_classes: int, _z_relations: Dictionary) -> void:
	var file: File = File.new()
	var path: String = "res://Misc/ZRelations/z_relations_"+str(_num_of_pitch_classes)+"_pitch_classes.save"
	file.open(path, File.WRITE)
	file.store_line(to_json(_z_relations))
	file.close()
	print("Saved \""+path+"\" successfully!")

func mouse_inside_settings_panel(_mouse_pos: Vector2) -> bool:
	# can use generic
	if not settings_panel.visible:
		return false
	var settings_pos: Vector2 = settings_panel.rect_global_position + cam_pos
	var settings_size: Vector2 = settings_panel.rect_size * settings_panel.rect_scale
	var br: Vector2 = settings_pos + settings_size
	return _mouse_pos.x >= settings_pos.x && _mouse_pos.x <= br.x\
		&& _mouse_pos.y >= settings_pos.y && _mouse_pos.y <= br.y
		
		
func mouse_inside_gs_panel(_mouse_pos: Vector2) -> bool:
	if not grand_staff_panel.visible:
		return false
	var gs_pos: Vector2 = grand_staff.rect_global_position
	var gs_size: Vector2 = grand_staff.rect_size * grand_staff_panel.rect_scale
	var br: Vector2 = gs_pos + gs_size + (Vector2(-7,-27) * grand_staff_panel.rect_scale)
	return _mouse_pos.x >= gs_pos.x && _mouse_pos.x <= br.x\
		&& _mouse_pos.y >= gs_pos.y && _mouse_pos.y <= br.y



func mouse_inside_help_panel(_mouse_pos: Vector2) -> bool:
	# can use generic
	if not help_panel.visible:
		return false
	var help_pos: Vector2 = help_panel.rect_global_position + cam_pos
	var help_size: Vector2 = help_panel.rect_size * help_panel.rect_scale
	var br: Vector2 = help_pos + help_size
#	print("gs_pos: ", gs_pos, ", gs_size: ", gs_size, ", _mouse_pos: ", _mouse_pos, ", br: ", br)
	return _mouse_pos.x >= help_pos.x && _mouse_pos.x <= br.x\
		&& _mouse_pos.y >= help_pos.y && _mouse_pos.y <= br.y
		


func mouse_inside_chord_analysis_panel(_mouse_pos: Vector2) -> bool:
	if not chord_analysis_panel.visible:
		mouse_is_inside_chord_analysis_panel = false
		return false
	var ca_pos: Vector2 = chord_analysis_panel.rect_global_position + cam_pos
	var ca_size: Vector2 = chord_analysis_panel.rect_size * chord_analysis_panel.rect_scale
	var br: Vector2 = ca_pos + ca_size
#	print("gs_pos: ", gs_pos, ", gs_size: ", gs_size, ", _mouse_pos: ", _mouse_pos, ", br: ", br)
	var last: bool = mouse_is_inside_chord_analysis_panel
	mouse_is_inside_chord_analysis_panel = _mouse_pos.x >= ca_pos.x && _mouse_pos.x <= br.x\
		&& _mouse_pos.y >= ca_pos.y && _mouse_pos.y <= br.y
	if mouse_is_inside_chord_analysis_panel != last:
		update()
	return mouse_is_inside_chord_analysis_panel

#func mouse_inside_transform_panel(_mouse_pos: Vector2) -> bool:
#	# Can use generic
#	if not transform_panel.visible:
#		return false
#	var pos: Vector2 = transform_panel.rect_global_position + cam_pos
#	var sz: Vector2 = transform_panel.rect_size * transform_panel.rect_scale
#	var br: Vector2 = pos + sz
##	print("gs_pos: ", gs_pos, ", gs_size: ", gs_size, ", _mouse_pos: ", _mouse_pos, ", br: ", br)
#	return _mouse_pos.x >= pos.x && _mouse_pos.x <= br.x\
#		&& _mouse_pos.y >= pos.y && _mouse_pos.y <= br.y
		
func mouse_inside_panel(_mouse_pos: Vector2, _panel: PanelContainer) -> bool:
	# For any generic panel. Some panels, like the grand staff, need extra considerations,
	# so use their specific mouse_inside functions.
	if not _panel.visible:
		return false
	var pos: Vector2 = _panel.rect_global_position + cam_pos
	var sz: Vector2 =_panel.rect_size * _panel.rect_scale
	var br: Vector2 = pos + sz
	return _mouse_pos.x >= pos.x && _mouse_pos.x <= br.x\
		&& _mouse_pos.y >= pos.y && _mouse_pos.y <= br.y

func mouse_inside_any_panel(_mouse_pos: Vector2) -> bool:
#	return mouse_inside_chord_analysis_panel(_mouse_pos)\
#		|| mouse_inside_settings_panel(_mouse_pos)\
#		|| mouse_inside_gs_panel(_mouse_pos)\
#		|| mouse_inside_help_panel(_mouse_pos)\
#		|| mouse_inside_transform_panel(_mouse_pos)\
	return mouse_inside_chord_analysis_panel(_mouse_pos)\
		|| mouse_inside_gs_panel(_mouse_pos)\
		|| mouse_inside_panel(_mouse_pos, help_panel)\
		|| mouse_inside_panel(_mouse_pos, settings_panel)\
		|| mouse_inside_panel(_mouse_pos, save_panel)\
		|| mouse_inside_panel(_mouse_pos, open_panel)\
		|| mouse_inside_panel(_mouse_pos, transform_panel)


func any_text_field_has_focus() -> bool:
	if save_panel.visible:
		if sv_save_chord_name_line_edit.has_focus():
			return true
	if open_panel.visible:
		if op_open_chord_name_line_edit.has_focus():
			return true
	if chord_analysis_panel.visible:
		for i in range(ca_ivl_pitch_a_vbox.get_child_count()):
			if ca_ivl_freq_ratio_vbox.get_node("FreqRatioLineEdit"+str(i)).has_focus():
				return true
			if ca_ivl_total_12th_steps_vbox.get_node("TotalTwelfthStepsLineEdit"+str(i)).has_focus():
				return true
		if ca_pitches_text_edit.has_focus()\
			|| ca_note_numbers_text_edit.has_focus()\
			|| ca_frequencies_text_edit.has_focus():
				return true
	if transform_panel.visible:
		if trans_transpose_interval_line_edit.has_focus()\
			|| trans_transposition_index_line_edit.has_focus()\
			|| trans_invert_axis_a_pitch_line_edit.has_focus()\
			|| trans_invert_axis_b_pitch_line_edit.has_focus()\
			|| trans_invert_map_a_pitch_line_edit.has_focus()\
			|| trans_invert_map_b_pitch_line_edit.has_focus()\
			|| trans_random_num_of_elements_line_edit.has_focus()\
			|| trans_random_range_low_pitch_line_edit.has_focus()\
			|| trans_random_range_high_pitch_line_edit.has_focus()\
			|| trans_norm_dist_mean_pitch_line_edit.has_focus()\
			|| trans_norm_dist_deviation_line_edit.has_focus():
			return true
	return false
	



		
func select_all_active_notes() -> void:
	clear_selection()
	for note_num in current_pitch_set.note_numbers:
		add_active_note_num_to_selection(note_num)
	update()

func add_active_note_num_to_selection(_note_num: int) -> void:
	assert(not selected_note_nums.has(_note_num)) # Should've already checked for it.
	selected_note_nums.push_back(_note_num)
	var button_num: int = active_note_num_to_button_num(_note_num)
	var tri: Sprite = get_node("Triangle" + str(_note_num) + "_" + str(current_instrument))
	tri.modulate = Color(selection_color.r, selection_color.g, selection_color.b, tri_glow)
	
func remove_active_note_num_from_selection(_note_num: int) -> void:
	assert(selected_note_nums.has(_note_num))
	selected_note_nums.remove(selected_note_nums.find(_note_num))
	var button_num: int = active_note_num_to_button_num(_note_num)
	var tri: Sprite = get_node("Triangle" + str(_note_num) + "_" + str(current_instrument))
	var color: Color = Color(instrument_data[instrument_strings[current_instrument]]["color"])
	tri.modulate = Color(color.r, color.g, color.b, tri_glow)

func update_select_box_rect() -> void:
	var a: Vector2 = select_box_second_corner
	var b: Vector2 = select_box_first_corner
	if a.y < b.y:
		if a.x < b.x:
			select_box_tl = a
			select_box_br = b
		elif a.x == b.x:
			select_box_tl = a
			select_box_br = b
		elif a.x > b.x:
			select_box_tl = Vector2(b.x, a.y)
			select_box_br = Vector2(a.x, b.y)
	elif a.y == b.y:
		if a.x < b.x:
			select_box_tl = a
			select_box_br = b
		elif a.x == b.x:
			select_box_tl = a
			select_box_br = b
		elif a.x > b.x:
			select_box_tl = b
			select_box_br = a
	elif a.y > b.y:
		if a.x < b.x:
			select_box_tl = Vector2(a.x, b.y)
			select_box_br = Vector2(b.x, a.y)
		elif a.x == b.x:
			select_box_tl = b
			select_box_br = a
		elif a.x > b.x:
			select_box_tl = b
			select_box_br = a

# top row screen pos y: -48 thru

func drag_select_box(_mouse_pos: Vector2) -> void:
	assert(is_dragging_select_box)
	select_box_second_corner = _mouse_pos
	update_select_box_rect()
	var button_num: int
	var point: Vector2
	for note_num in current_pitch_set.note_numbers:
		button_num = active_note_num_to_button_num(note_num)
		point = points[button_num]
		if point.x >= select_box_tl.x && point.x <= select_box_br.x\
			&& point.y >= select_box_tl.y && point.y <= select_box_br.y:
				# This point is inside the select box.
				if select_box_action == SelectBoxAction.REMOVE_FROM_SELECTION:
					if selected_note_nums.has(note_num):
						remove_active_note_num_from_selection(note_num)
				else: # Adding to selection.
					if not selected_note_nums.has(note_num):
						add_active_note_num_to_selection(note_num)
				

		
	update()

func release_select_box(_ctrl_held: bool, _alt_held: bool) -> void:
	# TODO: This.
	
	is_dragging_select_box = false
	select_box_note_nums.clear()
	update()
	
	

	
func clear_selection() -> void:
	var color: Color = Color(instrument_data[instrument_strings[current_instrument]]["color"])
	for note_num in selected_note_nums:
		var button_num: int = active_note_num_to_button_num(note_num)
		var tri: Sprite = get_node_or_null("Triangle" + str(note_num)\
			+ "_" + str(current_instrument))
		if tri != null:
			tri.modulate = Color(color.r, color.g, color.b, tri_glow)
	selected_note_nums.clear()
	update()

func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.scancode == KEY_CONTROL:
		ctrl_held = event.is_pressed()
	if event is InputEventKey && event.scancode == KEY_SHIFT:
		shift_held = event.is_pressed()
	if event is InputEventKey && event.scancode == KEY_ALT:
		alt_held = event.is_pressed()
	if event is InputEventKey && event.scancode == KEY_TAB\
		&& event.is_pressed() && not event.is_echo():
			alt_held = false

	
	if event is InputEventMouseMotion:
		update_closest_mouse_point_and_button()
		mouse_inside_chord_analysis_panel(get_global_mouse_position())
		ca_update_ca_ivl_mouse_row()
#		op_update_op_file_mouse_row()
		if is_dragging_select_box:
			drag_select_box(get_global_mouse_position())
		
	if important_panel_is_open:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == 1: # Left mouse button.
			if not event.is_pressed(): # Released
				if is_dragging_select_box:
					release_select_box(ctrl_held, alt_held)

			
	if event is InputEventMouseButton && event.is_pressed() && not event.is_echo():
		var m: Vector2 = get_global_mouse_position()
		var m_screen: Vector2 = m - cam_pos
		if m_screen.y > mouse_top_menu_y_threshold:
			if not mouse_inside_any_panel(m):
				if event.button_index == 1: # Left mouse button.
					alt_held = event.is_action_pressed("alt")
					click_button(mouse_closest_button, current_instrument, true, ctrl_held, alt_held, m)
					
	if event is InputEventKey && event.is_pressed() && not event.is_echo():
		if not any_text_field_has_focus():
#			print("event scancode with modifiers: ", OS.get_scancode_string(event.get_scancode_with_modifiers()))
			match OS.get_scancode_string(event.get_scancode_with_modifiers()):
				"Minus": # Minus
					zoom_camera(1)
				"Equal": # Equal
					zoom_camera(-1)
				"BackSpace": # Backspace
					if not is_dragging_select_box:
						if selected_note_nums.empty():
							clear_all_notes()
						else:
							clear_selected_notes()
				"Escape":
					if not selected_note_nums.empty() && not is_dragging_select_box:
						clear_selection()

				"N":
					grand_staff_panel.visible = !grand_staff_panel.visible
					forcing_control_value = true
					notation_button.pressed = grand_staff_panel.visible
					forcing_control_value = false
				"A":
					chord_analysis_panel.visible = !chord_analysis_panel.visible
					forcing_control_value = true
					chord_analysis_button.pressed = chord_analysis_panel.visible
					forcing_control_value = false
					mouse_inside_chord_analysis_panel(get_global_mouse_position())
					ca_update_ca_ivl_mouse_row()
				"H":
					help_panel.visible = !help_panel.visible
					forcing_control_value = true
					help_button.pressed = help_panel.visible
					forcing_control_value = false
				"S":
					if not settings_panel_is_open:
						open_settings_panel()
					else:
						close_settings_panel()
				"T":
					if not is_dragging_select_box:
						transform_panel.visible = !transform_panel.visible
						forcing_control_value = true
						transform_button.pressed = transform_panel.visible
						forcing_control_value = false
					if transform_panel.visible:
						self.transformation = transformation # Setter will show 
						# the relevant hboxes.

				"Control+A":
					if not is_dragging_select_box:
						select_all_active_notes()
				"Control+S":
					if not is_dragging_select_box:
						start_save_pitch_set(current_pitch_set, false)
				"Shift+Control+S":
					if not is_dragging_select_box:
						start_save_pitch_set(current_pitch_set, true)
				"Control+C":
					if not is_dragging_select_box:
						copy_selected_notes()
				"Control+V":
					if not is_dragging_select_box:
						paste_copied_notes([])
				"Shift+Control+V":
					if not is_dragging_select_box:
						if selected_note_nums.empty():
							paste_copied_notes(current_pitch_set.note_numbers.duplicate())
						else:
							paste_copied_notes(selected_note_nums.duplicate())
				"Control+Up":
					if not is_dragging_select_box:
						if selected_note_nums.empty():
							quick_transpose(current_pitch_set.note_numbers, 1)
						else:
							quick_transpose(selected_note_nums.duplicate(), 1)
				"Control+Down":
					if not is_dragging_select_box:
						if selected_note_nums.empty():
							quick_transpose(current_pitch_set.note_numbers, -1)
						else:
							quick_transpose(selected_note_nums.duplicate(), -1)
				
						
func quick_transpose(_note_numbers: Array, _dist: int) -> void:
	var new_note_numbers: Array
	if _note_numbers == current_pitch_set.note_numbers: # Transposing everything.
		for n in _note_numbers:
			new_note_numbers.push_back(\
				transpose_note_num_by_octaves_until_within_instrument_range(n + _dist, current_instrument))
		set_current_pitch_set_note_numbers(new_note_numbers)
		if _note_numbers == selected_note_nums: # Update selection
			selected_note_nums = new_note_numbers.duplicate()
			update_selected_notes_tris_to_selection_color()
	else: # Transposing some, but not all.
		var current_note_numbers: Array = current_pitch_set.note_numbers.duplicate()
		for n in _note_numbers:
			new_note_numbers.push_back(\
				transpose_note_num_by_octaves_until_within_instrument_range(n + _dist, current_instrument))
			current_note_numbers.remove(current_note_numbers.find(n))
		var update_select_colors: bool = false
		if _note_numbers == selected_note_nums: # Update selection
			selected_note_nums = new_note_numbers.duplicate()
			update_select_colors = true
		# combine current into new
		for n in current_note_numbers:
			if not new_note_numbers.has(n):
				new_note_numbers.push_back(n)
		set_current_pitch_set_note_numbers(new_note_numbers)
		if update_select_colors:
			update_selected_notes_tris_to_selection_color()
	ca_update_chord_analysis_window(current_pitch_set)
	if transform_panel.visible:
		trans_update()
	update()


func update_tri_glow() -> void:
	for iid in active_tris:
		var sprite: Sprite = instance_from_id(iid)
		sprite.modulate.a = tri_glow
	
func _physics_process(delta):
	if (Input.is_action_pressed("ui_up")\
		|| Input.is_action_pressed("ui_left")\
		|| Input.is_action_pressed("ui_right")\
		|| Input.is_action_pressed("ui_down")) && not shift_held && not ctrl_held:
		
			if Input.is_action_pressed("ui_left"):
				cam_move_dir.x = -1
			elif Input.is_action_pressed("ui_right"):
				cam_move_dir.x = 1
			else:
				cam_move_dir.x = 0
			if Input.is_action_pressed("ui_up"):
				cam_move_dir.y = -1
			elif Input.is_action_pressed("ui_down"):
				cam_move_dir.y = 1
			else:
				cam_move_dir.y = 0
			move_camera(cam_move_dir)
			
	update_tri_glow()

func move_camera(dir: Vector2) -> void:
#	var debug_cam_label: Label = get_node("CanvasLayer/DebugCamLabel")
#	debug_cam_label.text = "window_size: "+str(OS.window_size)+\
#		"\ncam_size: "+str(cam_size)+\
#		"\ncam_pos: "+str(cam_pos)+\
#		"\ncam_limit_tl: "+str(cam_limit_tl)+\
#		"\ncam_limit_br: "+str(cam_limit_br)
	cam_pos += dir * cam_move_speed
	cam_pos.x = clamp(cam_pos.x, cam_limit_tl.x, cam_limit_br.x)
	cam_pos.y = clamp(cam_pos.y, cam_limit_tl.y, cam_limit_br.y)
	update_camera()
	
func update_camera() -> void:
	camera.position = cam_pos
	update()
	update_closest_mouse_point_and_button()


func zoom_camera(dir: int) -> void:
	var idx: int = cam_zooms.find(float(cam_zoom))
	idx += dir
	idx = clamp(idx, 0, cam_zooms.size() - 1)
	cam_zoom = cam_zooms[idx]
	cam_size.x = cam_size_default.x * cam_zoom
	cam_size.y = cam_size_default.y * cam_zoom
	cam_limit_br.x = screen_size.x - (OS.window_size.x * cam_zoom)
	cam_limit_br.y = screen_size.y - (OS.window_size.y * cam_zoom)
	camera.zoom.x = cam_zoom
	camera.zoom.y = cam_zoom
	move_camera(Vector2(0,0)) # move_camera will clamp camera and update mouse info.

func start_select_box(_mouse_pos: Vector2) -> void:
	is_dragging_select_box = true
	select_box_first_corner = _mouse_pos
	select_box_second_corner = _mouse_pos
	select_box_tl = _mouse_pos
	select_box_br = _mouse_pos

func set_current_pitch_set_note_numbers(_new_note_numbers: Array) -> void:
	var old_note_numbers: Array = current_pitch_set.note_numbers.duplicate()
	# Turn off old ones.
	var button_num: int
	for old_note_num in old_note_numbers:
		if not _new_note_numbers.has(old_note_num):
			button_num = active_note_num_to_button_num(old_note_num)
			click_button(button_num, current_instrument, false, false, false)
	if _new_note_numbers.empty():
		_on_PitchSet_pitch_set_changed(current_pitch_set)
		return
	# Turn on new ones.
	for new_note_num in _new_note_numbers:
		if not old_note_numbers.has(new_note_num):
			button_num = note_num_to_button_num(new_note_num)
			click_button(button_num, current_instrument, false, false, false)
	_on_PitchSet_pitch_set_changed(current_pitch_set)
	
func update_selected_notes_tris_to_selection_color() -> void:
	for note_num in selected_note_nums:
		var tri: Sprite = get_node("Triangle" + str(note_num) + "_" + str(current_instrument))
		tri.modulate = Color(selection_color.r, selection_color.g, selection_color.b, tri_glow)

func click_button(_button_num: int, _instrument: int, _update_chord_analysis: bool = true,\
	_ctrl_held: bool = false, _alt_held: bool = false, _mouse_pos: Vector2 = Vector2(0,0)) -> void:
	# _mouse_pos is only relevant if _ctrl_held or _alt_held.
	var note_num: int = button_num_to_note_num(_button_num)
	
	if not _ctrl_held && _alt_held:
		select_box_action = SelectBoxAction.REMOVE_FROM_SELECTION
		start_select_box(_mouse_pos)
		if current_pitch_set.note_numbers.has(note_num): # Clicked on an active note.
			if selected_note_nums.has(note_num):
				remove_active_note_num_from_selection(note_num)
		return
	elif _ctrl_held:
		select_box_action = SelectBoxAction.ADD_TO_SELECTION
		start_select_box(_mouse_pos)
		if current_pitch_set.note_numbers.has(note_num): # Clicked on an active note.
			if not selected_note_nums.has(note_num):
				add_active_note_num_to_selection(note_num)
		return
	elif not _ctrl_held && not _alt_held: # Nothing about selection.
		# First, add the instrument to the engaged_notes_dictionary if it's not there already.
		if not engaged_notes_dict.has(_instrument): # if this instrument hasn't been used yet
			
			# Add the key to the dictionary
			engaged_notes_dict[_instrument] = {
				"note_nums": [],
				"audio_player_nums": []
			}
		
		var pitch: Pitch = pitches[note_num]

		if not engaged_notes_dict[_instrument]["note_nums"].has(note_num):
			if current_pitch_set.pitches.size() + 1 > current_pitch_set.MAX_NUMBER_OF_PITCHES:
				open_notify_panel("Chord size cannot be more than "+str(current_pitch_set.MAX_NUMBER_OF_PITCHES)\
					+" pitches!")
				if engaged_notes_dict[_instrument]["note_nums"].empty():
					engaged_notes_dict.erase(_instrument)
				_on_PitchSet_pitch_set_changed(current_pitch_set)
				return
			# If this note_num is NOT turned on yet (by this instrument)
			if note_num_is_within_instrument_range(note_num, _instrument): # and it's within the instrument's range
				# play audio
				var audio_player_num: int = play_note_num(note_num, _instrument)
				if audio_player_num != -1: # Ff there were audio players available.
					var button_pos: Vector2 = points[_button_num]
					add_triangle(note_num, _button_num, button_pos, _instrument)
					append_engaged_notes_dict(note_num, _instrument, audio_player_num)
				if not current_pitch_set.has(pitch):
					current_pitch_set.add_pitch(pitch, _update_chord_analysis)
		else: # Already turned on by this instrument, so we turn it off.
			# TODO (eventually when multiple instruments are supported): 
			#	Maybe make it so we can turn off notes no matter what our current instrument is.
			if current_pitch_set.has(pitch):
				current_pitch_set.remove_pitch(pitch, _update_chord_analysis)
			stop_note_num(note_num, _instrument)
			if selected_note_nums.has(note_num):
				remove_active_note_num_from_selection(note_num)
			delete_triangle(note_num, _instrument)
			#engaged_note_nums.remove(engaged_note_nums.find(note_num))
			remove_engaged_notes_dict(note_num, _instrument)
			
			
func open_notify_panel(_text: String, _duration: float = 3.0) -> void:
	notify_panel.get_node("CenterContainer/Label").text = _text
	var timer: Timer = notify_panel.get_node("Timer")
	
	notify_panel.visible = true
	timer.start(_duration)
	
func close_notify_panel() -> void:
	notify_panel.visible = false
	
func _on_notify_panel_Timer_timeout():
	close_notify_panel()

func _on_NotifyPanel_gui_input(_event: InputEvent) -> void:
	if _event is InputEventMouseButton && _event.button_index == 1\
		&& _event.is_pressed() && not _event.is_echo():
		close_notify_panel()

func play_note_num(_note_num: int, _instrument: int) -> int:
	# Returns the audio player number after playback starts, or -1 if failed.
	var path: String = get_audio_file_path_quick( _note_num, instrument_strings[_instrument])
	var pitch: Pitch = pitches[_note_num]
	
	var cents: float = pitch.cents
	if audio_players_available.empty():
		print("Error: No more audio players available!!!")
	else: # Ff there are audio players available.
		var audio_player_num: int = audio_players_available.back() # get the last num in the list.
		audio_players_available.pop_back() # it's active now, so remove it from this list.
		#update_voices_available_label()
#		# get the audio player
		var player: AudioStreamPlayer = get_node("AudioStreamPlayers/AudioStreamPlayer"+str(audio_player_num))
		player.volume_db = -30
		if subtle_cent_randomization:
			cents = randomize_cents(cents)
		player.pitch_scale = pitch.cents_to_playback_speed(cents) # set the pitch correctly.
		var s = load(path)
		player.stream = s
		player.play()
		emit_signal("pitch_activated", pitch)
		return audio_player_num
	return -1

func append_engaged_notes_dict(note_num: int, instrument: int, audio_player_num: int):
	assert(engaged_notes_dict.keys().has(instrument))
	engaged_notes_dict[instrument]["note_nums"].append(note_num)
	engaged_notes_dict[instrument]["audio_player_nums"].append(audio_player_num)
	
func remove_engaged_notes_dict(_note_num: int, _instrument: int):
	assert(engaged_notes_dict.has(_instrument))
	# remove the note num from the array for this instrument
	var idx: int = engaged_notes_dict[_instrument]["note_nums"].find(_note_num)
	engaged_notes_dict[_instrument]["note_nums"].remove(idx)
	# now we put the audio player back into the available list
	var audio_player_num: int = engaged_notes_dict[_instrument]["audio_player_nums"][idx]
	audio_players_available.push_front(audio_player_num)
	# Now remove the audio player num from the engaged notes dictionary too.
	engaged_notes_dict[_instrument]["audio_player_nums"].remove(idx)
	
		


		
func stop_note_num(_note_num: int, _instrument: int):
	#var audio_player_num = active_note_nums[note_num]
	var pitch: Pitch = pitches[_note_num]
	var idx: int = engaged_notes_dict[_instrument]["note_nums"].find(_note_num)
	var audio_player_num: int = engaged_notes_dict[_instrument]["audio_player_nums"][idx]
	var player: AudioStreamPlayer = get_node("AudioStreamPlayers/AudioStreamPlayer"+str(audio_player_num))
	player.stop()
	emit_signal("pitch_deactivated", pitch)
	
func clear_selected_notes() -> void:
	var sn: Array = selected_note_nums.duplicate()
	clear_selection()
	var note_num: int
	var button_num: int
	for i in range(sn.size()):
		note_num = sn[i]
		button_num = active_note_num_to_button_num(note_num)
		if i != sn.size() - 1: # If not last element.
			click_button(button_num, current_instrument, false, false, false)
		else: # Last element.
			click_button(button_num, current_instrument, true, false, false)
			
func copy_selected_notes() -> void:
	copied_note_nums = selected_note_nums.duplicate()

func paste_copied_notes(_note_nums_to_overwrite: Array) -> void:
	if copied_note_nums.empty():
		return
	var note_num: int
	var button_num: int
	clear_selection() # Clear selection because we're gonna change it in a moment.
	# Remove the notes we want to overwrite.
	for i in range(_note_nums_to_overwrite.size()):
		note_num = _note_nums_to_overwrite[i]
		button_num = active_note_num_to_button_num(note_num)
		click_button(button_num, current_instrument, false, false, false)
	# Now add the copied notes.
	for i in range(copied_note_nums.size()):
		note_num = copied_note_nums[i]
		button_num = active_note_num_to_button_num(note_num)
		if i != copied_note_nums.size() - 1: # If not last element.
			click_button(button_num, current_instrument, false, false, false)
		else: # Last element.
			click_button(button_num, current_instrument, true, false, false)
	# The notes that were pasted are now the selection.
	for nn in copied_note_nums:
		add_active_note_num_to_selection(nn)
	update()
	
		
	
func clear_all_notes():
	var last_instrument: int = current_instrument
	for instrument in engaged_notes_dict:
		var note_nums_to_click: Array
		for note_num in engaged_notes_dict[instrument]["note_nums"]:
			note_nums_to_click.append(note_num)
		for i in range(note_nums_to_click.size()):
			var note_num: int = note_nums_to_click[i]
			var button_num: int = note_num_to_button_num(note_num)
			#### TODO: What if the note_num is a C? Almost every C has 2 button nums.
			current_instrument = instrument
			if i != note_nums_to_click.size() - 1: # If not last element.
				click_button(button_num, instrument, false, false, false)
			else: # Last element,
				click_button(button_num, instrument, true, false, false)
	current_instrument = last_instrument
	selected_note_nums.clear()
	emit_signal("keyboard_cleared")



func delete_triangle(_note_num: int, _instrument: int):
	var tri_to_delete = get_node("Triangle"+str(_note_num)+"_"+str(_instrument))
	var idx: int = active_tris.find(tri_to_delete.get_instance_id())
	active_tris.remove(idx)
	if tri_to_delete != null:
		tri_to_delete.free()
	else:
		push_error("ERROR: Triangle to delete didn't exist!! note_num: "+str(_note_num)+" instrument: "+str(_instrument))



func add_triangle(_note_num: int, _button_num: int, _button_pos: Vector2, _instrument: int):
	var mod_75: int = modulo(_button_num, 75)
	var row = int(floor(float(_button_num) / 75.0))
	var floor_3: int = int(floor(float(mod_75) / 3.0))
	var tri_upside_down: bool = false
	if floor_3 % 2 == 0: # even number
		tri_upside_down = true
	tri_upside_down = bool((int(tri_upside_down) + row + 1) % 2)
	var mod_3: int = modulo(mod_75, 3)
	
	var texture: Texture = load(TRIANGLE_SPRITE_PATH)
	var spr: Sprite = Sprite.new()
	spr.texture = texture
	var color: Color = instrument_data[instrument_strings[_instrument]]["color"]#instrument_colors[_instrument]
	spr.modulate = Color(color.r, color.g, color.b, tri_glow)
	
	var rot: int = 0
	var spr_offset: Vector2 = Vector2(0,0)
	match [tri_upside_down, mod_3]:
		[false, 1]:
			rot = 0
			spr_offset = Vector2(-0.2, -5)
		[true, 0]:
			rot = 60
			spr_offset = Vector2(6, -2)
		[false, 0]:
			rot = 120
			spr_offset = Vector2(6, 7.5)
		[true, 1]:
			rot = 180
			spr_offset = Vector2(0, 10)
		[false, 2]:
			rot = 240
			spr_offset = Vector2(-6, 6.5)
		[true, 2]:
			rot = 300
			spr_offset = Vector2(-6, -2)

	spr.position = _button_pos + spr_offset
	spr.rotation_degrees = rot
	spr.z_index = -1
#	print("Adding triangle: "+"Triangle" + str(note_num) + "_" + str(instrument))
	spr.name = "Triangle" + str(_note_num) + "_" + str(_instrument)
	add_child(spr)
	active_tris.append(spr.get_instance_id())
		
func button_num_to_note_num(_button_num: int) -> int:
	# We've decided to delete the top row because it's way too high up there.
	if _button_num == BOTTOM_LEFT_BUTTON_NUM: # the button on the bottom left corner
		return -1 + (octave_shift * SEVENTY_TWO_INT)
	# Middle C (C3) is note number 216. Note number 0 is the lowest C on the piano
	var mod: int = _button_num % SEVENTY_FIVE_INT
	var row: int = int(floor(float(_button_num) / SEVENTY_FIVE_FL))
	var oct: int = SEVEN_INT - row
	if mod >= SEVENTY_TWO_INT:
		mod -= SEVENTY_TWO_INT
		oct += 1
	var result: int = mod - 1 + ((oct + octave_shift) * SEVENTY_TWO_INT)
	return result

func note_num_to_button_num(note_num: int) -> int:
	if note_num - (octave_shift * SEVENTY_TWO_INT) == -1:
		return 525
	var row = 7 - int(floor(float((note_num - (octave_shift * SEVENTY_TWO_INT))) / 72.0))
	return (row * SEVENTY_FIVE_INT) + modulo(note_num, SEVENTY_TWO_INT) + 1

func active_note_num_to_button_num(_note_num: int) -> int:
	var button_num: int = note_num_to_button_num(_note_num)
	var mod_72: int = posmod(_note_num, SEVENTY_TWO_INT)
	if C_PITCH_CLASSES.has(mod_72):
		# Some kind of C. Need to figure out if the pressed button is on the right or left.
		var tri: Sprite = get_node("Triangle" + str(_note_num)\
			+ "_" + str(current_instrument))
		if tri.position.x >= screen_size.x / 2.0: # Right side C.
			if mod_72 == 0 || mod_72 == 1:
				button_num += 147
		else: # Left side C.
			if mod_72 == 71:
				button_num -= 147
	return button_num

func note_num_is_within_instrument_range(_note_num: int, _instrument: int):
	var inst_str: String = instrument_strings[_instrument]
	assert(instrument_data.has(inst_str))
	if _note_num >= instrument_data[inst_str]["lowest_sevtwo_number"] &&\
		_note_num <= instrument_data[inst_str]["highest_sevtwo_number"]:
			return true
	return false
	
func get_closest_point(_mouse_pos: Vector2) -> Array:
	# Returns closest point and its index in points array.
	# There are exactly 600 buttons. Is this the best way to do this?
	var closest_pt: Vector2 = points[0]
	var closest_idx: int = 0
	var closest_dist_sq: float = _mouse_pos.distance_squared_to(points[0])
	# Limit the number of points to check to the buttons in the row above thru the row below.
	var row: int = get_button_row(_mouse_pos)
	var low: int = (max(row - 1, 0) * 75) # first button of row above.
	var high: int = (min(row + 1, 7) * 75) + 74 # last button of row below.
	var dist_sq: float
	for i in range(low, high + 1):
		dist_sq = _mouse_pos.distance_squared_to(points[i])
		if dist_sq < closest_dist_sq:
			closest_dist_sq = dist_sq
			closest_pt = points[i]
			closest_idx = i
	return [closest_pt, closest_idx]

func update_debug_label() -> void:
	var label: Label = get_node("CanvasLayer/DebugLabel")
	var m: Vector2 = get_global_mouse_position()
	var m_screen: Vector2 = m - cam_pos
	var m_row: int = get_button_row(m)
	label.text = "mouse global pos: " + str(m)\
		+ "\nmouse screen pos: " + str(m - cam_pos)\
		+ "\ncamera pos: " + str(camera.position)\
		+ "\nmouse button: "+str(mouse_closest_button)\
		+ "\nmouse row: "+str(m_row)\
		+ "\nmouse button pos: "+str(points[mouse_closest_button])\
		+ "\nCA panel global pos: " + str(chord_analysis_panel.rect_global_position)\
		+ "\nCA panel pos: " + str(chord_analysis_panel.rect_position)\
		+ "\nCA scroll container row: " + str(ca_ivl_mouse_row)


func get_button_row(_global_pos: Vector2) -> int:
	var b_row: int = floor((_global_pos.y - tri_top_margin)\
		/ (tri_side_length * TRI_SIDE_LENGTH_TO_ROW_HEIGHT_RATIO))
	return int(clamp(b_row, 0, 7))

func update_closest_mouse_point_and_button():
	var arr: Array = get_closest_point(get_global_mouse_position())
	mouse_closest_point = arr[0]
	mouse_closest_button = arr[1]
	mouse_label.text = get_button_card_text(mouse_closest_button)
	update_debug_label()
	
	
func get_button_card_text(_button_num: int) -> String:
	var note_num: int = button_num_to_note_num(mouse_closest_button)
	var pitch: Pitch = pitches[note_num]
	var s: String =\
		"Note: " + str(pitch.sevtwo_note_num)+ " PC: " + str(pitch.sevtwo_pitch_class)\
		+ " Midi: " + str(pitch.midi_number)
	if not middle_c_is_c4:
		s = s + "\n" + pitch.get_title() + " " + pitch.get_freq_string()
	else:
		s = s + "\n" + pitch.get_title_c4() + " " + pitch.get_freq_string()
		
	return s
	


	
func mirror(_point_list: Array) -> Array:
	# Only used in the make_points() func for certain rows of the keyboard.
	var new_point_list: Array
	for i in range(_point_list.size()):
		var new_point: Vector2 = Vector2(_point_list[i].x, _point_list[5-i].y)
		new_point_list.append(new_point)
	return new_point_list

func make_points() -> void:
	var sqrt3: float = sqrt(3.0)
	var a: float = sqrt3
	var b: float = sqrt3 / 3.0
	var c: float = (2.0 * sqrt3) / 3.0
	var d: float = (2.0 * sqrt3) / 9.0
	var t: float = (5.0 * sqrt3) / 9.0
	var u: float = (8.0 * sqrt3) / 9.0
	var v: float = 1.0 / 3.0
	var w: float = 2.0 / 3.0
	var x: float = (4.0 * sqrt3) / 9.0
	var y: float = 4.0 / 3.0
	var z: float = sqrt3 / 9.0
	
	var sz: float = tri_side_length * 0.5
	
	var pt_0: Vector2 = Vector2(sz * w, sz * t)
	var pt_1: Vector2 = Vector2(sz * 1.0, sz * u)
	var pt_2: Vector2 = Vector2(sz * y, sz * t)
	var pt_3: Vector2 = Vector2(sz * (1.0 + w), sz * x)
	var pt_4: Vector2 = Vector2(sz * 2.0, sz * z)
	var pt_5: Vector2 = Vector2(sz * (2.0 + v), sz * x)
	point_list = [pt_0, pt_1, pt_2, pt_3, pt_4, pt_5]
	var mirror_point_list = mirror(point_list)
	var row_height: float = (tri_side_length / 2.0) * sqrt3
	var row_points: Array
	var mirror_row_points: Array
	for i in range(13): # 13 midi notes per row (octave plus one extra)
		var st: Vector2 = Vector2((i * tri_side_length), 0)
		for j in range(point_list.size()):
			if i != 12:
				var pt: Vector2 = point_list[j]
				var mirror_pt: Vector2 = mirror_point_list[j]
				var pt_dup: Vector2 = Vector2(st.x + pt.x, st.y + pt.y)
				var mirror_pt_dup: Vector2 = Vector2(st.x + mirror_pt.x, st.y + mirror_pt.y)
				row_points.append(pt_dup)
				mirror_row_points.append(mirror_pt_dup)
			else:
				if j < 3:
					var pt: Vector2 = point_list[j]
					var mirror_pt: Vector2 = mirror_point_list[j]
					var pt_dup: Vector2 = Vector2(st.x + pt.x, st.y + pt.y)
					var mirror_pt_dup: Vector2 = Vector2(st.x + mirror_pt.x, st.y + mirror_pt.y)
					row_points.append(pt_dup)
					mirror_row_points.append(mirror_pt_dup)
					
	for i in range(8): # 8 rows of keys
		var row_offset: Vector2 = row_offsets[i]
		var plist: Array = row_points
		if i % 2 == 1: # Odd numbered row? Use the mirrored points
			plist = mirror_row_points
		
		# Finally, make the list.
		for j in range(plist.size()):
			var point: Vector2 = Vector2(point_offset.x + plist[j].x,\
				point_offset.y + (i * row_height) + plist[j].y + row_offset.y)
			points.append(point)
			
func make_pitches() -> void:
	for i in range(points.size()):
		var note_num: int = button_num_to_note_num(i)
		var pitch: Pitch = Pitch.new()
		pitch.sevtwo_note_num = note_num # The setter in Pitch will figure out freq, etc.
		pitches[note_num] = pitch

func initialize_audio_note_paths() -> void:
	audio_note_paths.clear()
	var p: Pitch = Pitch.new("C0 +0")
	for inst in instrument_data:
		audio_note_paths[inst] = {}
		audio_note_paths_sevtwo[inst] = {}
		var low_st: int = instrument_data[inst]["lowest_sevtwo_number"]
		var high_st: int = instrument_data[inst]["highest_sevtwo_number"]
		var n: int = low_st
		
		while n <= high_st:
			p.sevtwo_note_num = n
			var path: String = get_audio_file_path(inst, p)
			if n % 6 == 0:
				audio_note_paths[inst][p.midi_number] = path
			audio_note_paths_sevtwo[inst][n] = path
			n += 1

func get_audio_file_path(_inst_str: String, _pitch: Pitch) -> String:
	# By now we should've confirmed that this note is within the instrument's range
	# and that there is an audio file for it.
	var folder: String = instrument_data[_inst_str]["path"]
	var file_name: String = instrument_data[_inst_str]["format"]
	for v in AUDIO_FORMAT_VARIABLES:
		file_name = file_name.replace("$"+v+"$", str(_pitch.get(v)))
	return file_name
	
func get_audio_file_path_quick(_note_num: int, _inst_str: String) -> String:
	# Path must be in audio_note_paths_sevtwo from initialize_audio_note_paths for this to work.
	var folder: String = instrument_data[_inst_str]["path"]
	return folder + audio_note_paths_sevtwo[_inst_str][_note_num]
	
func initialize_audio_stream_players() -> void:
	for i in range(max_num_of_pitches):
		var asp: AudioStreamPlayer = AudioStreamPlayer.new()
		asp.name = "AudioStreamPlayer"+str(i)
		audio_stream_players.add_child(asp)

func start_tri_glow_tween():
	tri_glow_tween.interpolate_property(self, "tri_glow", tri_glow_min_max[0], tri_glow_min_max[1], tri_glow_duration,\
		Tween.TRANS_SINE, Tween.EASE_IN)
	tri_glow_tween.start()
	

func _on_TriGlowTween_tween_completed(object, key):
	tri_glow_min_max.invert()
	start_tri_glow_tween()

var dragging_enabled: bool = true
var is_dragging: bool = false
var drag_pos: Vector2
var panel_being_dragged: PanelContainer

func _on_GrandStaffPanelContainer_gui_input(event):
	if not is_dragging:
		panel_being_dragged = grand_staff_panel
		var m: Vector2 = get_global_mouse_position()
		var r: Vector2 = panel_being_dragged.rect_global_position
		var l: Vector2 = m - r
		drag_event(event)
	else:
		drag_event(event)
		
func _on_SettingsPanelContainer_gui_input(event):
	if not is_dragging:
		panel_being_dragged = settings_panel
		var m: Vector2 = get_global_mouse_position()
		var r: Vector2 = panel_being_dragged.rect_global_position
		var l: Vector2 = m - r
		drag_event(event)
	else:
		drag_event(event)

func _on_ChordAnalysisPanelContainer_gui_input(event):
	if not is_dragging:
		panel_being_dragged = chord_analysis_panel
		var m: Vector2 = get_global_mouse_position()
		var r: Vector2 = panel_being_dragged.rect_global_position
		var l: Vector2 = m - r
		drag_event(event)
	else:
		drag_event(event)
		

func _on_TransformPanel_gui_input(event):
	if not is_dragging:
		panel_being_dragged = transform_panel
		var m: Vector2 = get_global_mouse_position()
		var r: Vector2 = panel_being_dragged.rect_global_position
		var l: Vector2 = m - r
		drag_event(event)
	else:
		drag_event(event)

func _on_HelpPanelContainer_gui_input(event):
	if not is_dragging:
		panel_being_dragged = help_panel
		var m: Vector2 = get_global_mouse_position()
		var r: Vector2 = panel_being_dragged.rect_global_position
		var l: Vector2 = m - r
		drag_event(event)
	else:
		drag_event(event)


func drag_event(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1: # left click
			if event.is_pressed():
				# Start dragging.
				drag_pos = get_global_mouse_position()\
					- panel_being_dragged.rect_global_position
				is_dragging = true
					
			else: # release
				# Stop dragging.
				is_dragging = false
	if event is InputEventMouseMotion:
		if is_dragging && dragging_enabled:
			panel_being_dragged.rect_global_position = get_global_mouse_position() - drag_pos
	get_tree().set_input_as_handled()


func _on_SettingsButton_toggled(_button_pressed: bool) -> void:
	if forcing_control_value:
		return
	if not important_panel_is_open:
		if not settings_panel_is_open:
			open_settings_panel()
		else:
			close_settings_panel()
	else:
		forcing_control_value = true
		settings_button.pressed = !_button_pressed
		forcing_control_value = false
	settings_button.release_focus()
	

func _on_MiddleC4CheckButton_pressed():
	if forcing_control_value:
		return
	var a440_heading_label: Label = get_node("CanvasLayer/SettingsPanelContainer/VBoxContainer/HBoxContainer7/TuningHeadingLabel")
	var check_button: CheckBox = get_node("CanvasLayer/SettingsPanelContainer/VBoxContainer/MiddleC4CheckButton")
	middle_c_is_c4 = check_button.pressed
	if middle_c_is_c4:
		a440_heading_label.text = "A4 frequency: "
	else:
		a440_heading_label.text = "A3 frequency: "
	ca_update_chord_analysis_window(current_pitch_set)
	if transform_panel.visible:
		forcing_control_value = true
		trans_invert_axis_a_pitch_line_edit.middle_c_is_c4 = middle_c_is_c4
		trans_invert_axis_b_pitch_line_edit.middle_c_is_c4 = middle_c_is_c4
		trans_invert_map_a_pitch_line_edit.middle_c_is_c4 = middle_c_is_c4
		trans_invert_map_b_pitch_line_edit.middle_c_is_c4 = middle_c_is_c4
		trans_random_range_low_pitch_line_edit.middle_c_is_c4 = middle_c_is_c4
		trans_random_range_high_pitch_line_edit.middle_c_is_c4 = middle_c_is_c4
		trans_norm_dist_mean_pitch_line_edit.middle_c_is_c4 = middle_c_is_c4
		forcing_control_value = false
		trans_update()


	



func _on_GSScaleLineEdit_text_entered(new_text: String) -> void:
	if forcing_control_value:
		return
	var f: float = float(new_text)
	f = clamp(stepify(f, 0.01), 0.25, 2.0)
	var line_edit: LineEdit = get_node("CanvasLayer/SettingsPanelContainer/VBoxContainer/HBoxContainer2/GSScaleLineEdit")
	forcing_control_value = true
	line_edit.text = "%.2f" % f
	forcing_control_value = false
	grand_staff_panel.rect_scale.x = f
	grand_staff_panel.rect_scale.y = f

func _on_CameraSpeedLineEdit_text_entered(_new_text: String) -> void:
	if forcing_control_value:
		return
	cam_move_speed = max(float(_new_text), 4.0)
	var line_edit: LineEdit = get_node("CanvasLayer/SettingsPanelContainer/VBoxContainer/HBoxContainer10/HBoxContainer/CameraSpeedLineEdit")
	forcing_control_value = true
	line_edit.text = "%.2f" % cam_move_speed
	forcing_control_value = false


func open_settings_panel() -> void:
	assert(not settings_panel_is_open)
	settings_panel.visible = true
	settings_panel_is_open = true
	
	forcing_control_value = true
	settings_button.pressed = true
	forcing_control_value = false
	
func close_settings_panel() -> void:
	assert(settings_panel_is_open)
	
	forcing_control_value = true
	settings_button.pressed = false
	forcing_control_value = false
	
	settings_panel.visible = false
	settings_panel_is_open = false

	
func _on_Settings_CloseButton_pressed():
	if not important_panel_is_open:
		close_settings_panel()


func ca_get_freq_ratio_error_label_color(_error: float) -> Color:
	var f: float = abs(_error) / 50.0
	var col: Color = Color(1.0, 1.0 - f, 1.0 - f)
	return col


func _on_SharpsCheckButton_pressed():
	var check_button: CheckBox = get_node("CanvasLayer/SettingsPanelContainer/VBoxContainer/SharpsCheckButton")
	grand_staff.prefer_sharps = check_button.pressed
	if grand_staff.prefer_sharps:
		for note_num in pitches:
			pitches[note_num].enharmonic = Pitch.Enharm.SHARP
	else:
		for note_num in pitches:
			pitches[note_num].enharmonic = Pitch.Enharm.FLAT
	ca_update_chord_analysis_window(current_pitch_set)

func _on_NotationButton_toggled(_button_pressed: bool) -> void:
	if forcing_control_value:
		return
	if not important_panel_is_open:
		grand_staff_panel.visible = _button_pressed
	else:
		forcing_control_value = true
		notation_button.pressed = !_button_pressed
		forcing_control_value = false
	notation_button.release_focus()

func _on_AnalysisButton_toggled(_button_pressed: bool) -> void:
	if forcing_control_value:
		return
	if not important_panel_is_open:
		chord_analysis_panel.visible = _button_pressed
	else:
		forcing_control_value = true
		chord_analysis_button.pressed = !_button_pressed
		forcing_control_value = false
	chord_analysis_button.release_focus()

func _on_ChordAnalysisCloseButton_pressed():
	if not important_panel_is_open:
		chord_analysis_panel.visible = false
		forcing_control_value = true
		chord_analysis_button.pressed = false
		forcing_control_value = false


func ca_set_ivl_dist_text(_label: Label, _ivl: Interval) -> void:
	var dist_s: String
	match ivl_distance_format:
		IvlDistanceFormat.DOTS:
			var remaining_ts: int = _ivl.sevtwo - ((_ivl.octaves * 72) + (_ivl.halfsteps * 6))
			dist_s = str(_ivl.octaves) + "." + str(_ivl.halfsteps) + "." + str(remaining_ts)
		IvlDistanceFormat.DOTS_CENTS:
			dist_s = str(_ivl.octaves) + "." + str(_ivl.halfsteps) + "." + str(_ivl.cents)
		IvlDistanceFormat.OCT_HS_C:
			var c_s: String = "%02d" % int(stepify(_ivl.cents, 0.01) * 100.0)
			if half_step_name == HalfStepName.HALF_STEP:
				dist_s = str(_ivl.octaves) + "oct " + str(_ivl.halfsteps) + "hs " + c_s + "c"
			elif half_step_name == HalfStepName.HALF_TONE:
				dist_s = str(_ivl.octaves) + "oct " + str(_ivl.halfsteps) + "ht " + c_s + "c"
			elif half_step_name == HalfStepName.SEMI_TONE:
				dist_s = str(_ivl.octaves) + "oct " + str(_ivl.halfsteps) + "st " + c_s + "c"
		IvlDistanceFormat.OCT_HS_TS:
			var remaining_ts: int = _ivl.sevtwo - ((_ivl.octaves * 72) + (_ivl.halfsteps * 6))
			if half_step_name == HalfStepName.HALF_STEP:
				dist_s = str(_ivl.octaves) + "oct " + str(_ivl.halfsteps) + "hs " + str(remaining_ts) + "ts"
			elif half_step_name == HalfStepName.HALF_TONE:
				dist_s = str(_ivl.octaves) + "oct " + str(_ivl.halfsteps) + "ht " + str(remaining_ts) + "tt"
			elif half_step_name == HalfStepName.SEMI_TONE:
				dist_s = str(_ivl.octaves) + "oct " + str(_ivl.halfsteps) + "st " + str(remaining_ts) + "tt"
		IvlDistanceFormat.OC_HS_C:
			var c_s: String = "%02d" % int(stepify(_ivl.cents, 0.01) * 100.0)
			if half_step_name == HalfStepName.HALF_STEP:
				dist_s = str(_ivl.octaves) + "oc " + str(_ivl.halfsteps) + "hs " + c_s + "c"
			elif half_step_name == HalfStepName.HALF_TONE:
				dist_s = str(_ivl.octaves) + "oc " + str(_ivl.halfsteps) + "ht " + c_s + "c"
			elif half_step_name == HalfStepName.SEMI_TONE:
				dist_s = str(_ivl.octaves) + "oc " + str(_ivl.halfsteps) + "st " + c_s + "c"
		IvlDistanceFormat.OC_HS_TS:
			var remaining_ts: int = _ivl.sevtwo - ((_ivl.octaves * 72) + (_ivl.halfsteps * 6))
			if half_step_name == HalfStepName.HALF_STEP:
				dist_s = str(_ivl.octaves) + "oc " + str(_ivl.halfsteps) + "hs " + str(remaining_ts) + "ts"
			elif half_step_name == HalfStepName.HALF_TONE:
				dist_s = str(_ivl.octaves) + "oc " + str(_ivl.halfsteps) + "ht " + str(remaining_ts) + "tt"
			elif half_step_name == HalfStepName.SEMI_TONE:
				dist_s = str(_ivl.octaves) + "oc " + str(_ivl.halfsteps) + "st " + str(remaining_ts) + "tt"
		IvlDistanceFormat.O_H_C:
			var c_s: String = "%02d" % int(stepify(_ivl.cents, 0.01) * 100.0)
			if half_step_name == HalfStepName.HALF_STEP:
				dist_s = str(_ivl.octaves) + "o " + str(_ivl.halfsteps) + "h " + c_s + "c"
			elif half_step_name == HalfStepName.HALF_TONE:
				dist_s = str(_ivl.octaves) + "o " + str(_ivl.halfsteps) + "h " + c_s + "c"
			elif half_step_name == HalfStepName.SEMI_TONE:
				dist_s = str(_ivl.octaves) + "o " + str(_ivl.halfsteps) + "s " + c_s + "c"
		IvlDistanceFormat.O_H_T:
			var remaining_ts: int = _ivl.sevtwo - ((_ivl.octaves * 72) + (_ivl.halfsteps * 6))
			if half_step_name == HalfStepName.HALF_STEP:
				dist_s = str(_ivl.octaves) + "o " + str(_ivl.halfsteps) + "h " + str(remaining_ts) + "t"
			elif half_step_name == HalfStepName.HALF_TONE:
				dist_s = str(_ivl.octaves) + "o " + str(_ivl.halfsteps) + "h " + str(remaining_ts) + "t"
			elif half_step_name == HalfStepName.SEMI_TONE:
				dist_s = str(_ivl.octaves) + "o " + str(_ivl.halfsteps) + "s " + str(remaining_ts) + "t"
		IvlDistanceFormat.V_H_C:
			var c_s: String = "%02d" % int(stepify(_ivl.cents, 0.01) * 100.0)
			if half_step_name == HalfStepName.HALF_STEP:
				dist_s = str(_ivl.octaves) + "v " + str(_ivl.halfsteps) + "h " + c_s + "c"
			elif half_step_name == HalfStepName.HALF_TONE:
				dist_s = str(_ivl.octaves) + "v " + str(_ivl.halfsteps) + "h " + c_s + "c"
			elif half_step_name == HalfStepName.SEMI_TONE:
				dist_s = str(_ivl.octaves) + "v " + str(_ivl.halfsteps) + "s " + c_s + "c"
		IvlDistanceFormat.V_H_T:
			var remaining_ts: int = _ivl.sevtwo - ((_ivl.octaves * 72) + (_ivl.halfsteps * 6))
			if half_step_name == HalfStepName.HALF_STEP:
				dist_s = str(_ivl.octaves) + "v " + str(_ivl.halfsteps) + "h " + str(remaining_ts) + "t"
			elif half_step_name == HalfStepName.HALF_TONE:
				dist_s = str(_ivl.octaves) + "v " + str(_ivl.halfsteps) + "h " + str(remaining_ts) + "t"
			elif half_step_name == HalfStepName.SEMI_TONE:
				dist_s = str(_ivl.octaves) + "v " + str(_ivl.halfsteps) + "s " + str(remaining_ts) + "t"
	_label.text = dist_s

func ca_set_first_ivl_row_visible(_visible: bool) -> void:
	ca_ivl_pitch_a_vbox.get_node("PitchALabel0").visible = _visible
	ca_ivl_pitch_b_vbox.get_node("PitchBLabel0").visible = _visible
	ca_ivl_freq_ratio_vbox.get_node("FreqRatioLineEdit0").visible = _visible
	ca_ivl_freq_ratio_error_vbox.get_node("FreqRatioErrorLabel0").visible = _visible
	ca_ivl_dist_vbox.get_node("DistanceLabel0").visible = _visible
	ca_ivl_total_12th_steps_vbox.get_node("TotalTwelfthStepsLineEdit0").visible = _visible
	ca_ivl_pitch_lock_vbox.get_node("PitchLockOptionButton0").visible = _visible
	ca_ivl_interval_lock_vbox.get_node("IntervalLockOptionButton0").visible = _visible



func ca_update_interval_row(_row: int, _pitch_a: Pitch, _pitch_b: Pitch, _pitch_set: PitchSet) -> void:
	var ivl_idx: int = _pitch_set.get_interval_idx(_pitch_a, _pitch_b)
	var ivl: Interval = _pitch_set.intervals[ivl_idx]
	var a_label: Label = ca_ivl_pitch_a_vbox.get_node("PitchALabel"+str(_row))
	var b_label: Label = ca_ivl_pitch_b_vbox.get_node("PitchBLabel"+str(_row))
	var freq_ratio_line_edit: LineEdit = ca_ivl_freq_ratio_vbox.get_node("FreqRatioLineEdit"+str(_row))
	var freq_ratio_error_label: Label = ca_ivl_freq_ratio_error_vbox.get_node("FreqRatioErrorLabel"+str(_row))
	var distance_label: Label = ca_ivl_dist_vbox.get_node("DistanceLabel"+str(_row))
	var twelfth_steps_line_edit: LineEdit = ca_ivl_total_12th_steps_vbox.get_node("TotalTwelfthStepsLineEdit"+str(_row))
	var pitch_lock_option_button: OptionButton = ca_ivl_pitch_lock_vbox.get_node("PitchLockOptionButton"+str(_row))
	var interval_lock_option_button: OptionButton = ca_ivl_interval_lock_vbox.get_node("IntervalLockOptionButton"+str(_row))
	
	if not middle_c_is_c4:
		a_label.text = ivl.pitch_a.title
		b_label.text = ivl.pitch_b.title
	else:
		a_label.text = ivl.pitch_a.get_title_c4()
		b_label.text = ivl.pitch_b.get_title_c4()
	forcing_control_value = true
	freq_ratio_line_edit.text = str(ivl.ratio_n)+"/"+str(ivl.ratio_d)
	forcing_control_value = false
	
	if not freq_ratio_line_edit.is_connected("text_entered", self, "_on_FreqRatioLineEdit_text_entered"):
		freq_ratio_line_edit.connect("text_entered", self, "_on_FreqRatioLineEdit_text_entered", [freq_ratio_line_edit, _row])
		pitch_lock_option_button.connect("item_selected", self, "_on_PitchLockOptionButton_item_selected", [_row])
		interval_lock_option_button.connect("item_selected", self, "_on_IntervalLockOptionButton_item_selected", [_row])
		twelfth_steps_line_edit.connect("text_entered", self, "_on_TotalTwelfthStepsLineEdit_text_entered", [twelfth_steps_line_edit, _row])
	ca_ivl_row_map[_row] = ivl
	
	if ivl.ratio_cent_error >= 0.0:
		freq_ratio_error_label.text = "+%.2f" % ivl.ratio_cent_error
	else:
		freq_ratio_error_label.text = "%.2f" % ivl.ratio_cent_error
	freq_ratio_error_label.text += "c"
	freq_ratio_error_label.add_color_override("font_color", ca_get_freq_ratio_error_label_color(ivl.ratio_cent_error))
	forcing_control_value = true
	twelfth_steps_line_edit.text = str(ivl.sevtwo)
	forcing_control_value = false
	ca_set_ivl_dist_text(distance_label, ivl)


	
func _on_PitchSet_pitch_set_changed(_pitch_set: PitchSet) -> void:
	ca_update_chord_analysis_window(_pitch_set)
	if transform_panel.visible:
		if transformation == Transformation.RANDOMIZE:
			forcing_control_value = true
			if trans_random_type == TransRandomType.PITCH:
				trans_random_num_of_elements_line_edit.text = str(_pitch_set.pitches.size())
			elif trans_random_type == TransRandomType.PITCH_CLASS:
				trans_random_num_of_elements_line_edit.text = str(_pitch_set.prime_form.size())
			forcing_control_value = false
		trans_update()
	


func ca_update_chord_analysis_window(_pitch_set: PitchSet) -> void:
	var pitches_s: String
	var freqs_s: String
	var note_nums_s: String
	var pcs_s: String
	var pitch_strings: Array
	var s: String
	for i in range(_pitch_set.pitches.size()):
		var pitch: Pitch = _pitch_set.pitches[i]
		if not middle_c_is_c4:
			s = pitch.title
		else:
			s = pitch.get_title_c4()
		pitches_s += s
		pitch_strings.push_back(s)
		freqs_s += str(stepify(pitch.freq, 0.001))
		note_nums_s += str(pitch.sevtwo_note_num)
		if i < _pitch_set.pitches.size() - 1: # If not last element.
			pitches_s += ", "
			freqs_s += ", "
			note_nums_s += ", "
	
	for i in range(_pitch_set.pc_set.size()):
		pcs_s += str(_pitch_set.pc_set[i])
		if i < _pitch_set.pc_set.size() - 1: # If not last element.
			pcs_s += ", "
	var normal_form_s: String
	var prime_form_s: String
	for i in range(_pitch_set.normal_form.size()):
		normal_form_s += str(_pitch_set.normal_form[i])
		prime_form_s += str(_pitch_set.prime_form[i])
		if i != _pitch_set.normal_form.size() - 1: # If not last element.
			normal_form_s += ", "
			prime_form_s += ", "
	var note_num_differences_s: String
	var diff: int
	for i in range(_pitch_set.note_numbers.size() - 1):
		diff = _pitch_set.note_numbers[(i + 1)] - _pitch_set.note_numbers[i]
		note_num_differences_s += str(diff)
		if i != _pitch_set.note_numbers.size() - 2:
			note_num_differences_s += ", "
	var nf_note_num_differences_s: String
	var a: int
	var b: int
	
	for i in range(_pitch_set.normal_form.size()):
		a = _pitch_set.normal_form[i]
		b = _pitch_set.normal_form[(i + 1) % _pitch_set.normal_form.size()]
		diff = b - a
		while diff < 0:
			diff += SEVENTY_TWO_INT # Wrap up an octave.
		if i != _pitch_set.normal_form.size() - 1: # If not last element.
			nf_note_num_differences_s += str(diff) + ", "
		else:
			nf_note_num_differences_s += "(" +str(diff) + ")" # Show the wrapped interval in parenthesis.
	var interval_vector_s: String
	for i in range(_pitch_set.interval_vector.size()):
		interval_vector_s += str(_pitch_set.interval_vector[i])
		if i != _pitch_set.interval_vector.size() - 1:
			interval_vector_s += ", "
	forcing_control_value = true
	ca_pitches_text_edit.text = pitches_s
	ca_frequencies_text_edit.text = freqs_s
	ca_note_numbers_text_edit.text = note_nums_s
	ca_pitch_classes_label.text = pcs_s
	ca_normal_form_heading.text = "Normal form (" + _pitch_set.transposition_index_string + "): "
	ca_normal_form_label.text = normal_form_s
	ca_prime_form_label.text = prime_form_s
	ca_number_of_pitches_label.text = str(_pitch_set.pitches.size())
	ca_number_of_pitch_classes_label.text = str(_pitch_set.normal_form.size())
	ca_12th_step_intervals_label.text = note_num_differences_s
	ca_normal_form_12th_step_intervals_label.text = nf_note_num_differences_s
	ca_interval_vector_label.text = interval_vector_s
	forcing_control_value = false
	if _pitch_set.last_note_numbers.size() != _pitch_set.note_numbers.size():
		# The number of notes has changed.
		ca_update_number_of_interval_rows(_pitch_set)
	ca_update_interval_rows(_pitch_set)

func ca_update_number_of_interval_rows(_pitch_set: PitchSet) -> void:
	var current_number_of_interval_rows: int = ca_ivl_pitch_a_vbox.get_child_count()
	if not ca_ivl_pitch_a_vbox.get_node("PitchALabel0").visible:
		current_number_of_interval_rows -= 1 # The first row is never removed, only made invisible.
	var new_number_of_pitches: int = _pitch_set.pitches.size()
	var new_number_of_interval_rows: int
	if default_interval_display_method != DefaultIntervalsToDisplay.ALL:
		new_number_of_interval_rows = new_number_of_pitches - 1
	else:
		new_number_of_interval_rows = ((new_number_of_pitches - 1) * new_number_of_pitches) / 2
	if new_number_of_interval_rows > current_number_of_interval_rows:
		# Need to make more interval rows.
		for i in range(current_number_of_interval_rows, new_number_of_interval_rows):
			ca_add_interval_row()
	elif new_number_of_interval_rows < current_number_of_interval_rows:
		# Need to remove ivl rows.
		if new_number_of_pitches <= 1:
			# For there to be an interval, there need to be at least 2 pitches in the pitch_set.
			# Remove all interval rows.
			for i in range(current_number_of_interval_rows):
				ca_remove_interval_row(current_number_of_interval_rows - 1 - i) # Remove from the bottom up.
		else:
			for i in range(current_number_of_interval_rows - new_number_of_interval_rows):
				ca_remove_interval_row(current_number_of_interval_rows - 1 - i) # Remove from the bottom up.

func ca_update_interval_rows(_pitch_set: PitchSet) -> void:
	# This assumes the number of interval rows is correct.
	# Pitches in the pitch set are always sorted from lowest to highest.
	if _pitch_set.pitches.size() <= 1: # Need at least 2 pitches to have an interval.
		return
	forcing_control_value = true
	ca_ivl_row_map.clear()
	if default_interval_display_method == DefaultIntervalsToDisplay.ALL:
		for i in range(_pitch_set.intervals.size()):
			var ivl: Interval = _pitch_set.intervals[i]
			ca_update_interval_row(i, ivl.pitch_a, ivl.pitch_b, _pitch_set)
	elif default_interval_display_method == DefaultIntervalsToDisplay.FROM_LAST:
		for i in range(1, _pitch_set.pitches.size()):
			var last_pitch: Pitch = _pitch_set.pitches[i - 1]
			var this_pitch: Pitch = _pitch_set.pitches[i]
			ca_update_interval_row(i - 1, last_pitch, this_pitch, _pitch_set)
	elif default_interval_display_method == DefaultIntervalsToDisplay.FROM_LOWEST:
		var lowest_pitch: Pitch = _pitch_set.pitches[0]
		for i in range(1, _pitch_set.pitches.size()):
			var this_pitch: Pitch = _pitch_set.pitches[i]
			ca_update_interval_row(i - 1, lowest_pitch, this_pitch, _pitch_set)
	elif default_interval_display_method == DefaultIntervalsToDisplay.TO_TOP:
		var highest_pitch: Pitch = _pitch_set.pitches[_pitch_set.pitches.size() - 1]
		for i in range(_pitch_set.pitches.size() - 1):
			var this_pitch: Pitch = _pitch_set.pitches[i]
			ca_update_interval_row(i, this_pitch, highest_pitch, _pitch_set)
	forcing_control_value = false
	
func _on_Interval_pulse(_ivl: Interval, _direction: int, _pitch_set: PitchSet) -> void:
	# An interval can change in many ways.
	# B is the higher pitch, A is the lower pitch.
	# Pitch A changes, 
	#### TODO: May use this in later version.
	pass



func _on_TotalTwelfthStepsLineEdit_text_entered(_new_text: String, _twelfth_steps_line_edit: LineEdit,\
	_row: int) -> void:
	if forcing_control_value:
		return
	var contains_number: bool = false
	for c in _new_text:
		if Pitch.NUMBERS.has(c):
			contains_number = true
			break
	var ivl: Interval = ca_ivl_row_map[_row]
	if not contains_number:
		forcing_control_value = true
		_twelfth_steps_line_edit.text = str(ivl.sevtwo)
		forcing_control_value = false
		return
	# Got here? A valid number was passed.
	var ts: int = int(_new_text)
	var new_pitch: Pitch = Pitch.new()
	var note_num_to_remove: int = -10000
	var note_num_to_add: int = -10000
	if ivl.interval_lock_mode == ivl.IntervalLockMode.LOCK_A:
		# A stays, B changes.
		note_num_to_remove = ivl.pitch_b.sevtwo_note_num
		new_pitch.sevtwo_note_num = ivl.pitch_a.sevtwo_note_num + ts # Setter will bound the new pitch.
	elif ivl.interval_lock_mode == ivl.IntervalLockMode.LOCK_B:
		# B stays, A changes.
		note_num_to_remove = ivl.pitch_b.sevtwo_note_num
		new_pitch.sevtwo_note_num = ivl.pitch_b.sevtwo_note_num - ts # Setter will bound the new pitch.
	if not current_pitch_set.note_numbers.has(new_pitch.sevtwo_note_num):
		note_num_to_add = new_pitch.sevtwo_note_num
	if note_num_to_remove != -10000:
		var r_mod_72: int = posmod(note_num_to_remove, SEVENTY_TWO_INT)
		click_button(active_note_num_to_button_num(note_num_to_remove), current_instrument, false)
	if note_num_to_add != -10000:
		click_button(note_num_to_button_num(note_num_to_add), current_instrument, true)
	if _twelfth_steps_line_edit != null:
		drop_control_focus(_twelfth_steps_line_edit)
	ca_update_ca_ivl_mouse_row()
	update()


	
func _on_FreqRatioLineEdit_text_entered(_new_text: String, _freq_ratio_line_edit: LineEdit,\
	_row: int) -> void:
	if forcing_control_value:
		return
	var ivl: Interval = ca_ivl_row_map[_row]
	var slash_idx: int = _new_text.find("/")
	if slash_idx != -1:
		var n: int = int(_new_text.left(slash_idx))
		var d: int = int(_new_text.right(slash_idx + 1))
		if n <= d || d <= 0 || d > current_pitch_set.intervals[0].max_denominator:
			# User is being cheeky and trying to divide by 0, or they're putting\
			# the smaller number as the numerator.
			forcing_control_value = true
			_freq_ratio_line_edit.text = str(ivl.ratio_n)+"/"+str(ivl.ratio_d)
			forcing_control_value = false
			drop_control_focus(_freq_ratio_line_edit)
			return
		# Got here? The entered ratio is valid.
		var new_pitch: Pitch = Pitch.new()
		var note_num_to_remove: int = -10000
		var note_num_to_add: int = -10000
		
		if ivl.interval_lock_mode == ivl.IntervalLockMode.LOCK_A:
			# A stays and B changes.
			var rat: float = float(n) / float(d)
			# New pitch will be new pitch B.
			new_pitch.freq = ivl.pitch_a.freq * rat
			new_pitch.sevtwo_note_num = new_pitch.sevtwo_note_num # Setter rounds the new pitch to nearest 12th tone.
			# Remove old pitch B
			note_num_to_remove = ivl.pitch_b.sevtwo_note_num
#			new_note_numbers.remove(new_note_numbers.find(ivl.pitch_b.sevtwo_note_num))
		elif ivl.interval_lock_mode == ivl.IntervalLockMode.LOCK_B:
			# B stays and A changes.
			var recip: float = float(d) / float(n)
			# New pitch will be new pitch A.
			new_pitch.freq = ivl.pitch_b.freq * recip
			new_pitch.sevtwo_note_num = new_pitch.sevtwo_note_num # Setter rounds the new pitch to nearest 12th tone.
			# Remove old pitch A
			note_num_to_remove = ivl.pitch_a.sevtwo_note_num
#			new_note_numbers.remove(new_note_numbers.find(ivl.pitch_a.sevtwo_note_num))
		# Did the old pitch change into a pitch that's already in the pitch set?
		if not current_pitch_set.note_numbers.has(new_pitch.sevtwo_note_num):
			# No, it didn't.
			# We DO add the new pitch A.
			note_num_to_add = new_pitch.sevtwo_note_num
#		print("note num to add: ", note_num_to_add)
#		print("note num to remove: ", note_num_to_remove)
		if note_num_to_remove != -10000:
			click_button(active_note_num_to_button_num(note_num_to_remove), current_instrument, false)
		if note_num_to_add != -10000:
			click_button(note_num_to_button_num(note_num_to_add), current_instrument, true)
		if _freq_ratio_line_edit != null:
			drop_control_focus(_freq_ratio_line_edit)
		ca_update_ca_ivl_mouse_row()
		update()
	else:
		# No slash was in string.
		forcing_control_value = true
		_freq_ratio_line_edit.text = str(ivl.ratio_n)+"/"+str(ivl.ratio_d)
		forcing_control_value = false

	drop_control_focus(_freq_ratio_line_edit)
	
func _on_PitchLockOptionButton_item_selected(_index: int, _row: int):
	if forcing_control_value:
		return


func _on_IntervalLockOptionButton_item_selected(_index: int, _row: int):
	if forcing_control_value:
		return

func ca_add_interval_row() -> void:
	if not ca_ivl_pitch_a_vbox.get_node("PitchALabel0").visible:
		# There are currently "0" intervals listed. Because the first row is
		# never removed, but instead set invisible, we can just show it here
		# instead of adding all these new control nodes.
		ca_set_first_ivl_row_visible(true)
		return
	var idx: int = ca_ivl_pitch_a_vbox.get_child_count()
	
	var new_a: Label = ca_ivl_pitch_a_vbox.get_node("PitchALabel0").duplicate()
	var new_b: Label = ca_ivl_pitch_b_vbox.get_node("PitchBLabel0").duplicate()
	var new_freq_ratio: LineEdit = ca_ivl_freq_ratio_vbox.get_node("FreqRatioLineEdit0").duplicate()
	var new_freq_ratio_error: Label = ca_ivl_freq_ratio_error_vbox.get_node("FreqRatioErrorLabel0").duplicate()
	var new_distance: Label = ca_ivl_dist_vbox.get_node("DistanceLabel0").duplicate()
	var new_12th_steps: LineEdit = ca_ivl_total_12th_steps_vbox.get_node("TotalTwelfthStepsLineEdit0").duplicate()
	var new_pitch_lock: OptionButton = ca_ivl_pitch_lock_vbox.get_node("PitchLockOptionButton0").duplicate()
	var new_interval_lock: OptionButton = ca_ivl_interval_lock_vbox.get_node("IntervalLockOptionButton0").duplicate()
	
	new_a.name = "PitchALabel"+str(idx)
	new_b.name = "PitchBLabel"+str(idx)
	new_freq_ratio.name = "FreqRatioLineEdit"+str(idx)
	new_freq_ratio_error.name = "FreqRatioErrorLabel"+str(idx)
	new_distance.name = "DistanceLabel"+str(idx)
	new_12th_steps.name = "TotalTwelfthStepsLineEdit"+str(idx)
	new_pitch_lock.name = "PitchLockOptionButton"+str(idx)
	new_interval_lock.name = "IntervalLockOptionButton"+str(idx)
	ca_ivl_pitch_a_vbox.add_child(new_a)
	ca_ivl_pitch_b_vbox.add_child(new_b)
	ca_ivl_freq_ratio_vbox.add_child(new_freq_ratio)
	ca_ivl_freq_ratio_error_vbox.add_child(new_freq_ratio_error)
	ca_ivl_dist_vbox.add_child(new_distance)
	ca_ivl_total_12th_steps_vbox.add_child(new_12th_steps)
	ca_ivl_pitch_lock_vbox.add_child(new_pitch_lock)
	ca_ivl_interval_lock_vbox.add_child(new_interval_lock)



	
func ca_remove_interval_row(_idx: int) -> void:
	if _idx == 0:
		# Can't remove first row. Instead we make it invisible.
		ca_set_first_ivl_row_visible(false)
		return
	var a: Label = ca_ivl_pitch_a_vbox.get_node("PitchALabel"+str(_idx))
	var b: Label = ca_ivl_pitch_b_vbox.get_node("PitchBLabel"+str(_idx))
	var freq_ratio: LineEdit = ca_ivl_freq_ratio_vbox.get_node("FreqRatioLineEdit"+str(_idx))
	var freq_ratio_error: Label = ca_ivl_freq_ratio_error_vbox.get_node("FreqRatioErrorLabel"+str(_idx))
	var distance: Label = ca_ivl_dist_vbox.get_node("DistanceLabel"+str(_idx))
	var twelfth_steps: LineEdit = ca_ivl_total_12th_steps_vbox.get_node("TotalTwelfthStepsLineEdit"+str(_idx))
	var pitch_lock: OptionButton = ca_ivl_pitch_lock_vbox.get_node("PitchLockOptionButton"+str(_idx))
	var interval_lock: OptionButton = ca_ivl_interval_lock_vbox.get_node("IntervalLockOptionButton"+str(_idx))
	a.free()
	b.free()
	freq_ratio.free()
	freq_ratio_error.free()
	distance.free()
	twelfth_steps.free()
	pitch_lock.free()
	interval_lock.free()
	

func _on_AOptionButton_item_selected(_index: int, _extra_arg_0: int) -> void:
	if forcing_control_value:
		return


func _on_BOptionButton_item_selected(_index: int, _extra_arg_0: int) -> void:
	if forcing_control_value:
		return


func _on_IvlCloseButton_pressed(_idx: int) -> void:
	if forcing_control_value:
		return
	ca_remove_interval_row(_idx)
	


func _on_HalfStepNameOptionButton_item_selected(index: int) -> void:
	if forcing_control_value:
		return
	var last: int = half_step_name
	half_step_name = index
	if half_step_name == last:
		return
	var ts_heading_label: Label = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/IvlHeadingsHBoxContainer/IvlTwelfthStepsHeadingVBoxContainer/Label8")
	var ts_intervals_label: Label = get_node("CanvasLayer/ChordAnalysisPanelContainer/VBoxContainer/TwelfthStepIntervalsHBoxContainer/Label")
	
	var ob: OptionButton = get_node("CanvasLayer/SettingsPanelContainer/VBoxContainer/HBoxContainer3/IvlDistanceFormatOptionButton")
	var old_s: String
	var new_s: String
	forcing_control_value = true
	for i in range(ob.get_item_count()):
		old_s = ob.get_item_text(i)
		match last:
			HalfStepName.HALF_STEP:
				match half_step_name:
					HalfStepName.HALF_TONE:
						new_s = old_s.replace("hs", "ht")
						new_s = new_s.replace("ts", "tt")
						ts_heading_label.text = "12th-tones"
						ts_intervals_label.text = "12th-tone intervals: "
						ca_normal_form_12th_step_intervals_label.text = "Normal form 12th-tone intervals: "
					HalfStepName.SEMI_TONE:
						new_s = old_s.replace("hs", "st")
						new_s = new_s.replace("ts", "tt")
						ts_heading_label.text = "12th-tones"
						ts_intervals_label.text = "12th-tone intervals: "
						ca_normal_form_12th_step_intervals_label.text = "Normal form 12th-tone intervals: "
			HalfStepName.HALF_TONE:
				match half_step_name:
					HalfStepName.HALF_STEP:
						new_s = old_s.replace("ht", "hs")
						new_s = new_s.replace("tt", "ts")
						ts_heading_label.text = "12th-steps"
						ts_intervals_label.text = "12th-step intervals: "
						ca_normal_form_12th_step_intervals_label.text = "Normal form 12th-step intervals: "
					HalfStepName.SEMI_TONE:
						new_s = old_s.replace("ht", "st")
#						ts_heading_label.text = "12th-tones" # Should already be this.
			HalfStepName.SEMI_TONE:
				match half_step_name:
					HalfStepName.HALF_STEP:
						new_s = old_s.replace("st", "hs")
						new_s = new_s.replace("tt", "ts")
						ts_heading_label.text = "12th-steps"
						ts_intervals_label.text = "12th-step intervals: "
						ca_normal_form_12th_step_intervals_label.text = "Normal form 12th-step intervals: "
					HalfStepName.HALF_TONE:
						new_s = old_s.replace("st", "ht")
#						ts_heading_label.text = "12th-tones" # Should already be this.
		ob.set_item_text(i, new_s)
	forcing_control_value = false
	

func _on_IvlDistanceFormatOptionButton_item_selected(index: int) -> void:
	if forcing_control_value:
		return
	var last: int = ivl_distance_format
	if index == last: # No change.
		return
	ivl_distance_format = index
	ca_update_interval_rows(current_pitch_set)

func _on_IntervalsToListOptionButton_item_selected(index: int) -> void:
	if forcing_control_value:
		return
	var last: int = default_interval_display_method
	if index == last: # No change.
		return
	default_interval_display_method = index
	ca_update_chord_analysis_window(current_pitch_set)

func drop_control_focus(_control: Control) -> void:
	_control.release_focus()


func _on_MaxDenominatorSpinBox_value_changed(value: int) -> void:
	if forcing_control_value:
		return
	ca_ivl_max_denominator = clamp(value, Interval.MIN_MAX_DENOMINATOR, Interval.MAX_MAX_DENOMINATOR)
	forcing_control_value = true
	get_node("CanvasLayer/SettingsPanelContainer/VBoxContainer/HBoxContainer6/MaxDenominatorSpinBox").value\
		= ca_ivl_max_denominator
	forcing_control_value = false
	for ivl in current_pitch_set.intervals:
		ivl.max_denominator = ca_ivl_max_denominator
	
	ca_update_ivl_ratio_tooltip()

func ca_note_numbers_entered(_note_numbers_str: String) -> void:
	_note_numbers_str = _note_numbers_str.strip_escapes().strip_edges()
	var splits: PoolStringArray = _note_numbers_str.split(',', false)
	var note_num: int
	var new_note_nums: Array
	# Play new pitches which weren't in the set.
	for s in splits:
		note_num = int(s)
		new_note_nums.push_back(note_num)
		if not current_pitch_set.note_numbers.has(note_num):
			# This is a new note. 
			click_button(note_num_to_button_num(note_num), current_instrument)
	# Stop old pitches which aren't in the new set.
	for old_note_num in current_pitch_set.note_numbers:
		if not new_note_nums.has(old_note_num):
			click_button(note_num_to_button_num(old_note_num), current_instrument)
	# The chord analysis window should be updated.
	drop_control_focus(ca_note_numbers_text_edit)
			

func ca_frequencies_entered(_frequencies_str: String) -> void:
	_frequencies_str = _frequencies_str.strip_escapes().strip_edges()
	var splits: PoolStringArray = _frequencies_str.split(',', false)
	var pitch: Pitch = Pitch.new()
	var new_note_nums: Array
	# Play new pitches which weren't in the set.
	for s in splits:
		pitch.freq = float(s)
		new_note_nums.push_back(pitch.sevtwo_note_num)
		if not current_pitch_set.note_numbers.has(pitch.sevtwo_note_num):
			# This is a new note. 
			click_button(note_num_to_button_num(pitch.sevtwo_note_num), current_instrument)
	# Stop old pitches which aren't in the new set.
	for old_note_num in current_pitch_set.note_numbers:
		if not new_note_nums.has(old_note_num):
			click_button(note_num_to_button_num(old_note_num), current_instrument)
	# The chord analysis window should be updated.
	drop_control_focus(ca_frequencies_text_edit)
	

func ca_pitches_entered(_pitches_str: String) -> void:
	_pitches_str = _pitches_str.strip_escapes().strip_edges()
	var splits: PoolStringArray = _pitches_str.split(',', false)
	var pitch: Pitch = Pitch.new()
	var new_note_nums: Array
	for s in splits:
		if not middle_c_is_c4:
			pitch.title = s
		else:
			pitch.title_c4 = s
		new_note_nums.push_back(pitch.sevtwo_note_num)
		if not current_pitch_set.note_numbers.has(pitch.sevtwo_note_num):
			# This is a new note. 
			click_button(note_num_to_button_num(pitch.sevtwo_note_num), current_instrument)
	# Stop old pitches which aren't in the new set.
	for old_note_num in current_pitch_set.note_numbers:
		if not new_note_nums.has(old_note_num):
			click_button(note_num_to_button_num(old_note_num), current_instrument)
	# The chord analysis window should be updated.
	drop_control_focus(ca_pitches_text_edit)
	


func _on_NoteNumbersTextEdit_gui_input(event) -> void:
	if forcing_control_value:
		return
	if event is InputEventKey && (event.scancode == KEY_ENTER || event.scancode == KEY_ESCAPE)\
		&& event.is_pressed() && not event.is_echo():
		ca_note_numbers_entered(ca_note_numbers_text_edit.text)

func _on_PitchesTextEdit_gui_input(event) -> void:
	if forcing_control_value:
		return
	if event is InputEventKey && (event.scancode == KEY_ENTER || event.scancode == KEY_ESCAPE)\
		&& event.is_pressed() && not event.is_echo():
		ca_pitches_entered(ca_pitches_text_edit.text)

func _on_FrequenciesTextEdit_gui_input(event) -> void:
	if forcing_control_value:
		return
	if event is InputEventKey && (event.scancode == KEY_ENTER || event.scancode == KEY_ESCAPE)\
		&& event.is_pressed() && not event.is_echo():
		ca_frequencies_entered(ca_frequencies_text_edit.text)



func draw_ca_mouse_ivl_row() -> void:
	if current_pitch_set.pitches.size() <= 1:
		return
	if ca_ivl_mouse_row < 0 || ca_ivl_mouse_row >= ca_ivl_pitch_a_vbox.get_child_count():
		return
	var pitch_a_label: Label = ca_ivl_pitch_a_vbox.get_node("PitchALabel"+str(ca_ivl_mouse_row))
	var pitch_b_label: Label = ca_ivl_pitch_b_vbox.get_node("PitchBLabel"+str(ca_ivl_mouse_row))
	
	var pitch_a_idx: int = current_pitch_set.find_pitch_string(pitch_a_label.text, middle_c_is_c4)
	var pitch_b_idx: int = current_pitch_set.find_pitch_string(pitch_b_label.text, middle_c_is_c4)
	var pitch_a: Pitch = current_pitch_set.pitches[pitch_a_idx]
	var pitch_b: Pitch = current_pitch_set.pitches[pitch_b_idx]
	var a_button_num: int
	var b_button_num: int
	a_button_num = active_note_num_to_button_num(pitch_a.sevtwo_note_num)
	b_button_num = active_note_num_to_button_num(pitch_b.sevtwo_note_num)
	var a_pos: Vector2 = points[a_button_num]
	var b_pos: Vector2 = points[b_button_num]
	draw_circle(a_pos, ca_ivl_circle_radius, ca_ivl_draw_color)
	draw_circle(b_pos, ca_ivl_circle_radius, ca_ivl_draw_color)
	draw_line(a_pos, b_pos, ca_ivl_draw_color, ca_ivl_line_width)
		

func draw_select_box() -> void:
	var rect_color: Color = Color(selection_color.r, selection_color.g, selection_color.b, select_box_alpha)
	var rect: Rect2 = Rect2(select_box_tl, select_box_br - select_box_tl)
	draw_rect(rect, rect_color, true)
	draw_rect(rect, selection_color, false, 2.0)

func _draw() -> void:
	if chord_analysis_panel.visible && mouse_is_inside_chord_analysis_panel:
		draw_ca_mouse_ivl_row()
	if is_dragging_select_box:
		draw_select_box()
		
func ca_set_interval_row_color(_row: int, _color: Color) -> void:
	ca_ivl_pitch_a_vbox.get_node("PitchALabel"+str(_row)).add_color_override("font_color", _color)
	ca_ivl_pitch_b_vbox.get_node("PitchBLabel"+str(_row)).add_color_override("font_color", _color)
	ca_ivl_freq_ratio_vbox.get_node("FreqRatioLineEdit"+str(_row)).add_color_override("font_color", _color)
	if _color == WHITE:
		var freq_ratio_error_label: Label = ca_ivl_freq_ratio_error_vbox.get_node("FreqRatioErrorLabel"+str(_row))
		var err: float = float(freq_ratio_error_label.text)
		var col: Color = ca_get_freq_ratio_error_label_color(err)
		ca_ivl_freq_ratio_error_vbox.get_node("FreqRatioErrorLabel"+str(_row)).add_color_override("font_color", col)
	else:
		ca_ivl_freq_ratio_error_vbox.get_node("FreqRatioErrorLabel"+str(_row)).add_color_override("font_color", _color)
	ca_ivl_dist_vbox.get_node("DistanceLabel"+str(_row)).add_color_override("font_color", _color)
	ca_ivl_total_12th_steps_vbox.get_node("TotalTwelfthStepsLineEdit"+str(_row)).add_color_override("font_color", _color)
	ca_ivl_pitch_lock_vbox.get_node("PitchLockOptionButton"+str(_row)).add_color_override("font_color", _color)
	ca_ivl_interval_lock_vbox.get_node("IntervalLockOptionButton"+str(_row)).add_color_override("font_color", _color)

func op_set_file_row_color(_row: int, _color: Color) -> void:
	op_name_vbox.get_node("NameLabel"+str(_row)).add_color_override("font_color", _color)
	op_last_modified_vbox.get_node("LastModifiedLabel"+str(_row)).add_color_override("font_color", _color)
	op_pitch_classes_vbox.get_node("PitchClassesLabel"+str(_row)).add_color_override("font_color", _color)
	
func sv_set_file_row_color(_row: int, _color: Color) -> void:
	sv_name_vbox.get_node("NameLabel"+str(_row)).add_color_override("font_color", _color)
	sv_last_modified_vbox.get_node("LastModifiedLabel"+str(_row)).add_color_override("font_color", _color)
	sv_pitch_classes_vbox.get_node("PitchClassesLabel"+str(_row)).add_color_override("font_color", _color)
	
	
func ca_update_interval_row_colors(_highlighted_row: int) -> void:
	for i in range(ca_ivl_pitch_a_vbox.get_child_count()):
		if i == _highlighted_row:
			ca_set_interval_row_color(i, ca_ivl_text_color)
		else:
			ca_set_interval_row_color(i, WHITE)

func op_update_file_row_colors(_highlighted_row: int, _selected_row: int = -1) -> void:
	for i in range(op_name_vbox.get_child_count()):
		if i == _highlighted_row:
			op_set_file_row_color(i, ca_ivl_text_color)
		elif i == _selected_row:
			op_set_file_row_color(i, ORANGE)
		else:
			op_set_file_row_color(i, WHITE)

func sv_update_file_row_colors(_highlighted_row: int) -> void:
	for i in range(sv_name_vbox.get_child_count()):
		if i == _highlighted_row:
			sv_set_file_row_color(i, ca_ivl_text_color)
		else:
			sv_set_file_row_color(i, WHITE)

func ca_update_ca_ivl_mouse_row() -> void:
	ca_last_ivl_mouse_row = ca_ivl_mouse_row
	for i in range(ca_ivl_pitch_a_vbox.get_child_count()):
		if ca_ivl_freq_ratio_vbox.get_node("FreqRatioLineEdit"+str(i)).has_focus():
			ca_ivl_mouse_row = i
			break
		if ca_ivl_pitch_lock_vbox.get_node("PitchLockOptionButton"+str(i)).has_focus():
			ca_ivl_mouse_row = i
			break
		if ca_ivl_interval_lock_vbox.get_node("IntervalLockOptionButton"+str(i)).has_focus():
			ca_ivl_mouse_row = i
			break
		if ca_ivl_total_12th_steps_vbox.get_node("TotalTwelfthStepsLineEdit"+str(i)).has_focus():
			ca_ivl_mouse_row = i
			break
		
	if not chord_analysis_panel.visible || not mouse_is_inside_chord_analysis_panel:
		ca_ivl_mouse_row = -1
	else:
		var m: Vector2 = ca_ivl_pitch_a_vbox.get_local_mouse_position()

		if m.y < 0:
			ca_ivl_mouse_row = -1
		else:
			ca_ivl_mouse_row = floor((m.y) / ca_ivl_row_height)
	if ca_ivl_mouse_row != ca_last_ivl_mouse_row: # Changed rows.
		ca_update_interval_row_colors(ca_ivl_mouse_row)
		update()
	update_debug_label()
	
func _on_IvlScrollContainer_gui_input(event) -> void:
	if chord_analysis_panel.visible:
#		if event is InputEventMouseMotion || event is InputEventMouseButton:
		if event is InputEventMouseButton:
			ca_update_ca_ivl_mouse_row()



func _on_HelpButton_toggled(button_pressed: bool) -> void:
	if forcing_control_value:
		return
	help_panel.visible = button_pressed
	help_button.release_focus()

func _on_HelpCloseButton_pressed():
	help_panel.visible = false
	forcing_control_value = true
	help_button.pressed = false
	forcing_control_value = false
	




#############################################################################################
############### TRANSFORMATIONS #############################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################

enum Transformation {TRANSPOSE, INVERT, RANDOMIZE}
var transformation: int = Transformation.TRANSPOSE setget set_transformation

var trans_voice_lead: bool = false

enum TransOutOfRangeBehavior {TRANSPOSE, REMOVE, CLAMP, REROLL}
var trans_out_of_range_behavior: int = TransOutOfRangeBehavior.TRANSPOSE setget set_trans_out_of_range_behavior

enum TransResultFormat {NOTE_NUMBERS, NOTE_NAMES, AC, FREQUENCIES}
var trans_result_format: int = TransResultFormat.NOTE_NUMBERS setget set_trans_result_format

onready var transform_panel: PanelContainer = get_node("CanvasLayer/TransformPanel")
onready var trans_transpose_interval_line_edit: IntervalLineEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/TransposeIntervalHBoxContainer/TransposeIntervalLineEdit")
onready var trans_invert_at_option_button: OptionButton = get_node("CanvasLayer/TransformPanel/VBoxContainer/InvertAtHBoxContainer/HBoxContainer/InvertAtOptionButton")
onready var trans_result_text_edit: TextEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/VBoxContainer/ResultHBoxContainer/ResultTextEdit")
onready var trans_invert_axis_a_pitch_line_edit: PitchLineEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/InvertAxisHBoxContainer/HBoxContainer/InvertAxisAPitchLineEdit")
onready var trans_invert_axis_b_pitch_line_edit: PitchLineEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/InvertAxisHBoxContainer/HBoxContainer/InvertAxisBPitchLineEdit")
onready var trans_invert_map_a_pitch_line_edit: PitchLineEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/InvertMapHBoxContainer/HBoxContainer/InvertMapAPitchLineEdit")
onready var trans_invert_map_b_pitch_line_edit: PitchLineEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/InvertMapHBoxContainer/HBoxContainer/InvertMapBPitchLineEdit")
onready var trans_transposition_index_line_edit: LineEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/TranspositionIndexHBoxContainer/HBoxContainer/TranspositionIndexLineEdit")
onready var trans_random_num_of_elements_line_edit: LineEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/RandomNumberOfElementsHBoxContainer/HBoxContainer/RandomNumberOfPitchesLineEdit")
onready var trans_random_range_low_pitch_line_edit: PitchLineEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/RandomRangeLowHBoxContainer/HBoxContainer/RangeLowPitchLineEdit")
onready var trans_random_range_high_pitch_line_edit: PitchLineEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/RandomRangeHighHBoxContainer/HBoxContainer/RangeHighPitchLineEdit")
onready var trans_norm_dist_mean_pitch_line_edit: PitchLineEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/NormalDistributionMeanHBoxContainer/HBoxContainer/NDMeanPitchLineEdit")
onready var trans_norm_dist_deviation_line_edit: LineEdit = get_node("CanvasLayer/TransformPanel/VBoxContainer/NormalDistributionDeviationHBoxContainer/HBoxContainer/NDDeviationLineEdit")


enum TransInvertAt {ONE_PITCH, TWO_PITCHES, ONE_PITCH_CLASS, TWO_PITCH_CLASSES}
var trans_invert_at: int = TransInvertAt.ONE_PITCH setget set_trans_invert_at
var trans_invert_at_pitch_classes: bool = false setget set_trans_invert_at_pitch_classes
# If the inversion is at one pitch/pitch_class, trans_invert_axis_a and trans_invert_axis_b will be the same value.
var trans_invert_axis_a: int = 216 # If trans_invert_at_pitch_classes, this will be a pitch_class, not a note_num.
var trans_invert_axis_b: int = 216 # If trans_invert_at_pitch_classes, this will be a pitch_class, not a note_num.

var close_transform_window_upon_transformation: bool = true

var trans_result_note_numbers: Array
var pitch_line_edit_forcing_format_change: bool = false
enum TransRandomType {PITCH, PITCH_CLASS, NORMAL_DISTRIBUTION}
var trans_random_type: int = TransRandomType.PITCH setget set_trans_random_type

func set_transformation(_transformation: int) -> void:
	transformation = _transformation
	var oor_option_button: OptionButton = get_node("CanvasLayer/TransformPanel/VBoxContainer/OutOfRangeBehaviorHBoxContainer/HBoxContainer/OutOfRangeBehaviorOptionButton")
	oor_option_button.set_item_disabled(TransOutOfRangeBehavior.REROLL,\
		transformation != Transformation.RANDOMIZE)
	if oor_option_button.selected == TransOutOfRangeBehavior.REROLL\
		&& transformation != Transformation.RANDOMIZE:
		forcing_control_value = true
		oor_option_button.selected = TransOutOfRangeBehavior.TRANSPOSE
		forcing_control_value = false
	# Hide or show various controls on the transform_panel
	# depending on the transformation.
	var transposition_index_hbox: HBoxContainer =\
		get_node("CanvasLayer/TransformPanel/VBoxContainer/TranspositionIndexHBoxContainer")
	var transpose_interval_hbox: HBoxContainer =\
		get_node("CanvasLayer/TransformPanel/VBoxContainer/TransposeIntervalHBoxContainer")
	var invert_at_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/InvertAtHBoxContainer")
	var invert_axis_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/InvertAxisHBoxContainer")
	var invert_map_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/InvertMapHBoxContainer")
	var random_type_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/RandomTypeHBoxContainer")
	var random_num_of_elements_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/RandomNumberOfElementsHBoxContainer")
	var random_range_low_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/RandomRangeLowHBoxContainer")
	var random_range_high_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/RandomRangeHighHBoxContainer")
	var norm_dist_mean_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/NormalDistributionMeanHBoxContainer")
	var norm_dist_deviation_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/NormalDistributionDeviationHBoxContainer")
	var reroll_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/RerollHBoxContainer")
	if transformation == Transformation.RANDOMIZE:
		forcing_control_value = true
		trans_random_num_of_elements_line_edit.text = str(current_pitch_set.pitches.size())
		forcing_control_value = false
	
	transposition_index_hbox.visible = transformation == Transformation.TRANSPOSE\
		|| transformation == Transformation.INVERT
	transpose_interval_hbox.visible = transformation == Transformation.TRANSPOSE
	invert_at_hbox.visible = transformation == Transformation.INVERT
	invert_axis_hbox.visible = transformation == Transformation.INVERT
	invert_map_hbox.visible = transformation == Transformation.INVERT
	random_type_hbox.visible = transformation == Transformation.RANDOMIZE
	random_range_low_hbox.visible = transformation == Transformation.RANDOMIZE && trans_random_type != TransRandomType.NORMAL_DISTRIBUTION
	random_range_high_hbox.visible = transformation == Transformation.RANDOMIZE && trans_random_type != TransRandomType.NORMAL_DISTRIBUTION
	random_num_of_elements_hbox.visible = transformation == Transformation.RANDOMIZE
	norm_dist_mean_hbox.visible = transformation == Transformation.RANDOMIZE && trans_random_type == TransRandomType.NORMAL_DISTRIBUTION
	norm_dist_deviation_hbox.visible = transformation == Transformation.RANDOMIZE && trans_random_type == TransRandomType.NORMAL_DISTRIBUTION
	reroll_hbox.visible = transformation == Transformation.RANDOMIZE
	trans_update()

func set_trans_out_of_range_behavior(_trans_out_of_range_behavior: int) -> void:
	trans_out_of_range_behavior = _trans_out_of_range_behavior



func _on_TransformButton_toggled(_button_pressed: bool) -> void:
	if forcing_control_value:
		return
	if not important_panel_is_open:
		transform_panel.visible = _button_pressed
	else:
		forcing_control_value = true
		transform_button.pressed = !_button_pressed
		forcing_control_value = false
		
	if transform_panel.visible:
		self.transformation = transformation # Setter will show 
			# the relevant hboxes.
	transform_button.release_focus()
	
func _on_CloseUponTransformCheckBox_toggled(_button_pressed: bool) -> void:
	close_transform_window_upon_transformation = _button_pressed

func _on_TranspositionIndexLineEdit_text_entered(_new_text: String) -> void:
	if forcing_control_value:
		return
	var index_pc: int = posmod(int(_new_text), 72)
	if transformation == Transformation.TRANSPOSE:
		forcing_control_value = true
		trans_transpose_interval_line_edit.interval.sevtwo_posmod_72 = index_pc
		trans_transpose_interval_line_edit.force_update_text()
#		trans_transposition_index_line_edit.text = "T"+str(n) # trans_update() will do this.
		forcing_control_value = false
	elif transformation == Transformation.INVERT:
		if trans_invert_at == TransInvertAt.TWO_PITCHES\
			|| trans_invert_at == TransInvertAt.TWO_PITCH_CLASSES:
			var pc_a: int
			var pc_b: int
			if current_pitch_set.note_numbers.empty():
				pc_a = 54 # 54 is just some arbitrary pitch class. It's A=
			else:
				pc_a = current_pitch_set.pitches[0].sevtwo_pitch_class # Use the first pitch in the set.
			pc_b = posmod(index_pc - pc_a, 72)
			print("pc_a: ", pc_a, ", pc_b: ", pc_b, ", index_pc: ", index_pc)
			forcing_control_value = true
			trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_pitch_class = pc_a
			trans_invert_axis_b_pitch_line_edit.pitch.sevtwo_pitch_class = pc_b
			trans_invert_axis_a_pitch_line_edit.force_update_text()
			trans_invert_axis_b_pitch_line_edit.force_update_text()
			forcing_control_value = false
		else:
			
			if trans_invert_at == TransInvertAt.ONE_PITCH_CLASS:
				# When inverting at one pitch, the axis is the trans_invert_axis_a_line_edit.pitch.sevtwo_note_num
				forcing_control_value = true
				trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_pitch_class = index_pc
				trans_invert_axis_a_pitch_line_edit.force_update_text()
				forcing_control_value = false
			else: # one pitch
				# The axis note number will be trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_note_num.
				# Index = (pc_a + pc_b) % 72
				# Axis note number = (nn_a + nn_b) / 2
				
				var nn_a: int
				var nn_b: int
				if current_pitch_set.note_numbers.empty():
					nn_a = 270 # 270 is just some arbitrary note number. It's A3.
				else: # Use the first pitch in the set.
					nn_a = current_pitch_set.pitches[0].sevtwo_note_num
				nn_b = index_pc + 432 - nn_a
				var axis_note_num: int = (nn_a + nn_b) / 2
				
				forcing_control_value = true
				trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_note_num = axis_note_num
				trans_invert_axis_a_pitch_line_edit.force_update_text()
				forcing_control_value = false

	trans_update()
	trans_transposition_index_line_edit.release_focus()

func _on_TransposeIntervalLineEdit_text_changed_2(_line_edit, _new_text: String) -> void:
	if forcing_control_value:
		return
	assert(transformation == Transformation.TRANSPOSE)
	trans_update()

func _on_TransformCancelButton_pressed():
	transform_panel.visible = false
	forcing_control_value = true
	transform_button.pressed = false
	forcing_control_value = false

func _on_TransformConfirmButton_pressed():
	# Finally, we apply the transformation.
	set_current_pitch_set_note_numbers(trans_result_note_numbers)
	if close_transform_window_upon_transformation:
		_on_TransformCancelButton_pressed()
	else:
		# Preview if the user does the same transformation again.
		trans_update()
	
func trans_update() -> void:
	# Note: The current_pitch_set isn't actually transformed until
	# the user clicks the confirm button in the transform_panel.
	# This just generates a preview of the transformation
	# and displays it in trans_result_note_numbers.
	match transformation:
		Transformation.TRANSPOSE:
			trans_update_transpose()
		Transformation.INVERT:
			trans_update_invert()
		Transformation.RANDOMIZE:
			trans_update_randomize()
			
	if trans_voice_lead:
		trans_result_note_numbers =\
			voice_lead(current_pitch_set.note_numbers, trans_result_note_numbers, false)

	trans_update_result_text_edit()
	
func voice_lead(_old_note_numbers: Array, _transformed_note_numbers: Array,\
	_allow_unisons: bool) -> Array:
	#### TODO: Eventually have this feature.
	return _transformed_note_numbers
#	var old_pc: int
#	var new_pc: int
#	var old_note_num: int
#	var new_note_num: int
#	var dist: int
#	var closest_dist: int
#
#
#	var new_pcs: Array
#	for nn in _transformed_note_numbers:
#		new_pc = posmod(nn, SEVENTY_TWO_INT)
#		if not new_pcs.has(new_pc)
#		new_pcs.push_back(new_pc)
#	if _old_note_numbers.size() > _transformed_note_numbers.size():
#		_allow_unisons = true
#
#	var new_from_olds: Dictionary
#	for npc in new_pcs:
#		new_from_olds[npc] = []
#	for i in range(new_pcs.size()):
#		new_pc = new_pcs[i]
#		closest_dist = 73
#		for j in range(_old_note_numbers.size()):
#			old_note_num = _old_note_numbers[j]
#			old_pc = posmod(old_note_num, SEVENTY_TWO_INT)
#			dist = get_pitch_class_distance(old_pc, new_pc)
#			if dist == closest_dist:
#				new_from_olds[new_pc].push_back(old_note_num)
#			elif dist < closest_dist:
#				closest_dist = dist
#				new_from_olds[new_pc].clear()
#				new_from_olds[new_pc].push_back(old_note_num)
#
#
#
#
#
#
#
#
#	return []

func _on_InvertAtOptionButton_item_selected(_index: int) -> void:
	if forcing_control_value:
		return
	self.trans_invert_at = _index
	trans_update()

func set_trans_invert_at(_trans_invert_at: int, _update_pitch_line_edit_formats: bool = true,\
	_update_trans_invert_at_option_button: bool = false) -> void:
	trans_invert_at = _trans_invert_at
	var two: bool = trans_invert_at == TransInvertAt.TWO_PITCHES\
		|| trans_invert_at == TransInvertAt.TWO_PITCH_CLASSES
	trans_invert_axis_b_pitch_line_edit.visible = two
	
	trans_invert_at_pitch_classes = trans_invert_at == TransInvertAt.ONE_PITCH_CLASS\
		|| trans_invert_at == TransInvertAt.TWO_PITCH_CLASSES
	if _update_pitch_line_edit_formats:
		pitch_line_edit_forcing_format_change = true
		trans_invert_axis_a_pitch_line_edit.has_octave = not trans_invert_at_pitch_classes
		trans_invert_axis_b_pitch_line_edit.has_octave = not trans_invert_at_pitch_classes
		trans_invert_map_a_pitch_line_edit.has_octave = not trans_invert_at_pitch_classes
		trans_invert_map_b_pitch_line_edit.has_octave = not trans_invert_at_pitch_classes
		pitch_line_edit_forcing_format_change = false
	
	var axis_label: Label = get_node("CanvasLayer/TransformPanel/VBoxContainer/InvertAxisHBoxContainer/AxisLabel")
	var map_label: Label = get_node("CanvasLayer/TransformPanel/VBoxContainer/InvertMapHBoxContainer/InvertMapLabel")
	if trans_invert_at_pitch_classes:
		map_label.text = "Map pitch classes: "
		if two:
			axis_label.text = "Pitch classes: "
		else:
			axis_label.text = "Pitch class: "
	else:
		map_label.text = "Map pitches: "
		if two:
			axis_label.text = "Axes: "
		else:
			axis_label.text = "Axis: "
	if _update_trans_invert_at_option_button:
		forcing_control_value = true
		trans_invert_at_option_button.selected = trans_invert_at
		forcing_control_value = false

func set_trans_invert_at_pitch_classes(_trans_invert_at_pitch_classes: bool) -> void:
	trans_invert_at_pitch_classes = _trans_invert_at_pitch_classes
	if trans_invert_at_pitch_classes:
		match trans_invert_at:
			TransInvertAt.ONE_PITCH:
				self.trans_invert_at = TransInvertAt.ONE_PITCH_CLASS # Setter will update the pitch_line_edits.
			TransInvertAt.TWO_PITCHES:
				self.trans_invert_at = TransInvertAt.TWO_PITCH_CLASSES
	else:
		match trans_invert_at:
			TransInvertAt.ONE_PITCH_CLASS:
				self.trans_invert_at = TransInvertAt.ONE_PITCH
			TransInvertAt.TWO_PITCH_CLASSES:
				self.trans_invert_at = TransInvertAt.TWO_PITCHES
	forcing_control_value = true
	trans_invert_at_option_button.selected = trans_invert_at
	forcing_control_value = false
	

	
func update_trans_pitch_line_edits_formats(_format: int) -> void:
	pitch_line_edit_forcing_format_change = true
	trans_invert_axis_a_pitch_line_edit.format = _format
	trans_invert_axis_b_pitch_line_edit.format = _format
	trans_invert_map_a_pitch_line_edit.format = _format
	trans_invert_map_b_pitch_line_edit.format = _format
	trans_random_range_low_pitch_line_edit.format = _format
	trans_random_range_high_pitch_line_edit.format = _format
	trans_norm_dist_mean_pitch_line_edit.format = _format
	if _format == trans_invert_axis_a_pitch_line_edit.PitchFormat.NOTE_NAME\
		|| _format == trans_invert_axis_a_pitch_line_edit.PitchFormat.NOTE_NAME_NO_OCTAVE:
		self.trans_result_format = TransResultFormat.NOTE_NAMES
	elif _format == trans_invert_axis_a_pitch_line_edit.PitchFormat.NOTE_NAME_AC\
		|| _format == trans_invert_axis_a_pitch_line_edit.PitchFormat.NOTE_NAME_AC_NO_OCTAVE:
		self.trans_result_format = TransResultFormat.AC
	elif _format == trans_invert_axis_a_pitch_line_edit.PitchFormat.NOTE_NUMBER\
		|| _format == trans_invert_axis_a_pitch_line_edit.PitchFormat.PITCH_CLASS_NUMBER:
		self.trans_result_format = TransResultFormat.NOTE_NUMBERS
	elif _format == trans_invert_axis_a_pitch_line_edit.PitchFormat.FREQUENCY\
		|| _format == trans_invert_axis_a_pitch_line_edit.PitchFormat.FREQUENCY_W_HZ:
		self.trans_result_format = TransResultFormat.FREQUENCIES
	pitch_line_edit_forcing_format_change = false

func _on_InvertAxisAPitchLineEdit_pitch_changed(_pitch_line_edit: PitchLineEdit) -> void:
	if forcing_control_value:
		return
	if trans_invert_at_pitch_classes == _pitch_line_edit.has_octave:
		self.trans_invert_at_pitch_classes = not _pitch_line_edit.has_octave
	trans_update()

func _on_InvertAxisBPitchLineEdit_pitch_changed(_pitch_line_edit: PitchLineEdit) -> void:
	if forcing_control_value:
		return
	if trans_invert_at_pitch_classes == _pitch_line_edit.has_octave:
		self.trans_invert_at_pitch_classes = not _pitch_line_edit.has_octave
	trans_update()

func _on_InvertMapAPitchLineEdit_pitch_changed(_pitch_line_edit: PitchLineEdit) -> void:
	if forcing_control_value:
		return
	if trans_invert_at_pitch_classes == _pitch_line_edit.has_octave:
		self.trans_invert_at_pitch_classes = not _pitch_line_edit.has_octave
		
	if trans_invert_at == TransInvertAt.TWO_PITCHES\
		|| trans_invert_at == TransInvertAt.TWO_PITCH_CLASSES:
		var index: int = get_index_pitch_class_from_two_mapped_pitches(\
			trans_invert_map_a_pitch_line_edit.pitch, trans_invert_map_b_pitch_line_edit.pitch)
		forcing_control_value = true
		trans_transposition_index_line_edit.text = "T"+str(index)+"I"
		trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_pitch_class = index
		trans_invert_axis_a_pitch_line_edit.force_update_text()
		trans_invert_axis_b_pitch_line_edit.pitch.sevtwo_pitch_class =\
			posmod(index - trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_pitch_class, 72)
		trans_invert_axis_b_pitch_line_edit.force_update_text()
		forcing_control_value = false
	else:
		# TODO:
		pass
	trans_update()
	
func _on_InvertMapBPitchLineEdit_pitch_changed(_pitch_line_edit: PitchLineEdit) -> void:
	if forcing_control_value:
		return
	if trans_invert_at_pitch_classes == _pitch_line_edit.has_octave:
		self.trans_invert_at_pitch_classes = not _pitch_line_edit.has_octave
	if trans_invert_at == TransInvertAt.TWO_PITCHES\
		|| trans_invert_at == TransInvertAt.TWO_PITCH_CLASSES:
		var index: int = get_index_pitch_class_from_two_mapped_pitches(\
			trans_invert_map_a_pitch_line_edit.pitch, trans_invert_map_b_pitch_line_edit.pitch)
		forcing_control_value = true
#		trans_transposition_index_line_edit.text = "T"+str(index)+"I"
		trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_pitch_class = index
		trans_invert_axis_a_pitch_line_edit.force_update_text()
		trans_invert_axis_b_pitch_line_edit.pitch.sevtwo_pitch_class =\
			posmod(index - trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_pitch_class, 72)
		trans_invert_axis_b_pitch_line_edit.force_update_text()
		forcing_control_value = false
	else:
		# Don't need to do anything here, because axis B is hidden, and trans_transposition_index_line_edit.text
		# is updated in trans_update().
		pass
	trans_update()
	
func update_trans_invert_at_from_pitch_line_edit(_pitch_line_edit: PitchLineEdit) -> void:
	update_trans_pitch_line_edits_formats(_pitch_line_edit.format)
	if trans_invert_at_pitch_classes == _pitch_line_edit.has_octave:
		trans_invert_at_pitch_classes = not _pitch_line_edit.has_octave

		# The formats of the other PitchLineEdits should already be updated,
		# so no need to call the setter using self. We still need to update
		# trans_invert_at and the InvertAtOptionButton, however.
		# So we pass false into the second argument and true for the third.
		if trans_invert_at_pitch_classes:
			match trans_invert_at:
				TransInvertAt.ONE_PITCH:
					set_trans_invert_at(TransInvertAt.ONE_PITCH_CLASS, false, true)
				TransInvertAt.TWO_PITCHES:
					set_trans_invert_at(TransInvertAt.TWO_PITCH_CLASSES, false, true)
		else:
			match trans_invert_at:
				TransInvertAt.ONE_PITCH_CLASS:
					set_trans_invert_at(TransInvertAt.ONE_PITCH, false, true)
				TransInvertAt.TWO_PITCHES:
					set_trans_invert_at(TransInvertAt.TWO_PITCHES, false, true)
		
func _on_InvertAxisAPitchLineEdit_format_changed(_pitch_line_edit: PitchLineEdit,\
	_new_format: int) -> void:
	if pitch_line_edit_forcing_format_change:
		return
	update_trans_invert_at_from_pitch_line_edit(_pitch_line_edit)
	trans_update()

	

func _on_InvertAxisBPitchLineEdit_format_changed(_pitch_line_edit: PitchLineEdit,\
	_new_format: int) -> void:
	if pitch_line_edit_forcing_format_change:
		return
	update_trans_invert_at_from_pitch_line_edit(_pitch_line_edit)
	trans_update()
	
func _on_InvertMapAPitchLineEdit_format_changed(_pitch_line_edit: PitchLineEdit,\
	_new_format: int) -> void:
	if pitch_line_edit_forcing_format_change:
		return
	update_trans_invert_at_from_pitch_line_edit(_pitch_line_edit)
	trans_update()

func _on_InvertMapBPitchLineEdit_format_changed(_pitch_line_edit: PitchLineEdit,\
	_new_format: int) -> void:
	if pitch_line_edit_forcing_format_change:
		return
	update_trans_invert_at_from_pitch_line_edit(_pitch_line_edit)
	trans_update()

func get_index_pitch_class_from_two_mapped_pitches(_pitch_a: Pitch, _pitch_b: Pitch) -> int:
	return posmod(_pitch_a.sevtwo_pitch_class + _pitch_b.sevtwo_pitch_class, 72)

func trans_update_invert() -> void:
	trans_result_note_numbers.clear()
	var arr: Array
	var two: bool = trans_invert_at == TransInvertAt.TWO_PITCHES\
		|| trans_invert_at == TransInvertAt.TWO_PITCH_CLASSES
	if trans_invert_at_pitch_classes:
		var actual_index: int
		if two:
			actual_index = get_index_pitch_class_from_two_mapped_pitches(\
				trans_invert_axis_a_pitch_line_edit.pitch,\
				trans_invert_axis_b_pitch_line_edit.pitch)
		else: # Only 1 index.
			actual_index = trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_pitch_class #posmod(int(trans_transposition_index_line_edit.text), 72)
		print("trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_pitch_class: ", trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_pitch_class)
		print("trans_invert_axis_b_pitch_line_edit.pitch.sevtwo_pitch_class: ", trans_invert_axis_b_pitch_line_edit.pitch.sevtwo_pitch_class)
		print("actual_index: ", actual_index)
		forcing_control_value = true
		trans_transposition_index_line_edit.text = "T"+str(actual_index)+"I"
		forcing_control_value = false
		# If we start with a set in 12-Equal-Temperament, and want to perform T8I, we ask
		# this for each pc in our starting set.
		#	 pc + x = 8 mod 12
		# The resulting x is a pc in the new set.
		# Doing a little algebra:
		#	 x = (8 - pc) mod 12
		# It works the same way in 7TET, just use mod 72 instead of mod 12.
		var n: int
		var pc: int
		var x: int
		var dist: int
#		print("\nTransforming by inversion at index ", actual_index)
		var map_pitch_line_edits_work: bool =\
			trans_invert_map_b_pitch_line_edit.pitch.sevtwo_pitch_class\
			== posmod(actual_index - trans_invert_map_a_pitch_line_edit.pitch.sevtwo_pitch_class, 72)
		for i in range(current_pitch_set.note_numbers.size()):
			n = current_pitch_set.note_numbers[i]
			var pitch: Pitch = current_pitch_set.pitches[i]
			assert(pitch.sevtwo_note_num == n)
			x = posmod(actual_index - pitch.sevtwo_pitch_class, 72)
			if i == 0 && not map_pitch_line_edits_work:
				forcing_control_value = true
				trans_invert_map_a_pitch_line_edit.pitch.sevtwo_pitch_class = pitch.sevtwo_pitch_class
				trans_invert_map_b_pitch_line_edit.pitch.sevtwo_pitch_class = x
				trans_invert_map_a_pitch_line_edit.force_update_text()
				trans_invert_map_b_pitch_line_edit.force_update_text()
				forcing_control_value = false
				map_pitch_line_edits_work = true
			dist = get_pitch_class_distance(pitch.sevtwo_pitch_class, x, false)
			n + dist
			arr.push_back(n + dist)
	else: # Invert at pitch(es)
		var index_pc: int
		var axis_note_num: float
		var got_index_pc: bool = false
		if two:
			var a: int = trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_note_num
			var b: int = trans_invert_axis_b_pitch_line_edit.pitch.sevtwo_note_num
			if b >= a:
				axis_note_num = float(a) + (float(b - a) * 0.5)
			else:
				axis_note_num = float(b) + (float(a - b) * 0.5)
			index_pc = get_index_pitch_class_from_two_mapped_pitches(trans_invert_axis_a_pitch_line_edit.pitch,\
				trans_invert_axis_b_pitch_line_edit.pitch)
			got_index_pc = true
		else:
			axis_note_num = float(trans_invert_axis_a_pitch_line_edit.pitch.sevtwo_note_num)
			# inversion index should be even.
			
		var n: int
		var old_note_num: int
		for i in range(current_pitch_set.pitches.size()):
			old_note_num = current_pitch_set.note_numbers[i]
			n = int(axis_note_num + (axis_note_num - float(old_note_num)))
			if i == 0 && not got_index_pc:
				var pc_a: int = current_pitch_set.pitches[i].sevtwo_pitch_class
				var pc_b: int = posmod(n, 72)
				index_pc = posmod(pc_a + pc_b, 72)
			arr.push_back(n)

		forcing_control_value = true
		trans_transposition_index_line_edit.text = "T"+str(index_pc)+"I"
		forcing_control_value = false
	# Handle out-of-range.
	for new_note_num in arr:
		match trans_out_of_range_behavior:
			TransOutOfRangeBehavior.TRANSPOSE:
				new_note_num = transpose_note_num_by_octaves_until_within_instrument_range(\
					new_note_num, current_instrument)
			TransOutOfRangeBehavior.CLAMP:
				new_note_num = clamp_note_num_within_instrument_range(\
					new_note_num, current_instrument)
			TransOutOfRangeBehavior.REMOVE:
				if not note_num_is_within_instrument_range(new_note_num, current_instrument):
					continue
		trans_result_note_numbers.push_back(new_note_num)
	trans_result_note_numbers.sort()


func _on_RangeLowPitchLineEdit_text_entered_2(_pitch_line_edit: PitchLineEdit,\
	_new_text: String) -> void:
	if forcing_control_value:
		return
	trans_update()
	trans_random_range_high_pitch_line_edit.release_focus()

func _on_RangeHighPitchLineEdit_text_entered_2(_pitch_line_edit: PitchLineEdit,\
	_new_text: String) -> void:
	if forcing_control_value:
		return
	trans_update()
	trans_random_range_high_pitch_line_edit.release_focus()

func _on_RandomNumberOfPitchesLineEdit_text_entered(new_text: String) -> void:
	if forcing_control_value:
		return
	trans_update()
	trans_random_num_of_elements_line_edit.release_focus()

func _on_RangeLowPitchLineEdit_format_changed(_pitch_line_edit: PitchLineEdit, _new_format: int) -> void:
	if pitch_line_edit_forcing_format_change:
		return
	update_trans_pitch_line_edits_formats(_new_format)
	
	trans_update()

func _on_RangeHighPitchLineEdit_format_changed(_pitch_line_edit: PitchLineEdit, _new_format: int) -> void:
	if pitch_line_edit_forcing_format_change:
		return
	update_trans_pitch_line_edits_formats(_new_format)
	trans_update()
	
func _on_InstrumentRangeLowButton_pressed():
	forcing_control_value = true
	trans_random_range_low_pitch_line_edit.pitch.sevtwo_note_num =\
		instrument_data[instrument_strings[current_instrument]]["lowest_sevtwo_number"]
	trans_random_range_low_pitch_line_edit.force_update_text()
	forcing_control_value = false
	trans_update()


func _on_InstrumentRangeHighButton_pressed():
	forcing_control_value = true
	trans_random_range_high_pitch_line_edit.pitch.sevtwo_note_num =\
		instrument_data[instrument_strings[current_instrument]]["highest_sevtwo_number"]
	trans_random_range_high_pitch_line_edit.force_update_text()
	forcing_control_value = false
	trans_update()

func _on_NDMeanPitchLineEdit_format_changed(_pitch_line_edit: PitchLineEdit, _new_format: int) -> void:
	if pitch_line_edit_forcing_format_change:
		return
	update_trans_pitch_line_edits_formats(_new_format)
	trans_update()

func _on_NDDeviationLineEdit_text_entered(_new_text: String) -> void:
	if forcing_control_value:
		return
	trans_update()
	trans_norm_dist_deviation_line_edit.release_focus()

func _on_NDMeanPitchLineEdit_text_entered_2(_pitch_line_edit: PitchLineEdit, _new_text: String) -> void:
	if forcing_control_value:
		return
	trans_update()

func _on_RerollButton_pressed():
	trans_update()
	


func trans_update_randomize() -> void:
	var num_of_elements: int = int(trans_random_num_of_elements_line_edit.text)
	num_of_elements = max(0, num_of_elements)
	if num_of_elements == 0:
		trans_result_note_numbers.clear()
		return
	var low_inst: int = instrument_data[instrument_strings[current_instrument]]["lowest_sevtwo_number"]
	var high_inst: int = instrument_data[instrument_strings[current_instrument]]["highest_sevtwo_number"]
	assert(high_inst - low_inst >= 72) # Instrument must always have a range of octave or more.
	var low: int = clamp(trans_random_range_low_pitch_line_edit.pitch.sevtwo_note_num, low_inst, high_inst)
	var high: int = clamp(trans_random_range_high_pitch_line_edit.pitch.sevtwo_note_num, low_inst, high_inst)
	if trans_random_type == TransRandomType.NORMAL_DISTRIBUTION:
		low = low_inst
		high = high_inst
	print("low: ", low, ", high: ", high)
	num_of_elements = clamp(num_of_elements, 0, high - low)
	print("num_of_elements: ", num_of_elements)
	var elements: Array
	var arr: Array
	if trans_random_type == TransRandomType.PITCH\
		|| trans_random_type == TransRandomType.PITCH_CLASS:
		var h: int
		var k: int
		if trans_random_type == TransRandomType.PITCH:
			h = low
			k = high - low
			elements = range(h, h+k+1)
		elif trans_random_type == TransRandomType.PITCH_CLASS:
			h = 216
			while h < low:
				h += 72
			while h > high:
				h -= 72
			k = 72
			elements = range(h, h+k)
		arr = choose(elements, num_of_elements)
	elif trans_random_type == TransRandomType.NORMAL_DISTRIBUTION:
		var mean: float = float(trans_norm_dist_mean_pitch_line_edit.pitch.sevtwo_note_num)
		var dev: float = float(trans_norm_dist_deviation_line_edit.text)
		var r: int
		for i in range(num_of_elements):
			r = int(round(box_muller_normal_distribution(mean, dev)))
			if not arr.has(r): # Don't allow duplicates
				arr.push_back(r)
	trans_result_note_numbers.clear()
	var new_note_num: int
	match trans_out_of_range_behavior:
		TransOutOfRangeBehavior.TRANSPOSE:
			for nn in arr:
				new_note_num = nn
				while new_note_num < low:
					new_note_num += 72
				while new_note_num > high:
					new_note_num -= 72
				trans_result_note_numbers.push_back(new_note_num)
		TransOutOfRangeBehavior.CLAMP:
			for nn in arr:
				new_note_num = clamp(nn, low, high)
				trans_result_note_numbers.push_back(new_note_num)
		TransOutOfRangeBehavior.REMOVE:
			for nn in arr:
				if nn < low || nn > high:
					continue
				trans_result_note_numbers.push_back(nn)
		TransOutOfRangeBehavior.REROLL:
			var mean: float = float(trans_norm_dist_mean_pitch_line_edit.pitch.sevtwo_note_num)
			var dev: float = float(trans_norm_dist_deviation_line_edit.text)
			for nn in arr:
				while nn < low || nn > high:
					# The only way this can happen is if
					# trans_random_type was TransRandomType.NORMAL_DISTRIBUTION.
					assert(trans_random_type == TransRandomType.NORMAL_DISTRIBUTION)
					nn = int(round(box_muller_normal_distribution(mean, dev)))
				if not trans_result_note_numbers.has(nn):
					trans_result_note_numbers.push_back(nn)
	trans_result_note_numbers.sort()
	print("random result: ", trans_result_note_numbers)
			
static func choose(_from: Array, _how_many: int) -> Array:
	var idx: int
	var choices: Array
	var arr: Array = _from.duplicate()
	for i in range(_how_many):
		idx = randi() % arr.size()
		choices.push_back(arr[idx])
		arr.remove(idx)
	return choices
		

func _on_RandomTypeOptionButton_item_selected(_index: int) -> void:
	if forcing_control_value:
		return
	set_trans_random_type(_index, false)
	trans_update()
	
func set_trans_random_type(_trans_random_type: int,\
	_update_trans_random_type_option_button: bool = false) -> void:
	trans_random_type = _trans_random_type
	if _update_trans_random_type_option_button:
		var trans_random_type_option_button: OptionButton = get_node("CanvasLayer/TransformPanel/VBoxContainer/RandomTypeHBoxContainer/HBoxContainer/RandomTypeOptionButton")
		forcing_control_value = true
		trans_random_type_option_button.selected = trans_random_type
		forcing_control_value = false
	var random_range_low_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/RandomRangeLowHBoxContainer")
	var random_range_high_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/RandomRangeHighHBoxContainer")
	var norm_dist_mean_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/NormalDistributionMeanHBoxContainer")
	var norm_dist_deviation_hbox: HBoxContainer = get_node("CanvasLayer/TransformPanel/VBoxContainer/NormalDistributionDeviationHBoxContainer")
	random_range_low_hbox.visible = trans_random_type != TransRandomType.NORMAL_DISTRIBUTION
	random_range_high_hbox.visible = trans_random_type != TransRandomType.NORMAL_DISTRIBUTION
	norm_dist_mean_hbox.visible = trans_random_type == TransRandomType.NORMAL_DISTRIBUTION
	norm_dist_deviation_hbox.visible = trans_random_type == TransRandomType.NORMAL_DISTRIBUTION
	var num_of_elements_heading: Label = get_node("CanvasLayer/TransformPanel/VBoxContainer/RandomNumberOfElementsHBoxContainer/Label")
	if trans_random_type == TransRandomType.PITCH:
		num_of_elements_heading.text = "Number of pitches: "
	elif trans_random_type == TransRandomType.PITCH_CLASS:
		num_of_elements_heading.text = "Number of pitch classes: "

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
	
func trans_update_transpose() -> void:
	assert(transformation == Transformation.TRANSPOSE)
	var interval: Interval = trans_transpose_interval_line_edit.interval
	var index: int = interval.sevtwo_posmod_72
	forcing_control_value = true
	trans_transposition_index_line_edit.text = "T"+str(index)
	forcing_control_value = false
	var sevtwo: int = interval.sevtwo
	if interval.pitch_a.sevtwo_note_num > interval.pitch_b.sevtwo_note_num:
		sevtwo *= -1
	trans_result_note_numbers.clear()
	var new_note_num: int
	for pitch in current_pitch_set.pitches:
		new_note_num = pitch.sevtwo_note_num + sevtwo
		match trans_out_of_range_behavior:
			TransOutOfRangeBehavior.TRANSPOSE:
				new_note_num = transpose_note_num_by_octaves_until_within_instrument_range(\
					new_note_num, current_instrument)
			TransOutOfRangeBehavior.CLAMP:
				new_note_num = clamp_note_num_within_instrument_range(\
					new_note_num, current_instrument)
			TransOutOfRangeBehavior.REMOVE:
				if not note_num_is_within_instrument_range(new_note_num, current_instrument):
					continue
		trans_result_note_numbers.push_back(new_note_num)

func set_trans_result_format(_trans_result_format: int) -> void:
	trans_result_format = _trans_result_format
	trans_update_result_text_edit()
	
func trans_update_result_text_edit() -> void:
	var s: String
	var n: int
	if trans_result_format == TransResultFormat.NOTE_NUMBERS:
		for i in range(trans_result_note_numbers.size()):
			n = trans_result_note_numbers[i]
			s += str(n)
			if i != trans_result_note_numbers.size():
				s += ", "
	elif trans_result_format == TransResultFormat.NOTE_NAMES:
		var pitch: Pitch = Pitch.new()
		for i in range(trans_result_note_numbers.size()):
			pitch.sevtwo_note_num = trans_result_note_numbers[i]
			if not middle_c_is_c4:
				s += pitch.title
			else:
				s += pitch.get_title_c4()
			if i != trans_result_note_numbers.size():
				s += ", "
	elif trans_result_format == TransResultFormat.AC:
		var pitch: Pitch = Pitch.new()
		for i in range(trans_result_note_numbers.size()):
			pitch.sevtwo_note_num = trans_result_note_numbers[i]
			s += pitch.get_title_ac(true, middle_c_is_c4)
			if i != trans_result_note_numbers.size():
				s += " "
	elif trans_result_format == TransResultFormat.FREQUENCIES:
		var pitch: Pitch = Pitch.new()
		for i in range(trans_result_note_numbers.size()):
			pitch.sevtwo_note_num = trans_result_note_numbers[i]
			s += "%.3f" % pitch.freq
			if i != trans_result_note_numbers.size():
				s += " "

	forcing_control_value = true
	trans_result_text_edit.text = s
	forcing_control_value = false
		
	

func transpose_note_num_by_octaves_until_within_instrument_range(_note_num: int, _instrument: int) -> int:
	var inst_str: String = instrument_strings[current_instrument]
	var is_below: bool = _note_num < instrument_data[inst_str]["lowest_sevtwo_number"]
	if is_below:
		while not note_num_is_within_instrument_range(_note_num, current_instrument):
			_note_num += SEVENTY_TWO_INT
	else:
		while not note_num_is_within_instrument_range(_note_num, current_instrument):
			_note_num -= SEVENTY_TWO_INT
	return _note_num
	
func clamp_note_num_within_instrument_range(_note_num: int, _instrument: int) -> int:
	var inst_str: String = instrument_strings[current_instrument]
	return int(clamp(_note_num, instrument_data[inst_str]["lowest_sevtwo_number"],\
		instrument_data[inst_str]["highest_sevtwo_number"]))
		


static func interval_12th_steps_to_dot_format(_twelfth_steps: int) -> String:
	var arr: PoolIntArray
	var abs_ts: int = abs(_twelfth_steps)
	var octs: int = floor(float(abs_ts) / 72.0)
	var rem: int = abs_ts % SEVENTY_TWO_INT
	var hs: int = floor(float(rem) / 6.0)
	rem = rem % 6
	var s: String
	if _twelfth_steps < 0:
		s = "-"
	s += str(octs) + "." + str(hs) + "." + str(rem)
	return s


func _on_TransformationOptionButton_item_selected(_index: int) -> void:
	if forcing_control_value:
		return
	self.transformation = _index


func _on_VoiceLeadCheckBox_toggled(_button_pressed: bool) -> void:
	if forcing_control_value:
		return
	trans_voice_lead = _button_pressed
	

	
static func box_muller_normal_distribution(_mean: float, _deviation: float) -> float:
	var x1: float = randf()
	var x2: float = randf()
	var z1: float = sqrt(-2.0 * log(x1)) * cos(TAU * x2)
	var z2: float = sqrt(-2.0 * log(x1)) * sin(TAU * x2)
	z1 = (z1 * _deviation) + _mean
	return z1
	

static func this_note_num_has_same_pc_as_another(_note_nums: Array, _note_num: int) -> bool:
	var pc: int = posmod(_note_num, SEVENTY_TWO_INT)
	for nn in _note_nums:
		if posmod(nn, SEVENTY_TWO_INT) == pc:
			return true
	return false
	
static func random_note_num(_low: int, _high: int, _out_of_range_behavior: int) -> int:
	assert(_high >= _low)
	var r: int = _high - _low
	var c: int = (randi() % r) + _low
	if c < Pitch.LOWEST_FREQ_SEVTWO_NOTE_NUM\
		|| c > Pitch.HIGHEST_FREQ_SEVTWO_NOTE_NUM:
		match _out_of_range_behavior:
			TransOutOfRangeBehavior.TRANSPOSE:
				if c < Pitch.LOWEST_FREQ_SEVTWO_NOTE_NUM:
					while c < Pitch.LOWEST_FREQ_SEVTWO_NOTE_NUM:
						c += SEVENTY_TWO_INT
				else:
					while c > Pitch.HIGHEST_FREQ_SEVTWO_NOTE_NUM:
						c -= SEVENTY_TWO_INT
			TransOutOfRangeBehavior.CLAMP:
				c = clamp(c, Pitch.LOWEST_FREQ_SEVTWO_NOTE_NUM,\
					Pitch.HIGHEST_FREQ_SEVTWO_NOTE_NUM)
			TransOutOfRangeBehavior.REMOVE:
				continue
			TransOutOfRangeBehavior.REROLL:
				while c < Pitch.LOWEST_FREQ_SEVTWO_NOTE_NUM\
					|| c > Pitch.HIGHEST_FREQ_SEVTWO_NOTE_NUM:
					c = (randi() % r) + _low
	return c

#func set_pitch_line_edit_text(_line_edit: LineEdit, _pitch: Pitch,\
#	_format: int, _force_control_value: bool = true) -> void:
#	if _force_control_value:
#		forcing_control_value = true
#	match _format:
#		TransResultFormat.NOTE_NUMBERS:
#			_line_edit.text = str(_pitch.sevtwo_note_num)
#		TransResultFormat.NOTE_NAMES:
#			if not middle_c_is_c4:
#				_line_edit.text = _pitch.title
#			else:
#				_line_edit.text = _pitch.title_c4
#		TransResultFormat.FREQUENCIES:
#			_line_edit.text = "%.3f" % _pitch.freq
#		TransResultFormat.NOTE_NAMES_NO_OCTAVE:
#			_line_edit.text = _pitch.as_string(false)
#		TransResultFormat.FREQUENCIES_W_HZ:
#			_line_edit.text = _pitch.get_freq_string()
#	if _force_control_value:
#		forcing_control_value = false















func _on_OutOfRangeBehaviorOptionButton_item_selected(_index: int) -> void:
	if forcing_control_value:
		return
	trans_out_of_range_behavior = _index
	trans_update()




##########################################################################################
##### SAVING AND LOADING #################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################




const CHARS_NOT_ALLOWED_IN_CHORD_NAME: PoolStringArray = PoolStringArray([\
	".", "!", "@", "#", "$", "%%", "^", "&", "*", "=", "{", "}", "[", "]", "|", "\\",\
	"?", ":", ";", ".", "/", "\"", "~", "`", "<", ">"
])
var saved_pitch_sets: Dictionary # file name -> pitch set
var saved_chord_file_names: Array
var important_panel_is_open: bool = false # If confirm panel or error panel is open and must be addressed.
onready var save_panel: PanelContainer = get_node("CanvasLayer/SavePanel")
onready var open_panel: PanelContainer = get_node("CanvasLayer/OpenPanel")
onready var confirm_panel: PanelContainer = get_node("CanvasLayer/ConfirmPanel")
onready var error_panel: PanelContainer = get_node("CanvasLayer/ErrorPanel")
onready var notify_panel: PanelContainer = get_node("CanvasLayer/NotifyPanel")
onready var save_button: Button = get_node("CanvasLayer/TopMenu/PanelContainer/HBoxContainer/SaveChordButton")
onready var open_button: Button = get_node("CanvasLayer/TopMenu/PanelContainer/HBoxContainer/OpenChordButton")

onready var sv_name_vbox: VBoxContainer = get_node("CanvasLayer/SavePanel/VBoxContainer/ScrollContainer/HBoxContainer/NameVBoxContainer")
onready var op_name_vbox: VBoxContainer = get_node("CanvasLayer/OpenPanel/VBoxContainer/ScrollContainer/HBoxContainer/NameVBoxContainer")
onready var sv_last_modified_vbox: VBoxContainer = get_node("CanvasLayer/SavePanel/VBoxContainer/ScrollContainer/HBoxContainer/LastModifiedVBoxContainer")
onready var op_last_modified_vbox: VBoxContainer = get_node("CanvasLayer/OpenPanel/VBoxContainer/ScrollContainer/HBoxContainer/LastModifiedVBoxContainer")
onready var sv_pitch_classes_vbox: VBoxContainer = get_node("CanvasLayer/SavePanel/VBoxContainer/ScrollContainer/HBoxContainer/PitchClassesVBoxContainer")
onready var op_pitch_classes_vbox: VBoxContainer = get_node("CanvasLayer/OpenPanel/VBoxContainer/ScrollContainer/HBoxContainer/PitchClassesVBoxContainer")

onready var sv_save_chord_name_line_edit: LineEdit = get_node("CanvasLayer/SavePanel/VBoxContainer/HBoxContainer2/SaveChordNameLineEdit")
onready var op_open_chord_name_line_edit: LineEdit = get_node("CanvasLayer/OpenPanel/VBoxContainer/HBoxContainer2/OpenChordNameLineEdit")

onready var op_scroll_hbox: HBoxContainer = get_node("CanvasLayer/OpenPanel/VBoxContainer/ScrollContainer/HBoxContainer")

var confirm_yes_func: String
var confirm_no_func: String
var error_okay_func: String

enum DateFormat {D_M_Y, M_D_Y, Y_D_M, Y_M_D}
var date_format: int = DateFormat.M_D_Y

enum FileSortMethod {NAME, LAST_MODIFIED, PITCH_CLASSES, PRIME_FORM}
var file_sort_method: int = FileSortMethod.NAME

var op_mouse_file_row: int = -1
var op_last_mouse_file_row: int = -1
var op_selected_file_row: int = -1

func _on_SaveChordButton_toggled(_button_pressed: bool) -> void:
	if forcing_control_value:
		return
	if not important_panel_is_open:
		open_save_panel()
		start_save_pitch_set(current_pitch_set, true)
	else:
		forcing_control_value = true
		save_button.pressed = !_button_pressed
		forcing_control_value = false
	save_button.release_focus()
	
func _on_OpenChordButton_toggled(_button_pressed: bool) -> void:
	if forcing_control_value:
		return
	if not important_panel_is_open:
		update_saved_chord_file_names()
		update_save_and_open_panels()
		open_open_panel()
	else:
		forcing_control_value = true
		open_button.pressed = !_button_pressed
		forcing_control_value = false
	open_button.release_focus()

func start_save_pitch_set(_pitch_set: PitchSet, _force_save_as: bool) -> void:
	update_saved_chord_file_names()
	if _force_save_as || _pitch_set.chord_name == "":
		update_save_and_open_panels()
		open_save_panel()
		return
	if _pitch_set.file_name.empty():
		update_save_and_open_panels()
		open_save_panel()
		return
	# Got here? The _pitch_set already has a name. User pressed Ctrl+S to quick save.
	save_pitch_set(_pitch_set)
	
func save_pitch_set(_pitch_set: PitchSet) -> void:
	var dict: Dictionary = _pitch_set.get_dict_for_saving()
	var file: File = File.new()
	file.open(SAVED_CHORDS_FOLDER_PATH + _pitch_set.file_name, File.WRITE)
	file.store_line(to_json(dict))
	file.close()
	print("Saved \"", _pitch_set.file_name, "\" successfully!")
	
func open_pitch_set(_file_name: String) -> void:
	clear_all_notes()
	var path: String = SAVED_CHORDS_FOLDER_PATH + _file_name
	var file: File = File.new()
	file.open(path, File.READ)
	var dict: Dictionary = parse_json(file.get_as_text())
	file.close()
	var note_num: int
	var button_num: int
	for i in range(dict["note_numbers"].size()):
		note_num = int(dict["note_numbers"][i])
		button_num = note_num_to_button_num(note_num)
		if i != dict["note_numbers"].size() - 1: # If not last element.
			click_button(button_num, current_instrument, false, false, false)
		else:
			click_button(button_num, current_instrument, true, false, false)
	current_pitch_set.file_name = _file_name
	current_pitch_set.pitch_set_name = _file_name.left(_file_name.rfind("."))
	
func pitch_set_with_that_file_name_already_exists(_file_name: String) -> bool:
	return saved_chord_file_names.has(_file_name)

	
func update_save_and_open_panels() -> void:
	# Call after update_saved_chord_file_names().
	var num_of_existing_file_rows: int = sv_name_vbox.get_child_count()
	if num_of_existing_file_rows >= 1 && not sv_name_vbox.get_node("NameLabel0").visible:
		num_of_existing_file_rows -= 1
	if saved_chord_file_names.size() < num_of_existing_file_rows:
		# Need to remove some rows.
		for i in range(saved_chord_file_names.size(), num_of_existing_file_rows):
			remove_file_row(i)
		# Now update the file labels.
		var file_name: String
		for i in range(saved_chord_file_names.size()):
			file_name = saved_chord_file_names[i]
			set_file_row_file_name(file_name, i)
			set_file_row_last_modified_label(file_name, i)
			set_file_row_pitch_classes_label(file_name, i)
	elif saved_chord_file_names.size() > num_of_existing_file_rows:
		# Need to add more rows.
		# First, update as many labels that are currently existing.
		var file_name: String
		for i in range(num_of_existing_file_rows):
			file_name = saved_chord_file_names[i]
			set_file_row_file_name(file_name, i)
			set_file_row_last_modified_label(file_name, i)
			set_file_row_pitch_classes_label(file_name, i)
		# Now add the new ones.
		for i in range(num_of_existing_file_rows, saved_chord_file_names.size()):
			add_file_row(saved_chord_file_names[i])
	elif saved_chord_file_names.size() == num_of_existing_file_rows:
		# Don't need to add or remove any rows.
		# Just update the file labels.
		var file_name: String
		for i in range(saved_chord_file_names.size()):
			file_name = saved_chord_file_names[i]
			set_file_row_file_name(file_name, i)
			set_file_row_last_modified_label(file_name, i)
			set_file_row_pitch_classes_label(file_name, i)

func update_file_rows(_dates_only: bool = false) -> void:
	# This assumes the number of file rows == saved_chord_file_names.size().
	var file_name: String
	if not _dates_only:
		for i in range(saved_chord_file_names.size()):
			file_name = saved_chord_file_names[i]
			set_file_row_file_name(file_name, i)
			set_file_row_last_modified_label(file_name, i)
			set_file_row_pitch_classes_label(file_name, i)
	else:
		for i in range(saved_chord_file_names.size()):
			file_name = saved_chord_file_names[i]
			set_file_row_last_modified_label(file_name, i)

func add_file_row(_file_name: String) -> void:
	var num_of_existing_file_rows: int = sv_name_vbox.get_child_count()
	if not sv_name_vbox.get_node("NameLabel0").visible:
		num_of_existing_file_rows -= 1
	if num_of_existing_file_rows == 0:
		# No need to add new labels, we just make the first one visible.
		set_file_row_file_name(_file_name, 0)
		set_file_row_last_modified_label(_file_name, 0)
		set_file_row_pitch_classes_label(_file_name, 0)
		set_first_file_row_visible(true)
		return
	var sv_name: Label = sv_name_vbox.get_node("NameLabel0").duplicate()
	var op_name: Label = op_name_vbox.get_node("NameLabel0").duplicate()
	var sv_last_modified: Label = sv_last_modified_vbox.get_node("LastModifiedLabel0").duplicate()
	var op_last_modified: Label = op_last_modified_vbox.get_node("LastModifiedLabel0").duplicate()
	var sv_pitch_classes: Label = sv_pitch_classes_vbox.get_node("PitchClassesLabel0").duplicate()
	var op_pitch_classes: Label = op_pitch_classes_vbox.get_node("PitchClassesLabel0").duplicate()

	
	sv_name.name = "NameLabel"+str(num_of_existing_file_rows)
	op_name.name = "NameLabel"+str(num_of_existing_file_rows)
	sv_last_modified.name = "LastModifiedLabel"+str(num_of_existing_file_rows)
	op_last_modified.name = "LastModifiedLabel"+str(num_of_existing_file_rows)
	sv_pitch_classes.name = "PitchClassesLabel"+str(num_of_existing_file_rows)
	op_pitch_classes.name = "PitchClassesLabel"+str(num_of_existing_file_rows)
	
	sv_name_vbox.add_child(sv_name)
	op_name_vbox.add_child(op_name)
	sv_last_modified_vbox.add_child(sv_last_modified)
	op_last_modified_vbox.add_child(op_last_modified)
	sv_pitch_classes_vbox.add_child(sv_pitch_classes)
	op_pitch_classes_vbox.add_child(op_pitch_classes)
	
	if op_name.is_connected("mouse_entered", self, "_on_op_NameLabel_mouse_entered"):
		op_name.disconnect("mouse_entered", self, "_on_op_NameLabel_mouse_entered")
		op_name.disconnect("mouse_exited", self, "_on_op_NameLabel_mouse_exited")
		op_name.disconnect("gui_input", self, "_on_op_NameLabel_gui_input")
		op_last_modified.disconnect("mouse_entered", self, "_on_op_LastModifiedLabel_mouse_entered")
		op_last_modified.disconnect("mouse_exited", self, "_on_op_LastModifiedLabel_mouse_exited")
		op_last_modified.disconnect("gui_input", self, "_on_op_LastModifiedLabel_gui_input")
		op_pitch_classes.disconnect("mouse_entered", self, "_on_op_PitchClassesLabel_mouse_entered")
		op_pitch_classes.disconnect("mouse_exited", self, "_on_op_PitchClassesLabel_mouse_exited")
		op_pitch_classes.disconnect("gui_input", self, "_on_op_PitchClassesLabel_gui_input")
	
	op_name.connect("mouse_entered", self, "_on_op_NameLabel_mouse_entered", [num_of_existing_file_rows])
	op_name.connect("mouse_exited", self, "_on_op_NameLabel_mouse_exited", [num_of_existing_file_rows])
	op_name.connect("gui_input", self, "_on_op_NameLabel_gui_input", [num_of_existing_file_rows])
	op_last_modified.connect("mouse_entered", self, "_on_op_LastModifiedLabel_mouse_entered", [num_of_existing_file_rows])
	op_last_modified.connect("mouse_exited", self, "_on_op_LastModifiedLabel_mouse_exited", [num_of_existing_file_rows])
	op_last_modified.connect("gui_input", self, "_on_op_LastModifiedLabel_gui_input", [num_of_existing_file_rows])
	op_pitch_classes.connect("mouse_entered", self, "_on_op_PitchClassesLabel_mouse_entered", [num_of_existing_file_rows])
	op_pitch_classes.connect("mouse_exited", self, "_on_op_PitchClassesLabel_mouse_exited", [num_of_existing_file_rows])
	op_pitch_classes.connect("gui_input", self, "_on_op_PitchClassesLabel_gui_input", [num_of_existing_file_rows])
	
	set_file_row_file_name(_file_name, num_of_existing_file_rows)
	set_file_row_last_modified_label(_file_name, num_of_existing_file_rows)
	set_file_row_pitch_classes_label(_file_name, num_of_existing_file_rows)
	
func remove_file_row(_row: int) -> void:
	if _row == 0:
		# We never remove the first row, only set it invisible.
		set_first_file_row_visible(false)
		return
	sv_name_vbox.get_node("NameLabel"+str(_row)).free()
	op_name_vbox.get_node("NameLabel"+str(_row)).free()
	sv_last_modified_vbox.get_node("LastModifiedLabel"+str(_row)).free()
	op_last_modified_vbox.get_node("LastModifiedLabel"+str(_row)).free()
	sv_pitch_classes_vbox.get_node("PitchClassesLabel"+str(_row)).free()
	op_pitch_classes_vbox.get_node("PitchClassesLabel"+str(_row)).free()

func set_file_row_file_name(_file_name: String, _row) -> void:
	sv_name_vbox.get_node("NameLabel"+str(_row)).text = _file_name
	op_name_vbox.get_node("NameLabel"+str(_row)).text = _file_name

func set_file_row_last_modified_label(_file_name: String, _row: int) -> void:
	var file: File = File.new()
	var t: int = file.get_modified_time(SAVED_CHORDS_FOLDER_PATH + _file_name)
	var time_dict: Dictionary = OS.get_datetime_from_unix_time(t)
	var s: String
	match date_format:
		DateFormat.D_M_Y:
			s = str(time_dict["day"]) + "-" + str(time_dict["month"]) + "-"\
				+ str(time_dict["year"])
		DateFormat.M_D_Y:
			s = str(time_dict["month"]) + "-" + str(time_dict["day"]) + "-"\
				+ str(time_dict["year"])
		DateFormat.Y_D_M:
			s = str(time_dict["year"]) + "-" + str(time_dict["day"]) + "-"\
				+ str(time_dict["month"])
		DateFormat.Y_M_D:
			s = str(time_dict["year"]) + "-" + str(time_dict["month"]) + "-"\
				+ str(time_dict["day"])
	sv_last_modified_vbox.get_node("LastModifiedLabel"+str(_row)).text = s
	op_last_modified_vbox.get_node("LastModifiedLabel"+str(_row)).text = s
	
func set_file_row_pitch_classes_label(_file_name: String, _row: int) -> void:
	var file: File = File.new()
	file.open(SAVED_CHORDS_FOLDER_PATH + _file_name, File.READ)
	var dict: Dictionary = parse_json(file.get_as_text())
	file.close()
	var s: String
	for i in range(dict["pitch_classes"].size()):
		s += str(dict["pitch_classes"][i])
		if i != dict["pitch_classes"].size() - 1: # If not last element.
			s += ", "
	sv_pitch_classes_vbox.get_node("PitchClassesLabel"+str(_row)).text = s
	op_pitch_classes_vbox.get_node("PitchClassesLabel"+str(_row)).text = s
	
func set_first_file_row_visible(_visible: bool) -> void:
	sv_name_vbox.get_node("NameLabel0").visible = _visible
	op_name_vbox.get_node("NameLabel0").visible = _visible
	sv_last_modified_vbox.get_node("LastModifiedLabel0").visible = _visible
	op_last_modified_vbox.get_node("LastModifiedLabel0").visible = _visible
	sv_pitch_classes_vbox.get_node("PitchClassesLabel0").visible = _visible
	op_pitch_classes_vbox.get_node("PitchClassesLabel0").visible = _visible

func _on_DateFormatOptionButton_item_selected(index: int) -> void:
	if forcing_control_value:
		return
	date_format = index
	update_file_rows(true)
	
func update_file_heading_buttons_pressed() -> void:
	var sv_name_heading_button: Button = get_node("CanvasLayer/SavePanel/VBoxContainer/HBoxContainer3/ChordNameHeadingVBoxContainer/ChordNameHeadingButton")
	var op_name_heading_button: Button = get_node("CanvasLayer/OpenPanel/VBoxContainer/HBoxContainer3/ChordNameHeadingVBoxContainer/ChordNameHeadingButton")
	var sv_last_modified_heading_button: Button = get_node("CanvasLayer/SavePanel/VBoxContainer/HBoxContainer3/LastModifiedHeadingVBoxContainer/LastModifiedHeadingButton")
	var op_last_modified_heading_button: Button = get_node("CanvasLayer/OpenPanel/VBoxContainer/HBoxContainer3/LastModifiedHeadingVBoxContainer/LastModifiedHeadingButton")
	var sv_pitch_classes_heading_button: Button = get_node("CanvasLayer/SavePanel/VBoxContainer/HBoxContainer3/PitchClassesHeadingVBoxContainer/PitchClassesHeadingButton")
	var op_pitch_classes_heading_button: Button = get_node("CanvasLayer/OpenPanel/VBoxContainer/HBoxContainer3/PitchClassesHeadingVBoxContainer/PitchClassesHeadingButton")
	forcing_control_value = true
	match file_sort_method:
		FileSortMethod.NAME:
			sv_name_heading_button.pressed = true
			op_name_heading_button.pressed = true
			sv_last_modified_heading_button.pressed = false
			op_last_modified_heading_button.pressed = false
			sv_pitch_classes_heading_button.pressed = false
			op_pitch_classes_heading_button.pressed = false
		FileSortMethod.LAST_MODIFIED:
			sv_name_heading_button.pressed = false
			op_name_heading_button.pressed = false
			sv_last_modified_heading_button.pressed = true
			op_last_modified_heading_button.pressed = true
			sv_pitch_classes_heading_button.pressed = false
			op_pitch_classes_heading_button.pressed = false
		FileSortMethod.PITCH_CLASSES:
			sv_name_heading_button.pressed = false
			op_name_heading_button.pressed = false
			sv_last_modified_heading_button.pressed = false
			op_last_modified_heading_button.pressed = false
			sv_pitch_classes_heading_button.pressed = true
			op_pitch_classes_heading_button.pressed = true
	forcing_control_value = false
		
func _on_ChordNameHeadingButton_toggled(button_pressed: bool) -> void:
	if forcing_control_value:
		return
	if file_sort_method != FileSortMethod.NAME:
		file_sort_method = FileSortMethod.NAME
		update_saved_chord_file_names()
		update_file_rows()
	update_file_heading_buttons_pressed()


func _on_LastModifiedHeadingButton_toggled(button_pressed: bool) -> void:
	if forcing_control_value:
		return
	if file_sort_method != FileSortMethod.LAST_MODIFIED:
		file_sort_method = FileSortMethod.LAST_MODIFIED
		update_saved_chord_file_names()
		update_file_rows()
	update_file_heading_buttons_pressed()

func _on_SavePitchClassesHeadingButton_toggled(button_pressed: bool) -> void:
	if forcing_control_value:
		return
	if file_sort_method != FileSortMethod.PITCH_CLASSES:
		file_sort_method = FileSortMethod.PITCH_CLASSES
		update_saved_chord_file_names()
		update_file_rows()
	update_file_heading_buttons_pressed()


func _on_SaveChordNameLineEdit_text_changed(new_text: String) -> void:
	if forcing_control_value:
		return



func _on_CancelSaveButton_pressed():
	close_save_panel()

func close_save_panel() -> void:
	save_panel.visible = false
	forcing_control_value = true
	save_button.pressed = false
	forcing_control_value = false
	important_panel_is_open = false
	
func close_open_panel() -> void:
	open_panel.visible = false
	forcing_control_value = true
	open_button.pressed = false
	forcing_control_value = false
	important_panel_is_open = false
	
func open_save_panel() -> void:
	save_panel.visible = true
	forcing_control_value = true
	save_button.pressed = true
	forcing_control_value = false
	important_panel_is_open = true
	
func open_open_panel() -> void:
	op_selected_file_row = -1
	op_update_file_row_colors(op_mouse_file_row, op_selected_file_row)
	open_panel.visible = true
	forcing_control_value = true
	open_button.pressed = true
	forcing_control_value = false
	important_panel_is_open = true
	


func sanitize_chord_name(_chord_name: String) -> String:
	_chord_name = _chord_name.strip_edges().strip_escapes()
	while _chord_name.find("  ") != -1:
		_chord_name = _chord_name.replace("  ", " ")
	for c in CHARS_NOT_ALLOWED_IN_CHORD_NAME:
		_chord_name = _chord_name.replace(c, "")
	return _chord_name
	
func _on_SaveChordNameLineEdit_text_entered(new_text: String) -> void:
	if forcing_control_value:
		return
	_on_SaveButton_pressed()

func _on_OpenChordNameLineEdit_text_entered(new_text: String) -> void:
	if forcing_control_value:
		return
	# TODO: Autofill text thing.
	_on_OpenButton_pressed()
	
	
func _on_SaveButton_pressed():
	# This is the save button within the save_panel, not the button at the top
	# that opens the save_panel.
	var chord_name: String = sv_save_chord_name_line_edit.text
	chord_name = sanitize_chord_name(chord_name)
	var file_name: String = chord_name + ".save"
	forcing_control_value = true
	sv_save_chord_name_line_edit.text = chord_name
	forcing_control_value = false
	if not file_name.is_valid_filename():
		open_error_panel("Sorry, \""+chord_name+"\" is not a valid file name. "\
			+ "Only letters, numbers, _, ,, -, +, (, and ) are allowed.", "Okay", "")
	elif pitch_set_with_that_file_name_already_exists(file_name):
		open_confirm_panel("A file with this name already exists. Do you wish to overwrite it?",\
			"Overwrite", "Cancel",\
			"yes_overwrite_file", "")
	else:
		# Good to go!
		current_pitch_set.pitch_set_name = chord_name
		current_pitch_set.file_name = file_name
		save_pitch_set(current_pitch_set)
		close_save_panel()
		

func yes_overwrite_file() -> void:
	var chord_name: String = sv_save_chord_name_line_edit.text
	chord_name = sanitize_chord_name(chord_name)
	var file_name: String = chord_name + ".save"
	forcing_control_value = true
	sv_save_chord_name_line_edit.text = chord_name
	forcing_control_value = false
	current_pitch_set.pitch_set_name = chord_name
	current_pitch_set.file_name = file_name
	save_pitch_set(current_pitch_set)
	close_save_panel()
	



func _on_CancelOpenButton_pressed():
	close_open_panel()

func _on_OpenButton_pressed():
	# This is the open button within the open_panel, not the button at the top
	# that opens the open_panel.
	var file_name: String = op_open_chord_name_line_edit.text
	var file: File = File.new()
	if file.file_exists(SAVED_CHORDS_FOLDER_PATH + file_name):
		open_pitch_set(file_name)
	close_open_panel()

	
func op_update_op_file_mouse_row() -> void:
	#### TODO: Probably use the mouse_entered signals from the labels instead of this.
	#### You'll need to set the mouse filter of the labels to something beside IGNORE.
#	var m: Vector2 = get_global_mouse_position()
	if not open_panel.visible:
		op_mouse_file_row = -1
	else:
		var m: Vector2 = op_name_vbox.get_local_mouse_position()#ca_ivl_pitch_a_vbox.get_local_mouse_position()
#		print("m.y: ", m.y)
		if m.y < 0:
			op_mouse_file_row = -1
		else:
			op_mouse_file_row = floor((m.y) / op_file_row_height)
			op_mouse_file_row = min(op_mouse_file_row, saved_chord_file_names.size() - 1)
	if op_mouse_file_row != op_last_mouse_file_row: # Changed rows.
		op_update_file_row_colors(op_mouse_file_row)
		update()
	update_debug_label()

func _on_OpenChordNameLineEdit_text_changed(new_text: String) -> void:
	if forcing_control_value:
		return
	var last: int = op_selected_file_row
	op_selected_file_row = -1
	if op_selected_file_row != last:
		op_update_file_row_colors(op_mouse_file_row, op_selected_file_row)
	# TODO: That autofill text thing that search queries do.


func open_confirm_panel(_text: String, _yes_text: String, _no_text: String,\
	_yes_function: String, _no_function: String) -> void:
	var main_label: Label = confirm_panel.get_node("VBoxContainer/CenterContainer/ConfirmLabel")
	var yes_button: Button = confirm_panel.get_node("VBoxContainer/HBoxContainer/YesButton")
	var no_button: Button = confirm_panel.get_node("VBoxContainer/HBoxContainer/NoButton")
	main_label.text = _text
	yes_button.text = _yes_text
	no_button.text = _no_text
	# Set the functions to call if the user presses the yes or no buttons on the
	# confirm panel.
	confirm_yes_func = _yes_function
	confirm_no_func = _no_function
	# Set the confirm panel to the center.
	var sz: Vector2 = confirm_panel.rect_size * confirm_panel.rect_scale
	confirm_panel.rect_position = Vector2(screen_size.x * 0.5 - sz.x * 0.5,\
		screen_size.y * 0.5 - sz.y * 0.5)
	confirm_panel.visible = true
	important_panel_is_open = true


func _on_NoButton_pressed():
	confirm_panel.visible = false
	# Note: We don't set important_panel_is_open to false here,
	# because there still might be another important window open.
	# Set it to false if neccessary on the confirm_no_func.
	if confirm_no_func.empty():
		return
	var no_func: FuncRef = funcref(self, confirm_no_func)
	no_func.call_func()


func _on_YesButton_pressed():
	confirm_panel.visible = false
	# Note: We don't set important_panel_is_open to false here,
	# because there still might be another important window open.
	# Set it to false if neccessary on the confirm_yes_func.
	if confirm_yes_func.empty():
		return
	var yes_func: FuncRef = funcref(self, confirm_yes_func)
	yes_func.call_func()


func open_error_panel(_text: String, _okay_text: String,\
	_okay_func: String) -> void:
	var main_label: Label = error_panel.get_node("VBoxContainer/CenterContainer/ErrorLabel")
	var okay_button: Button = error_panel.get_node("VBoxContainer/HBoxContainer/OkayButton")
	main_label.text = _text
	okay_button.text = _okay_text
	error_okay_func = _okay_func
	# Set the error panel to the center.
	var sz: Vector2 = error_panel.rect_size * error_panel.rect_scale
	error_panel.rect_position = Vector2(screen_size.x * 0.5 - sz.x * 0.5,\
		screen_size.y * 0.5 - sz.y * 0.5)
	error_panel.visible = true
	important_panel_is_open = true

func _on_ErrorOkayButton_pressed():
	error_panel.visible = false
	# Note: We don't set important_panel_is_open to false here,
	# because there still might be another important window open.
	# Set it to false if neccessary on the error_okay_func.
	if error_okay_func.empty():
		return
	var okay_func: FuncRef = funcref(self, error_okay_func)
	okay_func.call_func()



	


func sort_files_by_last_modified(_a: String, _b: String) -> bool:
	var file: File = File.new()
	var a_time: int = file.get_modified_time(_a)
	var b_time: int = file.get_modified_time(_b)
	return a_time >= b_time

func sort_files_by_pitch_classes(_a: Array, _b: Array) -> bool:
	var a_pcs: Array = _a[1]
	var b_pcs: Array = _b[1]
	var itr: int = 0
	while itr < a_pcs.size() && itr < b_pcs.size():
		if a_pcs[itr] < b_pcs[itr]:
			return true
		if a_pcs[itr] > b_pcs[itr]:
			return false
		itr += 1
	return true


func update_saved_chord_file_names() -> void:
	var dir: Directory = Directory.new()
	dir.open(SAVED_CHORDS_FOLDER_PATH)
	saved_chord_file_names.clear()
	var file_name: String
	dir.list_dir_begin(true, true)
	file_name = dir.get_next()
	while file_name != "":
		saved_chord_file_names.push_back(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	match file_sort_method:
		FileSortMethod.NAME:
			saved_chord_file_names.sort()
		FileSortMethod.LAST_MODIFIED:
			saved_chord_file_names.sort_custom(self, "sort_files_by_last_modified")
		FileSortMethod.PITCH_CLASSES:
			var file: File = File.new()
			var arr: Array
			for fn in saved_chord_file_names:
				file.open(SAVED_CHORDS_FOLDER_PATH + fn, File.READ)
				var dict: Dictionary = parse_json(file.get_as_text())
				file.close()
				arr.push_back([fn, dict["pitch_classes"].duplicate()])
			arr.sort_custom(self, "sort_files_by_pitch_classes")
			saved_chord_file_names.clear()
			for subarr in arr:
				saved_chord_file_names.push_back(subarr[0])
		FileSortMethod.PRIME_FORM:
			var file: File = File.new()
			var arr: Array
			for fn in saved_chord_file_names:
				file.open(SAVED_CHORDS_FOLDER_PATH + fn, File.READ)
				var dict: Dictionary = parse_json(file.get_as_text())
				file.close()
				arr.push_back([fn, dict["prime_form"].duplicate()])
			arr.sort_custom(self, "sort_files_by_pitch_classes")
			saved_chord_file_names.clear()
			for subarr in arr:
				saved_chord_file_names.push_back(subarr[0])

func _on_PlaybackCentRandomizationLineEdit_text_entered(new_text: String) -> void:
	if forcing_control_value:
		return
	cent_random_width = float(abs(float(new_text))) * 2.0
	var line_edit: LineEdit = get_node("CanvasLayer/SettingsPanelContainer/VBoxContainer/HBoxContainer9/PlaybackCentRandomizationLineEdit")
	forcing_control_value = true
	line_edit.text = "%.2f" % (cent_random_width * 0.5)
	forcing_control_value = false
	drop_control_focus(line_edit)

func _on_op_NameLabel_mouse_entered(_row: int) -> void:
	if _row != op_last_mouse_file_row:
		op_mouse_file_row = _row
		op_last_mouse_file_row = _row
		op_update_file_row_colors(op_mouse_file_row, op_selected_file_row)



func _on_op_LastModifiedLabel_mouse_entered(_row: int) -> void:
	if _row != op_last_mouse_file_row:
		op_mouse_file_row = _row
		op_last_mouse_file_row = _row
		op_update_file_row_colors(op_mouse_file_row, op_selected_file_row)

	
func _on_op_PitchClassesLabel_mouse_entered(_row: int) -> void:
	if _row != op_last_mouse_file_row:
		op_mouse_file_row = _row
		op_last_mouse_file_row = _row
		op_update_file_row_colors(op_mouse_file_row, op_selected_file_row)


func _on_op_NameLabel_mouse_exited(_row: int) -> void:
	# mouse_exited seems to always be called before mouse_entered.
	op_mouse_file_row = -1
	op_last_mouse_file_row = -1
	op_update_file_row_colors(op_mouse_file_row, op_selected_file_row)


func _on_op_LastModifiedLabel_mouse_exited(_row: int) -> void:
	# mouse_exited seems to always be called before mouse_entered.
	op_mouse_file_row = -1
	op_last_mouse_file_row = -1
	op_update_file_row_colors(op_mouse_file_row, op_selected_file_row)


func _on_op_PitchClassesLabel_mouse_exited(_row: int) -> void:
	# mouse_exited seems to always be called before mouse_entered.
	op_mouse_file_row = -1
	op_last_mouse_file_row = -1
	op_update_file_row_colors(op_mouse_file_row, op_selected_file_row)



func _on_op_NameLabel_gui_input(_event: InputEvent, _row: int) -> void:
	if _event is InputEventMouseButton && _event.is_pressed() && not _event.is_echo():
		if _event.button_index == 1: # Left mouse button.
			op_selected_file_row = _row
			op_update_file_row_colors(op_mouse_file_row, op_selected_file_row)
			var file_name: String = op_get_file_name_of_file_row(_row)
			forcing_control_value = true
			op_open_chord_name_line_edit.text = file_name
			forcing_control_value = false

func _on_op_LastModifiedLabel_gui_input(_event: InputEvent, _row: int) -> void:
	if _event is InputEventMouseButton && _event.is_pressed() && not _event.is_echo():
		if _event.button_index == 1: # Left mouse button.
			op_selected_file_row = _row
			op_update_file_row_colors(op_mouse_file_row, op_selected_file_row)
			var file_name: String = op_get_file_name_of_file_row(_row)
			forcing_control_value = true
			op_open_chord_name_line_edit.text = file_name
			forcing_control_value = false

func _on_op_PitchClassesLabel_gui_input(_event: InputEvent, _row: int) -> void:
	if _event is InputEventMouseButton && _event.is_pressed() && not _event.is_echo():
		if _event.button_index == 1: # Left mouse button.
			op_selected_file_row = _row
			op_update_file_row_colors(op_mouse_file_row, op_selected_file_row)
			var file_name: String = op_get_file_name_of_file_row(_row)
			forcing_control_value = true
			op_open_chord_name_line_edit.text = file_name
			forcing_control_value = false
			
func op_get_file_name_of_file_row(_row: int) -> String:
	return op_name_vbox.get_node("NameLabel"+str(_row)).text

