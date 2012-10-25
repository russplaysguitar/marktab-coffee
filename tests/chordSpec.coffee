describe "parseChord", ->
	it "Should exist", ->
		#assert
		expect(marktab.parseChord).toBeDefined

	it "Should convert chords to json", ->
		# arrange
		chord = "(5:7 4:9 3:9)"

		# act
		result = marktab.parseChord chord

		# assert
		expect(result).toBe({3:[9], 4:[9], 5:[7]})	
