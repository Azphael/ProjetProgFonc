ocamlc -c graph.mli
ocamlc -c graph.ml
ocamlc -c gfile.mli
ocamlc -c gfile.ml
ocamlc -c Ford_Fulkerson.mli
ocamlc -c Ford_Fulkerson.ml
ocamlc -o ftest.exe graph.cmo gfile.cmo ftest.ml
