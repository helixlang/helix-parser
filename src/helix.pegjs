{
	const bigInt = require("big-integer");

	function BinaryConstant(number, radix = 10, sign = null) {
		const value = bigInt(number, radix);
		const signed = sign == null;

		if (value.isZero()) {
			return {
				type: "Constant",
				bits: 0, value
			}
		}

		let max   = bigInt(radix).pow(number.length);
		let test  = bigInt.one;
		let bits  = signed ? 1 : 0;

		while(test.lt(max)) {
			test = test.shiftLeft(1);
			bits ++;
		}

		return {
			type: "Constant",
			bits, value
		}
	}
}

Program
	= _ body:ExpressionStatement*
		{ return { type: "Program", body } }

ExpressionStatement
	= Identifier
	/ Number

Identifier
	= ![0-9] i:$wc+ _
		{ return i }

Number
	= sign:[+-]? "0x"i number:$[0-9a-f]i+ _
		{ return BinaryConstant(number, 16, sign) }
	/ sign:[+-]? "0o"i number:$[0-7]i+ _
		{ return BinaryConstant(number, 8, sign) }
	/ sign:[+-]? "0b"i number:$[01]i+ _
		{ return BinaryConstant(number, 2, sign) }
	/ sign:[+\-]? number:$[0-9]i+ _
		{ return BinaryConstant(number, 10, sign) }

// Helper functions
_	= ([ \n\r\t]+ / comment)*		// Consume whitespace
__	= !wc _ 						// Demand word break, consume whitespace
wc	= [a-zA-Z0-9_]					// Valid identifier characters

comment
	= "/*" (!"*/" .)* "*/"
	/ "//" (!"\n" .)* "\n"
