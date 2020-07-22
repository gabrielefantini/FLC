/**************************
 Scanner
***************************/

import java_cup.runtime.*;

%%

%state COMMENT
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

tok1 = (a|b|c){7}((a|b|c)(a|b|c))*"#"

tok2 = (07":"13":"2[4-9])|(07":"13":"[3-5][0-9])|(07":"1[4-9]":"([0-5][0-9])) | (07":"[2-5][0-5]":"([0-5][0-9])) |
       ((8|9|10|11|12|13|14|15|16)":"[0-5][0-5]":"([0-5][0-9])) | 17":"([0-2][0-9]))":"([0-5][0-9]) | 17":"([0-2][0-9]))":"(3[0-6])":"([0-5][0-9])|(17":"37":"([0-3][0-9]))| (17":"37":"4[0-3])

variable = [A-Za-z_][A-Za-z0-9_]*
integer =  ([1-9][0-9]*|0)

%%


<YYINITIAL> {
    {tok1}
	{tok2}
	{variable} { return sym(sym.VARIABLE, yytext());}
	{integer}  { return sym(sym.INT, new Integer(yytext()));}
	"compare"  { return sym(sym.COMPARE_LABEL);}
	"with"     { return sym(sym.WITH_LABEL);}
	"end"      { return sym(sym.END_LABEL);}
	"print"    { return sym(sym.PRINT_LABEL);}
	"("        { return sym(sym.RO);}
	")"        { return sym(sym.RC);}
	";"         { return sym(sym.S);}
	"+"        { return sym(sym.RPLUS);}
	"-"        { return sym(sym.MINUS);}
	"*"        { return sym(sym.STAR);}
	"/"        { return sym(sym.DIV);}
	
	"{"         { return sym(sym.BO);}
	"}"         {return sym(sym.BC);}
    "$$"  { return sym(sym.SEP);}
	"(++" { yybegin(COMMENT); } 
	\r | \n | \r\n | " " | \t	{;}

	.				{ System.out.println("Scanner Error: " + yytext()); }
}


<COMMENT> {
  [^*]*      { ; }
  "++)"    { yybegin(YYINITIAL); } 
}
