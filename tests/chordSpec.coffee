describe "parseChord", ->
	marktab = undefined

	beforeEach ->
		marktab = new Marktab

	it "Should exist", ->
		#assert
		expect(marktab.parseChord).toBeDefined()

	it "Should convert chords to json", ->
		# arrange
		chord = "(5:7 4:9 3:9 2:0)"
		expected =
			2:[0] 
			3:[9]
			4:[9]
			5:[7]

		# act
		result = marktab.parseChord chord

		# assert
		expect(result).toEqual(expected)	

	it "Should convert muted chords to json", ->
		# arrange
		chord = "(5:x 4:9 3:x 2:0)"
		expected =
			2:[0] 
			3:['x']
			4:[9]
			5:['x']

		# act
		result = marktab.parseChord chord

		# assert
		expect(result).toEqual(expected)	
