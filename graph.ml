type id = string

type 'a out_arcs = (id * 'a) list

(* A graph is just a list of pairs: a node & its outgoing arcs. *)
type 'a graph = (id * 'a out_arcs) list

exception Graph_error of string

let empty_graph = []

let node_exists gr id = List.mem_assoc id gr

let out_arcs gr id =
  try List.assoc id gr
  with Not_found -> raise (Graph_error ("Node " ^ id ^ " does not exist in this graph."))

let find_arc gr id1 id2 =
  let out = out_arcs gr id1 in
    try Some (List.assoc id2 out)
    with Not_found -> None

let add_node gr id =
  if node_exists gr id then raise (Graph_error ("Node " ^ id ^ " already exists in the graph."))
  else (id, []) :: gr

let add_arc gr id1 id2 lbl =

  (* Existing out-arcs *)
  let outa = out_arcs gr id1 in

  (* Update out-arcs.
   * remove_assoc does not fail if id2 is not bound.  *)
  let outb = (id2, lbl) :: List.remove_assoc id2 outa in

  (* Replace out-arcs in the graph. *)
  let gr2 = List.remove_assoc id1 gr in
    (id1, outb) :: gr2

let v_iter gr f = List.iter (fun (id, out) -> f id out) gr

let v_fold gr f acu = List.fold_left (fun acu (id, out) -> f acu id out) acu gr


(** Map Function for each graph nodes **)
(** Apply f to each arc labels **)
let rec out_arcs_map f = function
  | [] -> []
  | (a, x) :: tl -> (a, f x) :: (out_arcs_map f tl)

(** Rewrite the graph with modified arc labels **)
let map gr f =
  let rec loop = function
    | [] -> []
    | (a, y) :: tl -> (a, out_arcs_map f y) :: (loop tl)
  in
    loop gr
 
 
 (** Algo Ford Fulkerson **)
(** let noeuds_dest = out_arcs graph localisation in	**)	
 
let rec search_path graph acu localisation target noeuds_dest = 
	if localisation = target then acu
		else let arcs_potentiel = List.filter ( fun (x,y) -> (y > 0) ) noeuds_dest in
				begin match arcs_potentiel with
					| [] -> []
					| (x, y)::tl -> 
						begin match search_path graph ((localisation, (x, y))::acu) x target (out_arcs graph x) with
							| [] -> search_path graph acu localisation target tl
							| acu -> acu
						end
				end
					
					
(** let 3 = search_path **)
					