describe "generator", ->
	it "should make an empty tab map", ->
		# act
		result = marktab.generate

		# assert
		expect(result).toBe("")

	it "should make a basic tab map", ->
		# arrange
		parsed = marktab.parseNotes "6:1"

		# act
		result = marktab.generate parsed
		
		# assert
		expect(result).toBe("e|---|\nB|---|\nG|---|\nD|---|\nA|---|\nE|-1-|")
