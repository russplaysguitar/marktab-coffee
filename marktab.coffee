class Marktab
	# private instance variables
	stringNameDefaults = 
		1: "e"
		2: "B"
		3: "G"
		4: "D"
		5: "A"
		6: "E"
	notePattern = /[0-9]:[0-9]/
	singleNotePattern = /[0-9]/
	restPattern = /r/
	hammerPattern = /h/
	pullOffPattern = /p/
	slideUpPattern = /\//
	slideDownPattern = /\\/
	chordPattern = /\(([0-9]:[0-9])+\)/
	riffPattern = /\[.*\]/
	
	constructor: (@lines = [], @stringNames = stringNameDefaults) ->
		# @lines contains an array of parsed lines, ready to be output
		this

	# top-level parser. delegates to other parse functions.
	parse: (input) ->
		lines = input.split("\n")
		for line in lines
			parts = line.split(" ")
			tabMap = {}
			for part, i in parts
				tabMapPart = {}
				if part.match(notePattern) 
					# note
					tabMapPart = this.parseNotes(part)
					lastString = parseInt(_.keys(tabMapPart), 10)
				else if part.match(restPattern)
					# rest
					tabMapPart = {1: [undefined]}
				else if part.match(singleNotePattern)
					# single note
					if !lastString
						throw "invalid single note"
					tabMapPart[lastString] = []
					tabMapPart[lastString][i] = parseInt(part, 10)
				else if part.match(hammerPattern)
					# hammer-on
					if !lastString
						throw "invalid hammer-on"
					tabMapPart[lastString] = []
					tabMapPart[lastString][i] = "h"
				else if part.match(pullOffPattern)
					# pull-off
					if !lastString
						throw "invalid pull-off"
					tabMapPart[lastString] = []
					tabMapPart[lastString][i] = "p"
				else if part.match(slideUpPattern)
					# slide-up
					if !lastString
						throw "invalid slide-up"
					tabMapPart[lastString] = []
					tabMapPart[lastString][i] = "/"
				else if part.match(slideDownPattern)
					# slide-down
					if !lastString
						throw "invalid slide-down"
					tabMapPart[lastString] = []
					tabMapPart[lastString][i] = "\\"
				else if part.match(chordPattern)
					# chord
					tabMapPart = this.parseChord(part)
				else if part.match(riffPattern)
					# riff
					tabMapPart = this.parseRiff(part)
					# this.mergeTabMaps(tabMap, tabMapPart)
					# continue
				else
					throw "unknown pattern: " + part
				this.addFrame(tabMap, tabMapPart)
			this.parseTabMap(tabMap)
		tabMap

	# adds another frame to a tabMap
	addFrame: (tabMap, frame) ->
		idx = this.longestString(tabMap)
		for stringNum, stringNotes of frame
			for fret, i in stringNotes
				tabMap[stringNum] ?= []
				tabMap[stringNum][idx] = fret
		tabMap

	# returns the length of the longest string in the tabMap
	longestString: (tabMap = {}) ->
		max = 0
		for stringNum, stringNotes of tabMap
			size = _.size(stringNotes)
			max = size if size > max
		max
	
	# merges two tabMaps together, with the source overwriting the destination
	mergeTabMaps: (dest, source) ->
		for stringNum, stringNotes of source
			for fret, i in stringNotes
				dest[stringNum] ?= []
				if fret?
					dest[stringNum][i] = fret

	# returns a new tabMap
	cloneTabMap: (tabMap) ->
		result = {}
		for stringNum, stringNotes of tabMap
			result[stringNum] = []
			for fret, i in stringNotes
				result[stringNum][i] = fret
		result

	# parses marktab note into a single tabMap frame
	# example: parseNotes("5:6") => { 5: [6] }
	parseNotes: (note) ->
		result = {}
		stringAndFret = note.split(":")
		string = stringAndFret[0]
		fret = stringAndFret[1]
		result[string] ?= []
		result[string][0] = parseInt(fret, 10) 
		result

	# parses marktab chords into tabMap
	# example: parseChord("(6:8 5:6)") => { 5:[6], 6:[8] }
	parseChord: (chord) ->
		result = {}
		notesLine = chord.substr(1, chord.length-2)# remove parenthesis
		notes = notesLine.split(" ")
		for note in notes
			this.mergeTabMaps(result, this.parseNotes(note))
		result

	# parses marktab riffs into tabMap
	# example: parseRiff("[1:1 2 h 3 r 7 p 5]") => { 1:[1, 2, 'h', 3, 'r', 7, 'p', 5] }
	parseRiff: (riff) ->
		riffLine = riff.substr(1, riff.length-2)# remove brackets
		m = new Marktab
		m.parse(riffLine)
		
	# parses marktab variables into tabMap
	parseVariable: (variable) ->
		""

	# makes each string's notes array the same length
	normalizeTabMap: (tabMap = {}) ->
		result = this.cloneTabMap(tabMap)
		max = this.longestString(tabMap)
		for stringNum in [1..6]
			result[stringNum] ?= []
			result[stringNum][max-1] ?= undefined if max > 0
		result

	# parses a json note map into lines, which are kept in instance state
	parseTabMap: (tabMap = {}) ->
		line = ""
		tabMap = this.normalizeTabMap(tabMap)
		for stringNum in [1..6]
			notes = tabMap[stringNum]
			line = @stringNames[stringNum] + "|-"
			for note in notes
				line += (note || '-')
				if note < 10 || !note
					line += "-" 
			line += "|"
			@lines.push(line)
		@lines

	# simply returns @lines concatenated into a string with newlines (\n)
	generateTab: ->
		result = ""
		for line in @lines
			result += line + "\n"
		result

window.Marktab = Marktab