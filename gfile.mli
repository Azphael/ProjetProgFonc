(* Read a graph from a file,
 * Write a graph to a file. 
 * Export a grph to a file for Graphviz *)

open Graph

type path = string

(* Values are read as strings. *)
val from_file: path -> string graph

(* Similarly, we write only a string graph.
 * Use Graph.map if necessary to prepare the input graph. *)
val write_file: path -> string graph -> unit

(* Similarly, we export only a string graph.
 * Use Graph.map if necessary to prepare the input graph. *)
val export: path -> string graph -> unit

