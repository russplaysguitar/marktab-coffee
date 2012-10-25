describe "generator", ->
	marktab = undefined

	beforeEach ->
		marktab = new Marktab

	it "should exist", ->
		expect(marktab.generate).toBeDefined

	it "should make an empty tab map", ->
		# act
		result = marktab.generate()

		# assert
		expect(result).toBe("e|-|\nB|-|\nG|-|\nD|-|\nA|-|\nE|-|\n")

	it "should make a basic tab map", ->
		# arrange
		marktab2 = new Marktab({6:[1]})

		# act
		result = marktab2.generate()
		
		# assert
		expect(result).toBe("e|---|\nB|---|\nG|---|\nD|---|\nA|---|\nE|-1-|\n")
