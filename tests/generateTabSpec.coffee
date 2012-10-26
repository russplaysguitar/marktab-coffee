describe "generateTab", ->
	marktab = undefined

	beforeEach ->
		marktab = new Marktab

	it "should return an empty string", ->
		# act
		actual = marktab.generateTab()

		# assert
		expect(actual).toBe("")

	it "should return a non-empty string", ->
		# arrange
		marktab.parse("1:1")

		# act
		actual = marktab.generateTab()

		# assert
		expect(actual).not.toBe("")