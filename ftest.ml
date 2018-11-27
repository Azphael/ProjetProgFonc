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
  let graph = Gfile.from_file infile in

  (* Rewrite the graph that has been read. *)
  (* let () = Gfile.write_file outfile graph in *)
  
  (* Export the graph as a Graphviz file. *)
  (* let () = Gfile.export outfile graph in *)

  (* () *)
  
  
  let afficher_result =  List.iter (fun (x,(y,z)) -> Printf.printf "%s --> %s,%d \n" x y z ) in
  
  let graph2 = map graph int_of_string in
  
  let toto = out_arcs graph2 source in
	let test = search_path graph2 [source,(source,0)] source sink toto in
		afficher_result test



