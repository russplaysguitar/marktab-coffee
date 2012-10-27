describe "parseVariable", ->
	marktab = undefined

	beforeEach ->
		marktab = new Marktab

	it "Should exist", ->
		# assert
		expect(marktab.parseVariable).toBeDefined()

	it "Should convert chord to json", ->
		# arrange
		variable = "myVar: (1:1 2:2)"

		# act
		result = marktab.parseVariable variable

		# assert
		#expect(result).toBe({1:[1], 2:[2]})