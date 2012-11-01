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

	it "should return handle hammer-ons", ->
		# arrange
		marktab.parse("1:1 h 2")

		# act
		actual = marktab.generateTab()

		# assert
		expect(actual).toEqual("e|-1--h--2--|\nB|----------|\nG|----------|\nD|----------|\nA|----------|\nE|----------|\n")