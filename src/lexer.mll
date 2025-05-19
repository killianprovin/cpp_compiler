{ 
  open Lexing
  open Parser
  exception Lexing_error of char * position

  let kwd_tbl = [
    "int",    INT;
    "void",   VOID;
    "return", RETURN;
    "if",     IF;
    "else",   ELSE;
    "break",  BREAK;
    "continue", CONTINUE;
    "cin",    CIN;
    "cout",   COUT;
    "endl",   ENDL
  ]

  let id_or_kwd s =
    try List.assoc s kwd_tbl
    with Not_found -> IDENT s

  let newline lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <- 
      { pos with pos_lnum = pos.pos_lnum + 1; pos_bol = pos.pos_cnum }
}

let letter    = ['A'-'Z' 'a'-'z' '_']
let digit     = ['0'-'9']
let ident     = letter (letter | digit)*
let integer   = digit+
let char_lit  = '\'' [^ '\'' '\n'] '\''
let str_char  = [^ '"' '\n']
let string_lit= '"' str_char* '"'
let space     = [' ' '\t' '\r']

rule token = parse
    | space+                  { token lexbuf }
    | '\n'                    { newline lexbuf; token lexbuf }

    | "//" [^ '\n']*          { token lexbuf }
    | "/*"                    { comment lexbuf; token lexbuf }

    | integer as s            { CST (int_of_string s) }
    | char_lit as s           { let c = String.get s 1 in CHAR c }
    | string_lit as s         {
        let len = String.length s in
        let content = String.sub s 1 (len - 2) in
        STRING content
    }

    | ident as id             { id_or_kwd id }

    | "=="                    { EQQ }
    | "!="                    { NEQ }
    | "<="                    { LE }
    | ">="                    { GE }
    | "&&"                    { AND }
    | "||"                    { OR }
    | "<<"                    { LSHIFT }
    | ">>"                    { RSHIFT }

    | '+'                     { PLUS }
    | '-'                     { MINUS }
    | '*'                     { TIMES }
    | '/'                     { DIV }
    | '%'                     { MOD }
    | '='                     { EQ }
    | '<'                     { LT }
    | '>'                     { GT }
    | '!'                     { NOT }
    | '('                     { LP }
    | ')'                     { RP }
    | '{'                     { LB }
    | '}'                     { RB }
    | ';'                     { SEMICOLON }
    | ','                     { COMMA }

    | eof                     { EOF }

    | _ as c                  { raise (Lexing_error (c, lexbuf.lex_curr_p)) }

and comment = parse
    | "*/"                    { () }
    | '\n'                    { newline lexbuf; comment lexbuf }
    | eof                     { () }
    | _                       { comment lexbuf }