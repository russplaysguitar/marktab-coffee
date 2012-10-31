describe "parseMultiplier", ->
	marktab = undefined

	beforeEach ->
		marktab = new Marktab

	# why? cuz i said so
	it "should allow x0", ->
		# arrange
		input = "[1:1] x0"
		expected = {}

		# act
		actual = marktab.parseMultiplier(input)

		# assert
		expect(actual).toEqual(expected)		

	it "should allow x1", ->
		# arrange
		input = "[1:1] x1"
		expected = {1:[1]}

		# act
		actual = marktab.parseMultiplier(input)

		# assert
		expect(actual).toEqual(expected)

	it "should allow multiple notes x2", ->
		# arrange
		input = "[1:1 2:2] x2"
		expected = 
			1:[1, undefined, 1]
			2:[undefined, 2, undefined, 2]

		# act
		actual = marktab.parseMultiplier(input)

		# assert
		expect(actual).toEqual(expected)

	it "should allow chord x2", ->
		# arrange
		input = "(1:1 2:2) x2"
		expected = 
			1:[1, 1]
			2:[2, 2]

		# act
		actual = marktab.parseMultiplier(input)

		# assert
		expect(actual).toEqual(expected)

	it "should allow chords in riff x2", ->
		# arrange
		input = "[(1:1 2:2) (3:3 4:4)] x2"
		expected =
			1:[1, undefined, 1]
			2:[2, undefined, 2] 
			3:[undefined, 3, undefined, 3]
			4:[undefined, 4, undefined, 4]

		# act
		actual = marktab.parseMultiplier(input)

		# assert
		expect(actual).toEqual(expected)
