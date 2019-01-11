open Graph
open Ford_Fulkerson

let () =

  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf "\nUsage: %s infile source sink outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;

  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)
  
  (* These command-line arguments are not used for the moment. *)
  and source = Sys.argv.(2)
  and sink = Sys.argv.(3)
  in

  (* Open file *)
  let string_graph = Gfile.from_file infile in
  let int_graph = Graph.map string_graph int_of_string in

  (* Rewrite the graph that has been read. *)
  let () = Gfile.write_file (outfile ^ ".out") string_graph in
  
  (* Export the graph as a Graphviz file. *)
  let () = Gfile.export (outfile ^ ".gvz") string_graph in

  (* Run the Ford-Fulkerson algorithm on the imported graph *)
  Printf.printf "\n==== Running Ford-Fulkerson Algorithm on '%s' ====\n%!" infile ;
  let solution = Ford_Fulkerson.ford_fulkerson int_graph source sink in
    Ford_Fulkerson.export (outfile ^ ".ff.gvz") solution source sink
  