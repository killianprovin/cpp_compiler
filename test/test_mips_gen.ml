open Cpp_compiler.Mips

let exemple : program = {
  text = [
    Comment "Programme : addition + boucle conditionnelle";
    Label "main";

    Comment "Initialisation : t0 = 0, t1 = 10";
    Li (T 0, 0);
    Li (T 1, 10);

    Comment "Boucle : while (t0 < t1)";
    Label "loop";

    Comment "Afficher t0";
    Move (A0, T 0);
    Li (V0, 1); Syscall;

    Comment "Incrémenter t0";
    Arithi (Add, T 0, T 0, 1);

    Comment "Condition : si t0 < t1, saut vers loop";
    Arith (Slt, T 2, T 0, T 1);
    Beq (T 2, ZERO, Alab "end");

    J "loop";

    Label "end";

    Comment "Afficher le message final";
    La (A0, "msg");
    Li (V0, 4);
    Syscall;

    Comment "Fin du programme";
    Li (V0, 10);
    Syscall
  ];

  data = [
    Asciiz ("msg", "Fin du programme !");
  ]
}

let () =
  print_program exemple "test.s";
  print_endline "Fichier test.s généré avec succès."