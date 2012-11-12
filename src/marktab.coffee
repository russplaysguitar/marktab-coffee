class Marktab
	# private instance variables
	stringNameDefaults = 
		1: "e"
		2: "B"
		3: "G"
		4: "D"
		5: "A"
		6: "E"
	notePattern = /[0-9]+:[0-9x]+/ # matches digits and mutes (x)
	singleNotePattern = /[0-9]+/
	restPattern = /r/
	hammerPattern = /h/
	pullOffPattern = /p/
	slideUpPattern = /\//
	slideDownPattern = /\\/
	mutePattern = /x/
	palmMutePattern = /./ # TODO: figure this out
	bendPattern = /b/
	harmonicPattern = /\*/
	vibratoPattern = /~/
	chordPattern = /\([0-9\s:]+\)/
	riffPattern = /\[.*\]/
	chordMultiplierPattern = /\([0-9\s:]+\)\s*x[0-9]+/ 
	riffMultiplierPattern = /\[.*\]\s*x[0-9]+/
	multiplierPattern = /x[0-9]+/
	ignorePattern = /[\s\n]/
	setVariablePattern = /[\w0-9\-]+:\s*[\(\[].*[\)\]]/
	variablePattern = /[\(\[].*[\)\]]/
	variableNamePattern = /[\w0-9\-]+/
	
	constructor: (@customVars = {}, @lines = [], @stringNames = stringNameDefaults, @lineBreak = 80) ->
		# @customVars contains variables defined by the user (like: "myRiff: [1:2 2:2]")
		# @lines contains an array of parsed lines, ready to be output
		this

	# top-level parser. delegates to other parse functions.
	parse: (input) ->
		tabMap = {}
		i = 0
		while i < input.length
			part = input.substr(i, input.length-i)# get rest of line
			tabMapPart = {}
			if part.search(ignorePattern) is 0
				# ignore
				part = part.match(ignorePattern)[0]
				i += part.length
				continue
			else if part.search(riffMultiplierPattern) is 0
				# riff multiplier
				part = part.match(riffMultiplierPattern)[0]
				i += part.length
				tabMapPart = this.parseMultiplier(part)
				tabMap = this.addTabMaps(tabMap, tabMapPart)
				continue
			else if part.search(chordMultiplierPattern) is 0
				# chord multiplier
				part = part.match(chordMultiplierPattern)[0]
				i += part.length
				tabMapPart = this.parseMultiplier(part)
				tabMap = this.addTabMaps(tabMap, tabMapPart)
				continue				
			else if part.search(chordPattern) is 0
				# chord
				part = part.match(chordPattern)[0]
				i += part.length
				tabMapPart = this.parseChord(part)
			else if part.search(notePattern) is 0
				# note
				part = part.match(notePattern)[0]
				i += part.length
				tabMapPart = this.parseNote(part)
				lastString = parseInt(_.keys(tabMapPart), 10)
			else if part.search(restPattern) is 0
				# rest
				part = part.match(restPattern)[0]
				i += part.length
				tabMapPart[lastString || 1] = [undefined]
			else if part.search(hammerPattern) is 0
				# hammer-on
				if !lastString
					throw "invalid hammer-on"
				part = part.match(hammerPattern)[0]
				i += part.length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "h"
			else if part.search(pullOffPattern) is 0
				# pull-off
				if !lastString
					throw "invalid pull-off"
				part = part.match(pullOffPattern)[0]
				i += part.length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "p"
			else if part.search(slideUpPattern) is 0
				# slide-up
				if !lastString
					throw "invalid slide-up"
				part = part.match(slideUpPattern)[0]
				i += part.length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "/"
			else if part.search(slideDownPattern) is 0
				# slide-down
				if !lastString
					throw "invalid slide-down"
				part = part.match(slideDownPattern)[0]
				i += part.length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "\\"
			else if part.search(mutePattern) is 0
				# mute
				if !lastString
					throw "invalid mute"
				part = part.match(mutePattern)[0]
				i += part.length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "x"
			else if part.search(bendPattern) is 0
				# bend
				if !lastString
					throw "invalid bend"
				part = part.match(bendPattern)[0]
				i += part.length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "b"
			else if part.search(harmonicPattern) is 0
				# harmonic
				if !lastString
					throw "invalid harmonic"
				part = part.match(harmonicPattern)[0]
				i += part.length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "*"	
			else if part.search(vibratoPattern) is 0
				# vibrato
				if !lastString
					throw "invalid vibrato"
				part = part.match(vibratoPattern)[0]
				i += part.length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = "~"								
			else if part.search(singleNotePattern) is 0
				# single note
				if !lastString
					throw "invalid single note"
				part = part.match(singleNotePattern)[0]
				i += part.length
				tabMapPart[lastString] = []
				tabMapPart[lastString][i] = parseInt(part, 10)
			else if part.search(riffPattern) is 0
				# riff
				part = part.match(riffPattern)[0]
				i += part.length
				tabMapPart = this.parseRiff(part)
				tabMap = this.addTabMaps(tabMap, tabMapPart)
				continue
			else if part.search(setVariablePattern) is 0
				# set variable
				part = part.match(setVariablePattern)[0]
				i += part.length
				this.setVariable(part)
				continue
			else if part.search(variableNamePattern) is 0
				# variable
				part = part.match(variableNamePattern)[0]
				i += part.length
				tabMapPart = this.parseVariable(part)
				tabMap = this.addTabMaps(tabMap, tabMapPart)
				continue
			else
				throw "unknown pattern: " + part
			this.addFrame(tabMap, tabMapPart)	
		this.parseTabMap(tabMap)
		tabMap

	# # probably not going to use this
	# chomp: (line, from, stopChar) ->
	# 	lineArray = line.split("")
	# 	restOfLine = _.rest(lineArray, from)
	# 	stopIdx = _.indexOf(restOfLine, stopChar)
	# 	line.substr(from, stopIdx)

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
	
	addTabMaps: (a, b) ->
		result = this.cloneTabMap(a)
		aLen = this.longestString(a)
		for strNum, strNotesArr of b
			for fret, i in strNotesArr
				result[strNum] ?= []
				result[strNum][aLen + i] = fret
		result

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
	# example: parseNote("5:6") => { 5: [6] }
	parseNote: (note) ->
		result = {}
		stringAndFret = note.split(":")
		string = stringAndFret[0]
		fret = stringAndFret[1]
		result[string] ?= []
		result[string][0] = this.toIntIfPossible(fret)
		result

	# converts input to integer, if possible
	toIntIfPossible: (input) ->
		inputAsInt = parseInt(input, 10)
		if _.isNaN(inputAsInt)
			return input
		else
			return inputAsInt

	# parses marktab chords into tabMap
	# example: parseChord("(6:8 5:6)") => { 5:[6], 6:[8] }
	parseChord: (chord) ->
		result = {}
		notesLine = chord.substr(1, chord.length-2)# remove parenthesis
		notes = notesLine.split(" ")
		for note in notes
			this.mergeTabMaps(result, this.parseNote(note))
		result

	# parses marktab riffs into tabMap
	# example: parseRiff("[1:1 2 h 3 r 7 p 5]") => { 1:[1, 2, 'h', 3, 'r', 7, 'p', 5] }
	parseRiff: (riff) ->
		riffLine = riff.substr(1, riff.length-2)# remove brackets
		m = new Marktab(@customVars)# recurse, keeping any user-defined variables
		m.parse(riffLine)
		
	# sets marktab variables
	# TODO: refactor this and write tests
	setVariable: (input) ->
		part = input
		i = 0
		varName = part.match(variableNamePattern)[0]
		i += varName.length+1
		part = input.substr(i, input.length-i)# get rest of line

		# advance past ignored characters
		while part.search(ignorePattern) is 0
			i++
			part = input.substr(i, input.length-i)

		# parse either a riff or a chord. TODO: make this work without code duplication
		if part.search(chordPattern) is 0
			part = part.match(chordPattern)[0]
			varTab = this.parseChord(part)
		else if part.search(riffPattern) is 0
			part = part.match(riffPattern)[0]
			varTab = this.parseRiff(part)
		else
			throw "cannot set invalid variable: " + part
		@customVars[varName] = varTab # save variable info for later


	# parses marktab variables into tabMap
	parseVariable: (variableName) ->
		@customVars[variableName]

	parseMultiplier: (input) ->
		result = {}
		# parse either a riff or a chord. TODO: make this work without code duplication
		if input.search(chordPattern) is 0
			part = input.match(chordPattern)[0]
			tabToMultiply = this.parseChord(part)
		else if input.search(riffPattern) is 0
			part = input.match(riffPattern)[0]
			tabToMultiply = this.parseRiff(part)
		else
			throw "cannot set invalid multiplied part: " + part

		part = input.substr(part.length, input.length-part.length)# get rest of line
		# advance past ignored characters
		while part.search(ignorePattern) is 0
			part = part.substr(1, part.length-1)

		# - parse multiplier
		multiplier = part.match(multiplierPattern)[0]
		times = multiplier.substr(1, multiplier.length-1)# advance past "x" character
		times = parseInt(times, 10)

		# - make riff happen x times
		i = 1
		while i <= times
			result = this.addTabMaps(result, tabToMultiply)
			i++

		# return tab map
		result

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
		noteIdx = 0
		startAt = 0
		someLeft = true
		while someLeft
			someLeft = false
			for stringNum in [1..6]
				if stringNum is 1
					noteIdx = startAt
				notes = tabMap[stringNum] = tabMap[stringNum].splice(noteIdx)
				line = @stringNames[stringNum] + "|-"
				for note, i in notes
					note = if note isnt undefined && !_.isNaN(note) then note else '-'
					noteLen = note.toString().length
					numDashes = 3 - noteLen
					line += note
					for j in [1..numDashes]
						line += '-'
					if line.length > @lineBreak
						startAt = i
						someLeft = true
						break
				line += "|"
				@lines.push(line)
			@lines.push("") if someLeft
		@lines

	# simply returns @lines concatenated into a string with newlines (\n)
	generateTab: ->
		result = ""
		for line in @lines
			result += line + "\n"
		result

window.Marktab = Marktab