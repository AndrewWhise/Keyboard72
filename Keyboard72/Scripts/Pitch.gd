extends Reference

class_name Pitch

# sevtwo_note_num 0 is the lowest C on the piano.
# sevtwo_note_num 504 is the highest C on the piano.
# sevtwo_note_num -18 is the lowest A on the piano.
# sevtwo_note_num 216 is Middle C.
# sevtwo_note_num 270 is A440.

var is_initializing: bool = true

const LOWEST_FREQ: float = 16.351597831288387 # Octave below lowest C on piano. AKA C-1
# LOWEST_FREQ midi number is 12, so the lowest C on piano is midi number 24
const LOW_C_FREQ: float = 32.70319566257637 # Lowest C on piano, AKA C0, midi number 24
const HIGHEST_C_ON_PIANO_FREQ: float = 4186.01 # C7, midi number 108
const HIGHEST_FREQ: float = 8453.007013676031 #C8, octave above highest C on piano, midi number 120, + 16.67c # #8372.02 # C8, octave above highest C on piano, midi_number 120 #7902.13 # B7, maj# midi number 
const LOWEST_OCTAVE: int = -1
const HIGHEST_OCTAVE: int = 8
const NEG_ONE: int = -1
const MIDDLE_C_FREQ: float = 261.6255653006011
const TWELVE_HUNDRED: float = 1200.0
const ONE_HUNDRED: float = 100.0
const FIFTY: float = 50.0
const TWO: float = 2.0
const SIX: float = 6.0
enum PitchClass {C, Db, D, Eb, E, F, Gb, G, Ab, A, Bb, B}
const FLAT_NOTE_NAMES: Array = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
const SHARP_NOTE_NAMES: Array = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
const VALID_NOTE_NAMES: Array = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B",\
	"C#", "D#", "E#", "F#", "G#", "A#", "B#", "Cb"]
const MIDDLE_C_MIDI_NUMBER: int = 60
const MIDI_NUMBER_MAX: int = 120 # C8, an octave above highest C on piano.
const MIDI_NUMBER_MIN: int = 12 # C-1, an octave below lowest C on piano
const LOWEST_C_ON_PIANO_MIDI_NUMBER: int = 24
const HIGHEST_C_ON_PIANO_MIDI_NUMBER: int = 108
const LOWEST_FREQ_SEVTWO_NOTE_NUM: int = -72 # 1 octave below lowest C on piano.
const HIGHEST_FREQ_SEVTWO_NOTE_NUM: int = 577
const HIGHEST_C_ON_PIANO_SEVTWO_NOTE_NUM: int = 505
const SEVTWO_INTERVAL: float = 100.0 / 6.0
const MIDDLE_C_SEVTWO_NOTE_NUM: int = 216
const LAST_VARS: Array = ["freq", "octave", "cents", "pitch_class", "note_name", "enharmonic",\
	"midi_number", "title", "sevtwo_note_num", "sevtwo_pitch_class", "sevtwo_error_from_freq"]
const BLACK_KEYS_12TET_PITCH_CLASSES: Array = [1,3,6,8,10]
const NUMBERS: Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
const NUMBERS_AND_NEG: Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-"]
const NUMBERS_NEG_AND_DOT: Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "."]
const ALLOWED_CHARS: Array = ["C", "D", "E", "F", "G", "A", "B",\
	"c", "d", "e", "f", "g", "a", "b",\
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", ".", "#"]
const UNSTARTABLE_CHARS: Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9",\
	"+", "-", ".", "#", " "] 
# Chars from ALLOWED_CHARS that the note_name cannot begin with.
const ALLOWED_CHARS_IN_TITLE: Array = ["C", "D", "E", "F", "G", "A", "B",\
	"c", "d", "e", "f", "g", "a", "b",\
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "-", ".", "#", " ", "'", ","]

export(float, 16.351597831288387, 8453.007013676031, 0.001) var freq: float = 440.0 setget set_freq, get_freq # same as hz
var hz: float = 440.0 setget set_freq, get_freq # alias of freq
export(int, -1, 7) var octave: int = 3 setget set_octave, get_octave # middle C is C3
var octave_c4: int setget , get_octave_c4
export(String, "C", "Db", "D", "Eb", "E", "F",\
	"Gb", "G", "Ab", "A", "Bb", "B") var note_name: String = "A" setget set_note_name, get_note_name
# NOTE: note_name does NOT include the octave number in its string.
enum Enharm {FLAT, SHARP}
export(Enharm) var enharmonic: int = Enharm.FLAT setget set_enharmonic
var flat_note_name: String = "A" setget set_note_name, get_flat_note_name
var sharp_note_name: String = "A" setget set_note_name, get_sharp_note_name
export(PitchClass) var pitch_class: int = 9 setget set_pitch_class, get_pitch_class
export(float, -50.0, 50.0) var cents: float = 0.0 setget set_cents, get_cents

export(int, 12, 120) var midi_number: int = 69 setget set_midi_number, get_midi_number

export(int, 0, 71) var sevtwo_pitch_class: int = 54 setget set_sevtwo_pitch_class
export(int, -72, 577) var sevtwo_note_num: int = 270 setget set_sevtwo_note_num
var sevtwo_error_from_freq: float = 0.0 # in cents

var sevtwo_rank: int = 0
var sevtwo_rank_ac: String = "" # apostrophes for plus, commas for minus

export(String) var title: String = "A3 +0.00c" setget set_title, get_title
var title_c4: String = "A4 +0.00c" setget set_title_c4, get_title_c4

var playback_speed: float = 1.0 setget , get_playback_speed

var is_black_key: bool = false
var is_right_of_stem: bool = true # Changed with NoteGroup.gd and GrandStaff.gd
var is_part_of_cluster: bool = false # Changed with NoteGroup.gd and GrandStaff.gd
var staff_number: int # Changed with NoteGroup.gd and GrandStaff.gd
var note_group_idx: int # Changed with NoteGroup.gd and GrandStaff.gd
var staff_y_pos: float # Changed with NoteGroup.gd and GrandStaff.gd
var accidental_str: String # Changed with NoteGroup.gd and GrandStaff.gd
#var accidental_name: String # Changed with NoteGroup.gd and GrandStaff.gd
var active_pitches_idx: int = -1 # Changed with NoteGroup.gd and GrandStaff.gd
var last_pitch_data: Dictionary
signal pitch_changed(new_freq)



#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################

func set_freq(_freq: float) -> void:
	if is_initializing:
		freq = _freq
		return
	update_last_pitch_data()
	freq = clamp(_freq, LOWEST_FREQ, HIGHEST_FREQ)
	var c_interval: float = cent_interval(LOW_C_FREQ, freq)
	
	# freq is c_interval many cents above the lowest C in the piano.
	var c_1200: float = c_interval / TWELVE_HUNDRED
	if is_whole_number(c_1200):
		octave = int(round(c_1200))
	else:
		octave = int(floor(c_1200))

	var c_rem: float = c_interval - float(octave * 1200)
	var c_100: float = c_rem / ONE_HUNDRED
	var c_100_round: float = round(c_100)
	pitch_class = posmod(int(c_100_round), 12)
	is_black_key = BLACK_KEYS_12TET_PITCH_CLASSES.has(pitch_class)
	cents = (c_100 - c_100_round) * 100.0
	
	midi_number = ((octave + 2) * 12) + pitch_class
	
	flat_note_name = FLAT_NOTE_NAMES[pitch_class]
	sharp_note_name = SHARP_NOTE_NAMES[pitch_class]
	if enharmonic == Enharm.FLAT:
		note_name = flat_note_name
	else:
		note_name = sharp_note_name
	while octave >= HIGHEST_OCTAVE && note_name != "C":
		# C8 is the only note allowed in octave 8.
		octave -= 1
		freq *= 0.5
		midi_number -= 12
	if note_name == "A" && octave >= 0 && cents == 0.0:
		freq = round(freq)
	update_sevtwo_stuff()
	property_list_changed_notify()
	emit_pitch_changed()
	
	

func get_freq() -> float:
	return freq

func set_octave(_octave: int) -> void:
	if is_initializing:
		octave = _octave
		return
	update_last_pitch_data()
	octave = clamp(_octave, LOWEST_OCTAVE, HIGHEST_OCTAVE)
	if octave >= HIGHEST_OCTAVE && note_name != "C":
		# C8 is the only note allowed in octave 8.
		octave = HIGHEST_OCTAVE - 1
	var halfsteps: int = FLAT_NOTE_NAMES.find(flat_note_name)
	var freq_a: float = LOW_C_FREQ * pow(TWO, octave)
	var c: float = float(halfsteps * 100) + cents
	freq = pow(TWO, c / TWELVE_HUNDRED) * freq_a
	if note_name == "A" && octave >= 0 && cents == 0.0:
		freq = round(freq)
	
	midi_number = ((octave + 2) * 12) + pitch_class
	update_sevtwo_stuff()
	property_list_changed_notify()
	emit_pitch_changed()
	
func get_octave() -> int:
	return octave
func get_octave_c4() -> int:
	return octave + 1
	
func set_note_name(_note_name: String) -> void:
	if not VALID_NOTE_NAMES.has(_note_name):
		print(_note_name, " is not a valid note_name")
		return
	if is_initializing:
		note_name = _note_name
		return
	update_last_pitch_data()
	note_name = _note_name
	# Sanitize the note name first.
	match note_name:
		"Cb":
			note_name = "B"
			octave -= 1
		"B#":
			note_name = "C"
			octave += 1
		"E#":
			note_name = "F"
		"Fb":
			note_name = "E"
	if note_name.length() > 1: # Black key
		if note_name[1] == "b":
			if enharmonic == Enharm.SHARP:
				enharmonic = Enharm.FLAT
			flat_note_name = note_name
			sharp_note_name = flip_enharmonic(flat_note_name)
		elif note_name[1] == "#":
			if enharmonic == Enharm.FLAT:
				enharmonic = Enharm.SHARP
			sharp_note_name = note_name
			flat_note_name = flip_enharmonic(sharp_note_name)
	else: # White key
		flat_note_name = note_name
		sharp_note_name = note_name
		assert(flat_note_name == sharp_note_name && sharp_note_name == note_name)
		
	if octave == HIGHEST_OCTAVE && note_name != "C":
		# C8 is the only note allowed in octave 8. (and C8 + 16.67c)
		octave = HIGHEST_OCTAVE - 1
		
	pitch_class = FLAT_NOTE_NAMES.find(flat_note_name)
	is_black_key = BLACK_KEYS_12TET_PITCH_CLASSES.has(pitch_class)
	assert(pitch_class != -1)
	var freq_a: float = LOW_C_FREQ * pow(TWO, octave)
	var c: float = float(pitch_class * 100) + cents
	freq = pow(TWO, c / TWELVE_HUNDRED) * freq_a
	# After calculating freq, it's possible we're off ever so slightly (negligible).
	# A is 440, so every A at octave 0 or greater will be a whole number frequency.
	# We want A 440 to always be A 440, so we round any note A with octave >= 0 to a whole number.
	if note_name == "A" && octave >= 0 && cents == 0.0:
		freq = round(freq)
		
	midi_number = ((octave + 2) * 12) + pitch_class
	update_sevtwo_stuff()
	property_list_changed_notify()
	emit_pitch_changed()
		
func get_note_name() -> String:
	if enharmonic == Enharm.FLAT:
		return flat_note_name
	return sharp_note_name
func get_flat_note_name() -> String:
	return flat_note_name
func get_sharp_note_name() -> String:
	return sharp_note_name

func set_enharmonic(_enharmonic: int) -> void:
	assert(_enharmonic == 0 || _enharmonic == 1)
	enharmonic = _enharmonic
	if enharmonic == Enharm.SHARP:
		self.note_name = sharp_note_name
	else:
		self.note_name = flat_note_name

func set_pitch_class(_pitch_class: int) -> void:
	if is_initializing:
		pitch_class = _pitch_class
		is_black_key = BLACK_KEYS_12TET_PITCH_CLASSES.has(pitch_class)
		return
	pitch_class = posmod(_pitch_class, 12)
	self.flat_note_name = FLAT_NOTE_NAMES[pitch_class]
	
func get_pitch_class() -> int:
	return pitch_class
	

	
func set_cents(_cents: float) -> void:
	if is_initializing:
		cents = _cents
		return
	update_last_pitch_data()
	cents = clamp(_cents, -50.0, 50.0)
	if abs(_cents) <= FIFTY: 
		cents = _cents#clamp(_cents, -FIFTY, FIFTY)
		if is_zero_approx(cents):
			cents = 0.0
		var freq_a: float = LOW_C_FREQ * pow(TWO, octave)
		# freq_a is frequency of closest C below us.
		var c: float = float(pitch_class * 100) + cents
		freq = pow(TWO, c / TWELVE_HUNDRED) * freq_a
		if note_name == "A" && octave >= 0 && cents == 0.0:
			freq = round(freq)
		if freq < LOWEST_FREQ:
			self.freq = LOWEST_FREQ
		elif freq > HIGHEST_FREQ:
			self.freq = HIGHEST_FREQ
		else:
			is_black_key = BLACK_KEYS_12TET_PITCH_CLASSES.has(pitch_class)
			update_sevtwo_stuff()
			property_list_changed_notify()
			emit_pitch_changed()
	else: # abs(_cents) > FIFTY
		var c: float = _cents
		var _iter: int = 1
		while c < -FIFTY:
			c += 100
			pitch_class -= 1
			if pitch_class < 0:
				pitch_class = 11
				octave -= 1
			_iter += 1
		while c >= FIFTY: # was c > FIFTY
			c -= 100
			pitch_class += 1
			if pitch_class > 11:
				pitch_class = 0
				octave += 1
			_iter += 1
		cents = c
		if is_zero_approx(cents):
			cents = 0.0
		flat_note_name = FLAT_NOTE_NAMES[pitch_class]
		sharp_note_name = SHARP_NOTE_NAMES[pitch_class]
		if enharmonic == Enharm.FLAT:
			note_name = flat_note_name
		else:
			note_name = sharp_note_name
		var freq_a: float = LOW_C_FREQ * pow(TWO, octave)
		var c2: float = float(pitch_class * 100) + cents
		freq = pow(TWO, c2 / TWELVE_HUNDRED) * freq_a
		if note_name == "A" && octave >= 0 && cents == 0.0:
			freq = round(freq)
		midi_number = ((octave + 2) * 12) + pitch_class
		if freq < LOWEST_FREQ:
			self.freq = LOWEST_FREQ
		elif freq > HIGHEST_FREQ:
			self.freq = HIGHEST_FREQ
		else:
			is_black_key = BLACK_KEYS_12TET_PITCH_CLASSES.has(pitch_class)
			update_sevtwo_stuff()
			property_list_changed_notify()
			emit_pitch_changed()
			
func get_cents() -> float:
	return cents
	
func set_midi_number(_midi_number: int) -> void:
	if is_initializing:
		midi_number = _midi_number
		return
	midi_number = clamp(_midi_number, MIDI_NUMBER_MIN, MIDI_NUMBER_MAX)
	var m_12: float = float(midi_number - 12) / 12.0
	if is_whole_number(m_12):
		octave = int(round(m_12)) - 1
	else:
		octave = int(floor(m_12)) - 1
	# Minus 1 because our lowest possible frequency is C-1
	self.pitch_class = midi_number % 12
	
func get_midi_number() -> int:
	return midi_number
	
func set_sevtwo_pitch_class(_pc_72: int) -> void:
	if is_initializing:
		sevtwo_pitch_class = _pc_72
		return
	update_last_pitch_data()
	var last: int = sevtwo_pitch_class
	sevtwo_pitch_class = posmod(_pc_72, 72)
	if freq == HIGHEST_FREQ:
		sevtwo_pitch_class = 0
		sevtwo_note_num = HIGHEST_FREQ_SEVTWO_NOTE_NUM
		cents = 0.0
		sevtwo_error_from_freq = 0.0
		property_list_changed_notify()
		emit_pitch_changed()
		return
	sevtwo_rank = posmod(sevtwo_pitch_class + 3, 6) - 3
	sevtwo_rank_ac = rank_to_ac(sevtwo_rank)
	var diff: int = sevtwo_pitch_class - last
	sevtwo_note_num += diff
	cents = SEVTWO_INTERVAL * float(sevtwo_rank)
	sevtwo_error_from_freq = 0.0
	
	
	var freq_a: float = LOW_C_FREQ * pow(TWO, octave)
	var c: float = float(pitch_class * 100) + cents
	freq = pow(TWO, c / TWELVE_HUNDRED) * freq_a
	
	pitch_class = posmod(int(round(float(sevtwo_pitch_class) / SIX)), 12)
	is_black_key = BLACK_KEYS_12TET_PITCH_CLASSES.has(pitch_class)
	midi_number = LOWEST_C_ON_PIANO_MIDI_NUMBER + (octave * 12) + pitch_class

	flat_note_name = FLAT_NOTE_NAMES[pitch_class]
	sharp_note_name = SHARP_NOTE_NAMES[pitch_class]
	if enharmonic == Enharm.FLAT:
		note_name = flat_note_name
	else:
		note_name = sharp_note_name
	property_list_changed_notify()
	emit_pitch_changed()
			

#func get_sevtwo_rank_OLD() -> int:
#	if cents >= 50.0 - (100.0 / 12.0):
#		return 3
#	return posmod(sevtwo_pitch_class + 3, 6) - 3

func get_sevtwo_rank(_sevtwo_pitch_class: int) -> int:
	# Returns -3, -2, -1, 0, 1, or 2. Never 3.
	return posmod(_sevtwo_pitch_class + 3, 6) - 3

func set_sevtwo_note_num(_sevtwo_note_num: int) -> void:
	if is_initializing:
		sevtwo_note_num = _sevtwo_note_num
		return
	update_last_pitch_data()
	sevtwo_note_num = clamp(_sevtwo_note_num, LOWEST_FREQ_SEVTWO_NOTE_NUM,\
		HIGHEST_FREQ_SEVTWO_NOTE_NUM)
	var closest_halfsteps: int = int(round(float(sevtwo_note_num) / SIX))
	var s_72: float = float(sevtwo_note_num) / 72.0
	if is_whole_number(s_72):
		octave = int(round(s_72))
	else:
		octave = int(floor(s_72))
	
	var y: int = octave * 72
	sevtwo_pitch_class = sevtwo_note_num - y
	if sevtwo_pitch_class >= 69:
		octave += 1
		
	octave = octave
	pitch_class = posmod(int(round(float(sevtwo_pitch_class) / SIX)), 12)
	is_black_key = BLACK_KEYS_12TET_PITCH_CLASSES.has(pitch_class)
	midi_number = LOWEST_C_ON_PIANO_MIDI_NUMBER + (octave * 12) + pitch_class

	flat_note_name = FLAT_NOTE_NAMES[pitch_class]
	sharp_note_name = SHARP_NOTE_NAMES[pitch_class]
	if enharmonic == Enharm.FLAT:
		note_name = flat_note_name
	else:
		note_name = sharp_note_name
	sevtwo_rank = posmod(sevtwo_pitch_class + 3, 6) - 3
	sevtwo_rank_ac = rank_to_ac(sevtwo_rank)
	cents = SEVTWO_INTERVAL * float(sevtwo_rank)
	
	var freq_a: float = LOW_C_FREQ * pow(TWO, octave)
	var c: float = float(pitch_class * 100) + cents
	freq = pow(TWO, c / TWELVE_HUNDRED) * freq_a
	
	sevtwo_error_from_freq = 0.0
	property_list_changed_notify()
	emit_pitch_changed()
	

	
static func string_contains_number(_string: String) -> bool:
	for c in _string:
		if NUMBERS.has(c):
			return true
	return false
	
static func rank_to_ac(_rank: int) -> String:
	match _rank:
		-3: return ",,,"
		-2: return ",,"
		-1: return ","
		0: return ""
		1: return "'"
		2: return "''"
		3: return "'''"
	return ""
	
func set_title_c4(_title_c4: String, _return_found_components: bool = false):
	if is_initializing:
		title_c4 = _title_c4
		return
	if not _return_found_components:
		set_title(_title_c4, true)
	else:
		var found: Array = set_title(_title_c4, true, _return_found_components)
		return found

func set_title(_title: String, _c4: bool = false, _return_found_components: bool = false):
	if is_initializing:
		title = _title
		return
	update_last_pitch_data()
	# Could be just a note name, could include an octave, could include a cent value.
	var s: String = _title.strip_edges() # Removes spaces, tabs, and newlines from 
	# beginning and end of string.
	s = s.strip_escapes()
	if s.empty():
		return
	
	var new_s: String
	for i in range(s.length()):
		if ALLOWED_CHARS_IN_TITLE.has(s[i]): # includes spaces
			new_s = new_s + s[i]
	if new_s.empty():
		return

	while UNSTARTABLE_CHARS.has(new_s[0]): # Must start with note letter.
		new_s = new_s.right(1)
		if new_s.empty():
			return # Do not change title or anything else. 
	
	var nn_valid: bool = false
	var oct_valid: bool = false
	var cents_valid: bool = false
	
	var new_note_name: String = "A"
	var new_octave: int = 3
	var new_cents: float = 0.0
	
	var had_note_name: bool = false
	var had_oct: bool = false
	var had_ac: bool = false
	var had_cents: bool = false
	
	var regex: RegEx = RegEx.new()
	regex.compile("([cdefga]#|[CDEFGAB]#|[cdefga]b|[CDEFGAB]b|C|D|E|F|G|A|B|c|d|e|f|g|a|b)")
	# note name
	var note_name_result = regex.search(new_s)
	if note_name_result is RegExMatch:
		var nn_str: String = note_name_result.get_string()
		new_note_name = nn_str.capitalize()
		nn_valid = note_name_is_valid(new_note_name)
		had_note_name = true
	
	# Get any runs of commas or apostrophes.
	regex.compile("[\\'|\\,]+")
	var results: Array = regex.search_all(s)
	var rank: int = -10
	var has_equal_sign: bool = s.find("=") != -1
	if results.size() >= 1 || has_equal_sign: # An equal sign means rank 0 in AC format. 
		print("commas or apostrophes found, results.size(): ", results.size())
		if has_equal_sign:
			rank = 0
		else:
			var result_str: String = results[0].get_string()
			if result_str.find("'") != -1: # apostrophes.
				rank = result_str.length()
			else: # commas
				rank = -result_str.length()
		had_ac = true
	# Now we get any number in the string to determine octave number and/or cent value.
	regex.compile("(-|\\+)?[0-9]+(\\.[0-9]*)?")
	results = regex.search_all(s)
	
	if results.size() == 1:
		# Only one number found.
		var result_str: String = results[0].get_string()
		var number: float = float(result_str)
		if had_ac:
			# If apostrophes or commas were given, those denote the rank,
			# (and therefore the cent value)
			# meaning the number is the octave number.
			new_octave = clamp(int(number), -1, 8)
			oct_valid = true
			new_cents = float(rank) * SEVTWO_INTERVAL
			cents_valid = true
			had_oct = true
		# -1 is the only number that can be confused between an octave and a cent value.
		elif number == -1.0:
			if result_str.find(".") != -1: # If it contains a decimal, it's the cent value
				# But if they included apostrophes or commas, that overrides any entered cent value.
				had_cents = true
				if rank == -10:
					new_cents = number
				else:
					new_cents = float(rank) * SEVTWO_INTERVAL
				cents_valid = true
				oct_valid = false
			else: # If it does NOT contain a decimal, it's the octave number
				new_octave = int(number)
				oct_valid = true
				new_cents = 0.0
				cents_valid = false
				had_oct = true
				had_cents = false
		else:
			# Must be octave number
			new_octave = int(number)
			oct_valid = true
			new_cents = 0.0
			cents_valid = true
			had_oct = true
	elif results.size() >= 2:
		# At least 2 numbers found.
		# We only care about the first two numbers. No reason for the user
		# to put more than two numbers.
		var first_str: String = results[0].get_string()
		var first_number: float = float(first_str)
		var second_str: String = results[1].get_string()
		var second_number: float = float(second_str)
		if had_ac:
			# If apostrophes or commas were given, those denote the rank,
			# (and therefore the cent value)
			# meaning the first number is the octave number, and the second
			# number is irrelevant.
			new_octave = clamp(int(first_number), -1, 8)
			oct_valid = true
			new_cents = float(rank) * SEVTWO_INTERVAL
			cents_valid = true
			had_oct = true
		elif first_str.find(".") == -1 && first_str[0] != "+": 
			# If the first str does NOT have a decimal
			# and does NOT start with a plus sign
			# it's the octave number.
			new_octave = int(first_number)
			oct_valid = true
			had_oct = true
			# That means the second number is the cent value no matter what.
			# But if they included apostrophes or commas, that overrides any entered cent value.
			if rank == -10:
				new_cents = second_number
			else:
				new_cents = float(rank) * SEVTWO_INTERVAL
			cents_valid = true
			had_cents = true
		else:
			# If the first number DOES contain a decimal or DOES start with a plus sign
			# it's the cent value.
			# But if they included apostrophes or commas, that overrides any entered cent value.
			if rank == -10:
				new_cents = first_number
			else:
				new_cents = float(rank) * SEVTWO_INTERVAL
			cents_valid = true
			had_cents = true
			# But in order for the second number to be the octave number it needs to
			# NOT have a plus sign and have no decimal point.
			if second_str.find(".") == -1 && second_str[0] != "+":
				# second_str does NOT have a decimal and does NOT start with a plus sign.
				# So second number is a valid octave number.
				new_octave = int(second_number)
				oct_valid = true
				had_oct = true
			else:
				oct_valid = false
				had_oct = false
				
				
	# Now we can set our values.
	if _c4: # The argument _title was written as if Middle C is C4.
		new_octave -= 1
	var new_enharmonic: int
	var new_flat_note_name: String = "A"
	var new_sharp_note_name: String = "A"
	
	if nn_valid:
		if new_note_name == "Cb":
			new_note_name = "B"
			new_octave -= 1
			new_enharmonic = Enharm.FLAT
			new_flat_note_name = new_note_name
			new_sharp_note_name = new_note_name
		elif new_note_name == "B#":
			new_note_name = "C"
			new_octave += 1
			new_enharmonic = Enharm.SHARP
			new_flat_note_name = new_note_name
			new_sharp_note_name = new_note_name
		elif new_note_name == "E#":
			new_note_name = "F"
			new_enharmonic = Enharm.SHARP
			new_flat_note_name = new_note_name
			new_sharp_note_name = new_note_name
		elif new_note_name == "Fb":
			new_note_name = "E"
			new_enharmonic = Enharm.FLAT
			new_flat_note_name = new_note_name
			new_sharp_note_name = new_note_name
			
		elif new_note_name.length() >= 2: # Black key
			if new_note_name[1] == "b":
				new_enharmonic = Enharm.FLAT
				new_flat_note_name = new_note_name
				new_sharp_note_name = flip_enharmonic(new_note_name)
			elif new_note_name[1] == "#":
				new_enharmonic = Enharm.SHARP
				new_flat_note_name = flip_enharmonic(new_note_name)
				new_sharp_note_name = new_note_name
		else: # White key
			new_enharmonic = Enharm.FLAT
			new_flat_note_name = new_note_name
			new_sharp_note_name = new_note_name

	if new_octave >= HIGHEST_OCTAVE && new_note_name != "C": # Only High C can be at octave 8.
		new_octave = HIGHEST_OCTAVE - 1
	elif new_octave < LOWEST_OCTAVE:
		new_octave = LOWEST_OCTAVE
	print("new_note_name: ", new_note_name, ", new_octave: ", new_octave,\
		", new_cents: ", new_cents)
	# Now finally set everything.
	octave = new_octave
	note_name = new_note_name
	flat_note_name = new_flat_note_name
	sharp_note_name = new_sharp_note_name
	enharmonic = new_enharmonic
	if rank != -10:
		sevtwo_rank = rank
		sevtwo_rank_ac = rank_to_ac(rank)
	# If rank is still -10, don't worry, the cents setter coming up will take
	# care of it.
	pitch_class = FLAT_NOTE_NAMES.find(flat_note_name)
	is_black_key = BLACK_KEYS_12TET_PITCH_CLASSES.has(pitch_class)
	assert(pitch_class != -1)
	var freq_a: float = LOW_C_FREQ * pow(TWO, octave)
	# freq_a is the frequency of the closest C below us.

	var c: float = (float(pitch_class) * ONE_HUNDRED) + cents
	freq = pow(TWO, c / TWELVE_HUNDRED) * freq_a
	# After calculating freq, it's possible we're off ever so slightly (negligible).
	# When A is 440, every A at octave 0 or greater will be a whole number frequency.
	# We want A 440 to always be A 440, so we round any note A with octave >= 0 to a whole number.
	if note_name == "A" && octave >= 0 && cents == 0.0:
		freq = round(freq)
	midi_number = ((octave + 2) * 12) + pitch_class
	# cents setter will do sevtwo stuff, update property list, and emit pitch_changed.
	if not had_ac:
		self.cents = new_cents
	else:
		self.cents = float(sevtwo_rank) * SEVTWO_INTERVAL

	
	if _return_found_components:
		print("returning ", [had_note_name, had_oct, had_ac, had_cents])
		return [had_note_name, had_oct, had_ac, had_cents]
	
func get_title() -> String:
	return as_string()
	
#func get_title_sharp() -> String:
#	#	var s: String
#	var cent_s: String
#	if cents >= 0.0:
#		cent_s = "+" + "%.2f" % cents +"c"
#	else:
#		cent_s = "%.2f" % cents +"c"
#	return self.sharp_note_name + str(self.octave) + " " + cent_s
	
func get_title_c4() -> String:
	#	var s: String
	var cent_s: String
	if cents >= 0.0:
		cent_s = "+" + "%.2f" % cents +"c"
	else:
		cent_s = "%.2f" % cents +"c"
	return self.note_name + str(self.octave_c4) + " " + cent_s
	
	
func get_title_ac(_with_octave: bool = true, _middle_c_is_c4: bool = false) -> String:
	if _with_octave:
		if not _middle_c_is_c4:
			return self.note_name + str(self.octave) + sevtwo_rank_ac
		else:
			return self.note_name + str(self.octave_c4) + sevtwo_rank_ac
	else:
		print("get_title_ac, returning note name ", self.note_name + sevtwo_rank_ac)
		return self.note_name + sevtwo_rank_ac
	
func get_title_pm(_with_octave: bool = true, _middle_c_is_c4: bool = false) -> String:
	var s: String = sevtwo_rank_ac.replace("'", "+").replace(",", "-")
	if _with_octave:
		if not _middle_c_is_c4:
			return self.note_name + str(self.octave) + s
		else:
			return self.note_name + str(self.octave_c4) + s
	else:
		return self.note_name + s


		
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################

static func cents_to_playback_speed(_cents: float):
	return pow(2.0, _cents / 1200.0)
	
static func cent_interval(freq_a: float, freq_b: float, round_cents: bool = false) -> float:
	# Returns the interval in cents from freq_a to freq_b.
	var c: float
	if round_cents: # round the nearest whole number of cents
		c = stepify(TWELVE_HUNDRED * (log(freq_b / freq_a) / log(TWO)), 1.0)
	else:
		c = TWELVE_HUNDRED * (log(freq_b / freq_a) / log(TWO))
	return c
	
static func is_whole_number(f: float) -> bool:
	return is_equal_approx(f, round(f))
	
static func flip_enharmonic(_note_name: String) -> String:
	match _note_name:
		"C#": return "Db"
		"Db": return "C#"
		"D#": return "Eb"
		"Eb": return "D#"
		"F#": return "Gb"
		"Gb": return "F#"
		"G#": return "Ab"
		"Ab": return "G#"
		"A#": return "Bb"
		"Bb": return "A#"
		
		"B#": return "C"
		"Cb": return "B"
		"E#": return "F"
		"Fb": return "E"
		_: return _note_name
		
static func note_name_is_valid(_note_name: String) -> bool:
	return VALID_NOTE_NAMES.has(_note_name)

func update_sevtwo_stuff() -> void:
	var closest_sevtwo_cents: float = stepify(cents, SEVTWO_INTERVAL)
	sevtwo_rank = -10
	for i in range(-3, 4): # i will be -3 thru 3
		if is_equal_approx(closest_sevtwo_cents, SEVTWO_INTERVAL * float(i)):
			sevtwo_rank = i
	assert(sevtwo_rank != -10)
	sevtwo_rank_ac = rank_to_ac(sevtwo_rank)
	sevtwo_error_from_freq = cents - closest_sevtwo_cents
	sevtwo_note_num = (octave * 72) + (pitch_class * 6) + sevtwo_rank
	sevtwo_pitch_class = posmod(sevtwo_note_num, 72)
	

func get_title_12tet() -> String:
	return self.note_name + str(self.octave)

func as_string(_with_octave: bool = true) -> String:
#	var s: String
	var cent_s: String
	if cents >= 0.0:
		cent_s = "+" + "%.2f" % cents +"c"
	else:
		cent_s = "%.2f" % cents +"c"
	if _with_octave:
		return self.note_name + str(self.octave) + " " + cent_s
	else:
		return self.note_name + " " + cent_s
	
func get_cents_string() -> String:
	var cent_s: String
	if cents >= 0.0:
		cent_s = "+" + "%.2f" % cents +"c"
	else:
		cent_s = "%.2f" % cents +"c"
	return cent_s
	
func get_sevtwo_error_from_freq_string() -> String:
	var error_s: String
	if sevtwo_error_from_freq >= 0.0:
		error_s = "+" + "%.2f" % sevtwo_error_from_freq +"c"
	else:
		error_s = "%.2f" % sevtwo_error_from_freq +"c"
	return error_s
	
func get_freq_string() -> String:
	var freq_str: String = "%.3f" % freq + " Hz"
	return freq_str
	
func get_playback_speed() -> float:
	return cents_to_playback_speed(cents)
	

	

func emit_pitch_changed() -> void:
	emit_signal("pitch_changed", freq)
	
func update_last_pitch_data() -> void:
	for prop in LAST_VARS:
		last_pitch_data[prop] = get(prop)

func _init(_x: String = "") -> void:
	is_initializing = false
	if _x != "":
		set_title(_x)
	update_last_pitch_data()

func _ready():
	pass
