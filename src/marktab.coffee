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
	chordPattern = /\([0-9\s:]+\)/
	riffPattern = /\[.*\]/
	
	constructor: (@lines = [], @stringNames = stringNameDefaults) ->
		# @lines contains an array of parsed lines, ready to be output
		this

	# top-level parser. delegates to other parse functions.
	parse: (input) ->
		tabMap = {}
		i = 0
		while i < input.length
			part = input.substr(i, input.length-i)# get rest of line
			tabMapPart = {}
			if part.search(chordPattern) is 0
				# chord
				i += part.match(chordPattern).length
				tabMapPart = this.parseChord(part)
			else if part.search(notePattern) is 0
				# note
				i += part.match(notePattern).length
				tabMapPart = this.parseNotes(part)
				lastString = parseInt(_.keys(tabMapPart), 10)
			else if part.search(restPattern) is 0
				# rest
				i += part.match(restPattern).length
				tabMapPart = {1: [undefined]}
			else if part.search(hammerPattern) is 0
				# hammer-on
				if !lastString
					throw "invalid hammer-on"
				i += part.match(hammerPattern).length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "h"
			else if part.search(pullOffPattern) is 0
				# pull-off
				if !lastString
					throw "invalid pull-off"
				i += part.match(pullOffPattern).length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "p"
			else if part.search(slideUpPattern) is 0
				# slide-up
				if !lastString
					throw "invalid slide-up"
				i += part.match(sliceUpPattern).length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "/"
			else if part.search(slideDownPattern) is 0
				# slide-down
				if !lastString
					throw "invalid slide-down"
				i += part.match(slideDownPattern).length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "\\"
			else if part.search(singleNotePattern) is 0
				# single note
				if !lastString
					throw "invalid single note"
				i += part.match(singleNotePattern).length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = parseInt(part, 10)
			else if part.search(riffPattern) is 0
				# riff
				i += part.match(riffPattern).length
				tabMapPart = this.parseRiff(part)
				# this.mergeTabMaps(tabMap, tabMapPart)
				# continue
			else
				throw "unknown pattern: " + part
			this.addFrame(tabMap, tabMapPart)	
		this.parseTabMap(tabMap)
		tabMap

	# 
	chomp: (line, from, stopChar) ->
		lineArray = line.split("")
		restOfLine = _.rest(lineArray, from)
		stopIdx = _.indexOf(restOfLine, stopChar)
		line.substr(from, stopIdx)

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
		console.log(note)
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
		console.log(chord)
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