# cpp_compiler

Un compilateur C++ simplifié en OCaml.

## Structure
- `src/` : cœur du compilateur (analyse lexicale, syntaxique, génération MIPS)
- `test/` : cas de test (C++, sortie MIPS, etc.)
- `proofs/` : formalisation Coq à venir

## Compilation
```bash
dune build