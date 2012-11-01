$ = jQuery

parseInput = () ->
	marktab = new Marktab
	input = $('#input').val()
	marktab.parse(input)
	tab = marktab.generateTab()
	html = tab.replace(/\n/g,'<br />')
	$('#output').html(html)

$('#input').keyup(parseInput)
	
parseInput()