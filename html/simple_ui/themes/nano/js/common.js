function replaceContent(body) {
    document.getElementById('maincontent').innerHTML = body;
}

function updateFields(json) {
    var fields = JSON.parse(json);
	for (var key in fields) {
		let value = fields[key];
		var element = document.getElementById(key);
		if(element != null) {
			element.innerHTML = value;
		}
	}
}
