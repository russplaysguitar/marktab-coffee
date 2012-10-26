describe "normalizeTabMap", ->
	marktab = undefined

	beforeEach ->
		marktab = new Marktab

	it "should exist", ->
		expect(marktab.normalizeTabMap).toBeDefined()

	it "should normalize without input", ->
		# arrange
		expected = 
			1: []
			2: []
			3: []
			4: []
			5: []
			6: []

		# act
		actual = marktab.normalizeTabMap()

		# assert
		expect(actual).toEqual(expected)

	it "should normalize a single string", ->
		# arrange
		input = 
			6: [1]
		expected = 
			1: [undefined]
			2: [undefined]
			3: [undefined]
			4: [undefined]
			5: [undefined]
			6: [1]

		# act
		actual = marktab.normalizeTabMap(input)

		# assert
		expect(actual).toEqual(expected)

	it "should normalize multiple sparse strings", ->
		# arrange
		input = 
			2: [undefined, 6]
			5: [1, undefined, 10]
		expected = 
			1: [undefined, undefined, undefined]
			2: [undefined, 6, undefined]
			3: [undefined, undefined, undefined]
			4: [undefined, undefined, undefined]
			5: [1, undefined, 10]
			6: [undefined, undefined, undefined]	

		# act
		actual = marktab.normalizeTabMap(input)

		# assert
		expect(actual).toEqual(expected)		