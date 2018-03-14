const Parser = require("../index.js");
const fs = require("fs");

function parse(fn) {
	const script = fs.readFileSync(`${__dirname}/${fn}`, 'utf-8');

	return Parser.parse(script);
}

console.log(parse("./test.hx"));
