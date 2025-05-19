%{ 
  open Ast
%}

%token <int>    CST
%token <char>   CHAR
%token <string> STRING
%token <string> IDENT

%token        INT VOID RETURN IF ELSE BREAK CONTINUE
%token        CIN COUT ENDL

%token        LP RP LB RB          /* ( ) { } */
%token        COMMA SEMICOLON EOF

%token        PLUS MINUS TIMES DIV MOD
%token        EQ                    /* = */
%token        LT LE GT GE
%token        EQQ NEQ
%token        AND OR
%token        LSHIFT RSHIFT         /* << >> */
%token        NOT

/* Priorités et associativités */
%left OR
%left AND
%nonassoc EQQ NEQ
%nonassoc LT LE GT GE
%left LSHIFT RSHIFT
%left PLUS MINUS
%left TIMES DIV MOD
%nonassoc uminus NOT

/* Point d'entrée */
%start file
%type  <Ast.prog> file

%%

file:
  defs = def* EOF            { defs, $startpos }
;

def:
  t=typ name=IDENT LP params=separated_list(COMMA, param) RP LB body=stmt* RB
                             { (t, name, params, body, $startpos) }
;

param:
  t=typ id=IDENT             { (t, id, $startpos) }
;

typ:
  | INT                     { Int }
  | VOID                    { Void }
;

stmt:
  | SEMICOLON               { (Empty, $startpos) }
  | INT id=IDENT SEMICOLON  { (VarDecl(Int, id), $startpos) }
  | id=IDENT EQ e=expr SEMICOLON
                             { (Assign(id, e), $startpos) }
  | RETURN e=expr SEMICOLON  { (Return(e), $startpos) }
  | e=expr SEMICOLON         { (ExprStmt(e), $startpos) }
  | COUT items=cout_items SEMICOLON
                             { (Print(items), $startpos) }
  | CIN  items=cin_items  SEMICOLON
                             { (Read(items), $startpos) }
;

cout_items:
    LSHIFT item=cout_item rest=cout_rest
                             { item :: rest }
;

cout_item:
  | e=expr                   { CVal(e) }
  | ENDL                     { CEndl }
;

cout_rest:
  | LSHIFT item=cout_item rest=cout_rest { item :: rest }
  |                                  { [] }
;

cin_items:
    RSHIFT id=IDENT rest=cin_rest
                             { id :: rest }
;

cin_rest:
  | RSHIFT id=IDENT rest=cin_rest { id :: rest }
  |                               { [] }
;

expr:
  | CST                       { (Const($1), $startpos) }
  | CHAR                      { (CharLit($1), $startpos) }
  | STRING                    { (StringLit($1), $startpos) }
  | id=IDENT LP a=args RP     { (Call(id, a), $startpos) }
  | id=IDENT                  { (Var(id), $startpos) }
  | LP e=expr RP              { e }
  | e1=expr PLUS  e2=expr     { (BinOp(Add, e1, e2), $startpos) }
  | e1=expr MINUS e2=expr     { (BinOp(Sub, e1, e2), $startpos) }
  | e1=expr TIMES e2=expr     { (BinOp(Mul, e1, e2), $startpos) }
  | e1=expr DIV   e2=expr     { (BinOp(Div, e1, e2), $startpos) }
  | e1=expr MOD   e2=expr     { (BinOp(Mod, e1, e2), $startpos) }
  | e1=expr LT    e2=expr     { (BinOp(Lt, e1, e2), $startpos) }
  | e1=expr LE    e2=expr     { (BinOp(Le, e1, e2), $startpos) }
  | e1=expr GT    e2=expr     { (BinOp(Gt, e1, e2), $startpos) }
  | e1=expr GE    e2=expr     { (BinOp(Ge, e1, e2), $startpos) }
  | e1=expr EQQ   e2=expr     { (BinOp(Eq, e1, e2), $startpos) }
  | e1=expr NEQ   e2=expr     { (BinOp(Neq, e1, e2), $startpos) }
  | e1=expr AND   e2=expr     { (BinOp(And, e1, e2), $startpos) }
  | e1=expr OR    e2=expr     { (BinOp(Or, e1, e2), $startpos) }
  | MINUS e=expr %prec uminus { (UnOp(Neg, e), $startpos) }
  | NOT e=expr                { (UnOp(Not, e), $startpos) }
;

args:
  |                        { [] }
  | e=expr                 { [e] }
  | a=args COMMA e=expr    { a @ [e] }
;