$ = jQuery

updateUrl = (input) ->
	document.location.hash = encodeURIComponent(input)
	$('#link').val(document.location)

$('#link').click ->
	$(this).select()

parseInput = () ->
	marktab = new Marktab(null, null, null, 70)
	input = $('#input').val()
	marktab.parse(input)
	tab = marktab.generateTab()
	html = tab.replace(/\n/g,'<br />')
	$('#output').html(html)
	updateUrl(input)
	window.scrollTo(0, document.body.scrollHeight)

$('#input').keyup(parseInput)

# default marktab
if document.location.hash.length > 0 
	hash = document.location.hash
	defaultTab = decodeURIComponent(hash.substr(1, hash.length-1))
else 
	defaultTab = "G: (6:3 5:2 4:0 3:0 2:0 1:3)\nG-scale: [6:3 5 5:2 3 / 5 4:2 4 5 3:2 4 h 5 2:3 5 1:2 3 5]\nG-scale G G r G"

$('#input').val(defaultTab)

parseInput()