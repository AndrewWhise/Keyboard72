extends Reference

class_name Interval

const TWELVE_HUNDRED: float = 1200.0
const TWO: float = 2.0
const TWELVE: float = 12.0
const ONE_HUNDRED: float = 100.0
const SEVTWO_INTERVAL: float = 100.0 / 6.0
const SEVENTY_TWO: float = 72.0
const SIX: float = 6.0

enum IntervalLockMode {LOCK_A, LOCK_B}
var interval_lock_mode: int = IntervalLockMode.LOCK_A
# LOCK_A: pitch_b will be changed when the ratio or distance variables are changed.
# LOCK_B: pitch_a will be changed when the ratio or distance variables are changed.


enum PitchLockMode {FREE, LOCKED}
var pitch_lock_mode: int = PitchLockMode.FREE
# FREE: When either pitch changes, the other pitch stays where it is and the interval is updated.
# LOCKED: When either pitch changes, the other pitch moves so that the interval is the same.

enum PulseDirection {A_TO_B, B_TO_A, A_TO_INTERVAL, B_TO_INTERVAL, INTERVAL_TO_A, INTERVAL_TO_B}

var pitch_a: Pitch setget set_pitch_a
var pitch_b: Pitch setget set_pitch_b

const DEFAULT_MAX_DENOMINATOR: int = 32
var max_denominator: int = DEFAULT_MAX_DENOMINATOR setget set_max_denominator

const MIN_MAX_DENOMINATOR: int = 16
const MAX_MAX_DENOMINATOR: int = 60

#### Note: The ratio is NOT based on the absolute interval, but the interval from Pitch A to Pitch B.
#### So if pitch_a.freq >= pitch_b.freq, the ratio will be >= 1.0, but if
#### pitch_a.freq < pitch_b.freq, the ratio will be < 1.0.
var ratio_n: int = 1 setget set_ratio_n
var ratio_d: int = 1 setget set_ratio_d
var ratio_cent_error: float = 0.0 # How off in cents this interval is from the ratio exactly.
############

#### Note: Unlike the ratio variables, these distance variables below are ABSOLUTE,
#### regardless of whether B is higher than A or not.
#### So they will always be positive values.
################################################
var octaves: int = 0 setget set_octaves
var halfsteps: int = 0 setget set_halfsteps# Anything from 0 to 11
var cents: float = 0.0 setget set_cents # Anything from 0.0 to 100.0

var sevtwo: int = 0 setget set_sevtwo
var sevtwo_posmod_72: int = 0 setget set_sevtwo_posmod_72
var sevtwo_cent_error: float = 0.0 # How off in cents this interval is from this sevtwo dist exactly.

var freq_difference: float = 0.0
#################################################

var pitch_a_changed_from_here: bool = false
var pitch_b_changed_from_here: bool = false

signal interval_changed(_interval)
signal pulse(_interval, direction)

func set_pitch_a(_pitch: Pitch) -> void:
	pitch_a = _pitch
	pitch_a.connect("pitch_changed", self, "_on_PitchA_changed")
	if pitch_b: # If pitch_b != null.
		update_ratio()
		update_distance()
		emit_signal("pulse", self, PulseDirection.A_TO_B)
		emit_signal("interval_changed", self)
	
func set_pitch_b(_pitch: Pitch) -> void:
#	print("pitch_b setter ", _pitch.title)
	pitch_b = _pitch
	pitch_b.connect("pitch_changed", self, "_on_PitchB_changed")
#	last_freq_b = pitch_b.freq
	if pitch_a: # If pitch_ab != null.
		update_ratio()
		update_distance()
		emit_signal("pulse", self, PulseDirection.B_TO_A)
		emit_signal("interval_changed", self)
		
func clear_pitch_a() -> void:
	pitch_a = null
func clear_pitch_b() -> void:
	pitch_b = null
		
func set_ratio_n(_ratio_n: int) -> void:
	if _ratio_n > 0:
		ratio_n = _ratio_n
		ratio_changed()

func set_ratio_d(_ratio_d: int) -> void:
	if _ratio_d > 0:
		ratio_d = _ratio_d
		ratio_changed()
		
func set_octaves(_octaves: int) -> void:
	octaves = max(_octaves, 0)
	distance_changed()
	
func set_halfsteps(_halfsteps: int) -> void:
	halfsteps = max(_halfsteps, 0)
	distance_changed()
	
func set_cents(_cents: float) -> void:
	cents =  max(_cents, 0.0)
	distance_changed()
	
func set_sevtwo(_sevtwo: int) -> void:
	sevtwo = max(_sevtwo, 0)
	sevtwo_posmod_72 = posmod(sevtwo, 72)
	sevtwo_changed()
	
func set_sevtwo_posmod_72(_sevtwo_posmod_72: int) -> void:
	var old_sevtwo_posmod_72: int = sevtwo_posmod_72
	sevtwo_posmod_72 = max(_sevtwo_posmod_72, 0)
	var diff: int = sevtwo_posmod_72 - old_sevtwo_posmod_72
	sevtwo += diff
	assert(sevtwo >= 0)
	sevtwo_changed()
	
func get_low_pitch() -> Pitch:
	if pitch_a.freq <= pitch_b.freq:
		return pitch_a
	return pitch_b

func get_high_pitch() -> Pitch:
	if pitch_a.freq > pitch_b.freq:
		return pitch_a
	return pitch_b
	


func get_ratio() -> Array:
	return [ratio_n, ratio_d]
	
func get_high_over_low_ratio() -> Array:
	if pitch_b.freq >= pitch_a.freq:
		return [ratio_n, ratio_d]
	return [ratio_d, ratio_n]

	
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
	
func _init() -> void:
	pass

func _ready():
	pass
	
func set_max_denominator(_max_denominator: int) -> void:
	max_denominator = clamp(_max_denominator, MIN_MAX_DENOMINATOR, MAX_MAX_DENOMINATOR)
	update_ratio()
	
static func get_frac_ratio(_freq_a: float, _freq_b: float, _max_denom: int) -> Array:
	var high: float = max(_freq_a, _freq_b)
	var low: float = min(_freq_a, _freq_b)
	var low_over_high_frac: Array = farey(low / high, _max_denom)
	var md_plus: int = 1
	while low_over_high_frac[0] == 0: # frac cannot be 0
		low_over_high_frac = farey(low / high, _max_denom + md_plus)
		md_plus += 1
	var frac: Array
	# B = A * Ratio
	if _freq_a <= _freq_b: # B is HIGHER than A (or equal to A). Ratio will be > 1
		frac = [low_over_high_frac[1], low_over_high_frac[0]] # e.g. 3/1
	else: # B is LOWER than A. Ratio will be < 1
		frac = low_over_high_frac.duplicate() # e.g. 1/3
	var _cents_real: float = cent_interval(_freq_a, _freq_b)
#	print("freq_a: ", freq_a, ", freq_b: ", freq_b, ", frac: ", frac)
	if frac[1] == 0:
		return [PoolIntArray([1, 64]), -200.0]
	var _cents_approx: float = cent_interval(_freq_a, _freq_a * (float(frac[0]) / float(frac[1])))
	var _cents_error: float = _cents_real - _cents_approx
	return [frac, _cents_error]

static func farey(x: float, n: int = 24) -> Array:
	#https://www.johndcook.com/blog/2010/10/20/best-rational-approximation/
	var a: int = 0
	var b: int = 1
	var c: int = 1
	var d: int = 1
	while b <= n && d <= n:
		var mediant: float = float(a + c) / float(b + d)
		if x == mediant:
			if b + d <= n:
				return [a + c, b + d]
			if d > b:
				return [c, d]
			else:
				return [a, b]
		elif x > mediant:
			a = a + c
			b = b + d
		else:
			c = a + c
			d = b + d
	if b > n:
		return [c, d]
	else:
		return [a, b]

static func get_freq_b_given_cents(_freq_a: float, _cents: float) -> float:
	return _freq_a * pow(2.0, _cents / TWELVE_HUNDRED)

static func cent_interval(_freq_a: float, _freq_b: float, round_cents: bool = false) -> float:
	# Returns the interval in cents from freq_a to freq_b.
	var c: float
#	print("freq_a: ", freq_a, ", freq_b: ", freq_b, ", freq_b/freq_a: ", freq_b / freq_a)
	if round_cents: # round the nearest whole number of cents
		c = stepify(TWELVE_HUNDRED * (log(_freq_b / _freq_a) / log(TWO)), 1.0)
	else:
		c = TWELVE_HUNDRED * (log(_freq_b / _freq_a) / log(TWO))
	return c

static func get_interval_arr(_freq_a: float, _freq_b: float) -> Array:
	var _total_cents: float = cent_interval(_freq_a, _freq_b, false)
	var _halfsteps: int = int(floor(_total_cents / ONE_HUNDRED))
	var x: float = float(_halfsteps) * ONE_HUNDRED
	var _rem_cents: float = _total_cents - x
	
	if _rem_cents >= 50.0:
		_rem_cents -= ONE_HUNDRED
		_halfsteps += 1
	elif _rem_cents <= -50.0:
		_rem_cents += ONE_HUNDRED
		_halfsteps -= 1
	var _octs: int = 0
	while _halfsteps >= 12:
		_octs += 1
		_halfsteps -= 12
	while _halfsteps <= -12:
		_octs -= 1
		_halfsteps += 12
	return [_octs, _halfsteps, _rem_cents]
	
func update_ratio() -> void:
	var frac_arr: Array = get_frac_ratio(pitch_a.freq, pitch_b.freq, max_denominator)
#	print("frac arr: ", frac_arr)
	ratio_n = frac_arr[0][0]
	ratio_d = frac_arr[0][1]
	ratio_cent_error = frac_arr[1]
	
static func is_whole_number(f: float) -> bool:
	return is_equal_approx(f, round(f))
	
func update_distance() -> void:
#	print("update_distance")
	var sum_cent_dist: float = cent_interval(get_low_pitch().freq, get_high_pitch().freq, false)
	var sum_cent_dist_dupe: float = sum_cent_dist
#	print("    sum_cent_dist: ", sum_cent_dist)
	var s_1200: float = sum_cent_dist / TWELVE_HUNDRED
	if is_whole_number(s_1200):
		octaves = int(round(s_1200))
	else:
		octaves = int(floor(sum_cent_dist / TWELVE_HUNDRED))
	sum_cent_dist -= float(octaves * 1200)
#	print("    floor(sum_cent_dist / ONE_HUNDRED): ", floor(sum_cent_dist / ONE_HUNDRED))
	var s_100: float = sum_cent_dist / ONE_HUNDRED
#	print("    s_100: ", s_100)
	if is_whole_number(s_100):
		halfsteps = int(round(s_100))
	else:
		halfsteps = int(floor(sum_cent_dist / ONE_HUNDRED))
#	print("    halfsteps: ", halfsteps)
	sum_cent_dist -= float(halfsteps * 100)
	cents = sum_cent_dist
#	print("    cents: ", cents)
	
	
	sevtwo = (octaves * 72) + (halfsteps * 6) + int(round(cents / SEVTWO_INTERVAL))
	sevtwo_posmod_72 = posmod(sevtwo, 72)
	
	var sr: int = posmod(sevtwo, 6)
	var sevtwo_total_cents_approx: float = float((octaves * 1200) + (halfsteps * 100))\
		+ (float(sr) * SEVTWO_INTERVAL)
	sevtwo_cent_error = sum_cent_dist_dupe - sevtwo_total_cents_approx
	
	freq_difference = get_high_pitch().freq - get_low_pitch().freq
	


func get_distance_string() -> String:
	var s: String
	if pitch_a.freq > pitch_b.freq:
		s = "-"
	s = s + str(octaves) + "o" + str(halfsteps) + "h" + str(cents) + "c"
	return s
	
func _on_PitchA_changed(new_freq: float) -> void:
	if pitch_a_changed_from_here:
		return
	# Pitch A was changed from outside this function, so we need to update the interval.
	#print("Interval, PitchA_changed, new pitch A: ", pitch_a.title, ", last pitch A: ", pitch_a.last_pitch_data["title"])
	
	match pitch_lock_mode:
		PitchLockMode.FREE: # Pitch B doesn't change and we update the interval.
			update_ratio()
			update_distance()
			emit_signal("pulse", self, PulseDirection.A_TO_INTERVAL)
		PitchLockMode.LOCKED: # We adjust Pitch B so that the interval is the same.
			var last_cent_interval: float = cent_interval(pitch_a.last_pitch_data["freq"], pitch_b.freq)
#			print("    last_cent_interval: ", last_cent_interval)
			var new_freq_b: float = get_freq_b_given_cents(pitch_a.freq, last_cent_interval)
##			var b_was_higher: bool = pitch_b.freq >= pitch_a.last_pitch_data["freq"]
#			var new_freq_b: float = pitch_a.freq + (freq_difference * dir)
			emit_signal("pulse", self, PulseDirection.A_TO_B)
			pitch_b_changed_from_here = true
			pitch_b.freq = new_freq_b
			pitch_b_changed_from_here = false
	emit_signal("interval_changed", self)
	
func _on_PitchB_changed(new_freq: float) -> void:
	if pitch_b_changed_from_here:
		return
	# Pitch B was changed from outside this function, so we need to update the interval.
	#print("Interval, PitchB_changed, new pitch B: ", pitch_b.title, ", last pitch B: ", pitch_b.last_pitch_data["title"])
	
	match pitch_lock_mode:
		PitchLockMode.FREE: # Pitch A doesn't change and we update the interval
			update_ratio()
			update_distance()
			emit_signal("pulse", self, PulseDirection.B_TO_INTERVAL)
		PitchLockMode.LOCKED: # We adjust Pitch A so that the interval is the same.
			var last_cent_interval: float = cent_interval(pitch_b.last_pitch_data["freq"], pitch_a.freq)
			#print("    last_cent_interval: ", last_cent_interval)
			var new_freq_a: float = get_freq_b_given_cents(pitch_b.freq, last_cent_interval)
			emit_signal("pulse", self, PulseDirection.B_TO_A)
##			var b_was_higher: bool = pitch_b.freq >= pitch_a.last_pitch_data["freq"]
#			var new_freq_b: float = pitch_a.freq + (freq_difference * dir)
			pitch_a_changed_from_here = true
			pitch_a.freq = new_freq_a
			pitch_a_changed_from_here = false
	emit_signal("interval_changed", self)
	
##################################################################################################
##################################################################################################
##################################################################################################

func ratio_changed() -> void:
	# Either the numerator or denominator was changed by the user.
	# When we do this, the ratio_cent_error will be set to 0.0, because we're changing the frequency
	# based on the ratio, so there will be no error.
	
	match interval_lock_mode:
		IntervalLockMode.LOCK_A: # B changes
			var rat: float = float(ratio_n) / float(ratio_d)
			pitch_b_changed_from_here = true
			emit_signal("pulse", self, PulseDirection.INTERVAL_TO_B)
			print("Interval, ratio_changed to ", ratio_n, "/", ratio_d, ", changing pitch_b accordingly.")
			pitch_b.freq = pitch_a.freq * rat
			pitch_b_changed_from_here = false
			
		IntervalLockMode.LOCK_B: # A changes
			var recip: float = float(ratio_d) / float(ratio_n)
			pitch_a_changed_from_here = true
			emit_signal("pulse", self, PulseDirection.INTEVAL_TO_A)
			print("Interval, ratio_changed to ", ratio_n, "/", ratio_d, ", changing pitch_a accordingly.")
			pitch_a.freq = pitch_b.freq * recip
			pitch_a_changed_from_here = false
	ratio_cent_error = 0.0
#	var _cents_real: float = cent_interval(pitch_a.freq, pitch_b.freq)
#	var _cents_approx: float = cent_interval(pitch_a.freq, pitch_a.freq * rat)
#	ratio_cent_error = _cents_real - _cents_approx
	update_distance()
	
func distance_changed() -> void:
	# The absolute octaves, halfsteps, and/or cents was changed by the user on the IntervalNode.
	var sum_cent_dist: float = float((octaves * 1200) + (halfsteps * 100)) + cents
	match interval_lock_mode:
		IntervalLockMode.LOCK_A: # B changes.
			pitch_b_changed_from_here = true
			emit_signal("pulse", self, PulseDirection.INTERVAL_TO_B)
			pitch_b.freq = get_freq_b_given_cents(pitch_a.freq, sum_cent_dist)
			pitch_b_changed_from_here = false
		IntervalLockMode.LOCK_B: # A changes.
			pitch_a_changed_from_here = true
			emit_signal("pulse", self, PulseDirection.INTERVAL_TO_A)
			pitch_a.freq = get_freq_b_given_cents(pitch_b.freq, -sum_cent_dist)
			pitch_a_changed_from_here = false
	freq_difference = get_high_pitch().freq - get_low_pitch().freq
	
	sevtwo = (octaves * 72) + (halfsteps * 6) + int(round(cents / SEVTWO_INTERVAL))
	sevtwo_posmod_72 = posmod(sevtwo, 72)
	
	var sr: int = posmod(sevtwo, 6)
	var sevtwo_total_cents_approx: float = float((octaves * 1200) + (halfsteps * 100))\
		+ (float(sr) * SEVTWO_INTERVAL)
	sevtwo_cent_error = sum_cent_dist - sevtwo_total_cents_approx

	update_ratio()
	
func sevtwo_changed() -> void:
	# The absolute sevtwo, sevtwo_mod_72, and/or sevtwo_cent_error was 
	# changed by the user on the IntervalNode.
	# Because we're setting the frequencies based on sevtwo, the sevtwo_cent_error will be 0.0.
	var s_72: float = float(sevtwo) / SEVENTY_TWO
	
	if is_whole_number(s_72):
		octaves = int(round(s_72))
	else:
		octaves = int(floor(s_72))
		
	var s_6: float = float(sevtwo_posmod_72) / SIX
	if is_whole_number(s_6):
		halfsteps = int(round(s_6))
	else:
		halfsteps = int(floor(s_6))
	
	var sr: int = posmod(sevtwo_posmod_72, 6)
	cents = float(sr) * SEVTWO_INTERVAL
	sevtwo_cent_error = 0.0
#	print("sevtwo_changed(), dist: ", get_distance_string())
	

	# update frequencies.
	var sum_cent_dist: float = float((octaves * 1200) + (halfsteps * 100)) + cents
	if pitch_b.freq < pitch_a.freq: # B is lower
		sum_cent_dist = -sum_cent_dist
	match interval_lock_mode:
		IntervalLockMode.LOCK_A: # B changes.
			pitch_b_changed_from_here = true
			emit_signal("pulse", self, PulseDirection.INTERVAL_TO_B)
			pitch_b.freq = get_freq_b_given_cents(pitch_a.freq, sum_cent_dist)
			pitch_b_changed_from_here = false
		IntervalLockMode.LOCK_B: # A changes.
			pitch_a_changed_from_here = true
			emit_signal("pulse", self, PulseDirection.INTERVAL_TO_A)
			pitch_a.freq = get_freq_b_given_cents(pitch_b.freq, -sum_cent_dist)
			pitch_a_changed_from_here = false
	freq_difference = get_high_pitch().freq - get_low_pitch().freq
	
	update_ratio()
	

