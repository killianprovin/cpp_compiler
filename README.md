# cpp_compiler

Un compilateur C++ simplifié en OCaml.

## Structure
- `src/` : cœur du compilateur (analyse lexicale, syntaxique, génération MIPS)
- `test/` : cas de test (C++, sortie MIPS, etc.)
- `proofs/` : formalisation Coq à venir

## Compilation
```bash
dune build
```

## Tests
```bash
# Tester l'analyseur lexical
dune exec test/test_lexer.exe examples/valid.cpp

# Tester l'analyseur syntaxique
dune exec test/test_parser.exe examples/valid.cpp

# Tester la génération de code MIPS
dune exec test/test_mips_gen.exe
```