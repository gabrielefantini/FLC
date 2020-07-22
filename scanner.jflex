/**************************
 Scanner
***************************/

import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column

%{
	private Symbol sym(int type) {
		return new Symbol(type, yyline, yycolumn);
	}
	
	private Symbol sym(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
	
%}

hex_e = [02468aAcCeE]
hex = ("-"(5[cC] | [1-4]{hex_e} | {hex_e})) | ({hex_e} | [a-fA-F]{hex_e} | [aA][0-9aA]{hex_e} | [aA][bB][0246])
tok1 = (a|b|c){7}((a|b|c)(a|b|c))*"#"{hex}?
time = ( (07":"13":"2[4-9])|(07":"13":"[3-5][0-9])|(07":"1[4-9]":"([0-5][0-9])) | (07":"[2-5][0-5]":"([0-5][0-9])) |
       ((0[89]|1[0-6])":"[0-5][0-9]":"([0-5][0-9])) | (17":"([0-2][0-9])":"([0-5][0-9])) | (17":"(3[0-6])":"([0-5][0-9]))|(17":"37":"([0-3][0-9]))| (17":"37":"4[0-3]))
binary = 101|110|111| 1(0|1){3} | 101(0|1){2}| 11001 | 11011
tok2 = {time}":"{binary}
variable = [A-Za-z_][A-Za-z0-9_]*
integer =  ([1-9][0-9]*|0)
comment = "(++"~"++)"

%%

	"compare"  { return sym(sym.COMPARE_LABEL);}
	"with"     { return sym(sym.WITH_LABEL);}
	"end"      { return sym(sym.END_LABEL);}
	"print"    { return sym(sym.PRINT_LABEL);}
	"("        { return sym(sym.RO);}
	")"        { return sym(sym.RC);}
	";"         { return sym(sym.S);}
	"+"        { return sym(sym.PLUS);}
	"-"        { return sym(sym.MINUS);}
	"*"        { return sym(sym.STAR);}
	"/"        { return sym(sym.DIV);}
	"="        { return sym(sym.EQ);}
	"{"         { return sym(sym.BO);}
	"}"         {return sym(sym.BC);}
    "$$"       { return sym(sym.SEP);}
    {tok1}     { return sym(sym.TOK1);}
	{tok2}     { return sym(sym.TOK2);}
	{variable} { return sym(sym.VARIABLE, yytext());}
	{integer}  { return sym(sym.INT, new Integer(yytext()));}
	{comment}  { ;}
	
	
	\r | \n | \r\n | " " | \t	{;}

	.				{ System.out.println("Scanner Error: " + yytext()); }



