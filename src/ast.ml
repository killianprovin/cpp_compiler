type pos = Lexing.position

(* Types pris en charge *)
type typ =
  | Int  
  | Void

(* Programme : liste de définitions de fonctions *)
type prog = def list * pos

(* Définition de fonction *)
and def = typ * string * param list * stmt list * pos

(* Paramètre : typ et nom *)
and param = typ * string * pos

(* Instruction *)
and stmt = stmt_node * pos

and stmt_node =
  | Empty                       (* instruction vide ';' *)
  | VarDecl   of typ * string   (* déclaration : int x; *)
  | Assign    of string * expr  (* affectation : x = e; *)
  | Return    of expr           (* return e; *)
  | ExprStmt  of expr           (* expression seule suivie de ';' *)
  | Print     of cout_item list (* cout << ... ; *)
  | Read      of string list    (* cin >> ... ; *)

(* Élément de cout : expression ou endl *)
and cout_item =
  | CVal of expr               (* affichage d'une expression *)
  | CEndl                      (* << endl *)

(* Expression *)
and expr = expr_node * pos

and expr_node = 
  | Const     of int            (* littéral entier *)
  | CharLit   of char           (* littéral caractère *)
  | StringLit of string         (* littéral chaîne *)
  | Var       of string         (* accès à une variable *)
  | Call      of string * expr list (* appel de fonction *)
  | BinOp     of binop * expr * expr  (* opérations binaires *)
  | UnOp      of unop * expr         (* opérations unaires *)

(* Opérateurs binaires *)
and binop =
  | Add | Sub | Mul | Div | Mod
  | Lt  | Le  | Gt  | Ge
  | Eq  | Neq
  | And | Or

(* Opérateurs unaires *)
and unop =
  | Neg   (* -e *)
  | Not   (* !e *)