open Graph


(** Algo Ford Fulkerson **)

(** Fonctions sur les paths **)
let out_arcs_path path id =
  try List.assoc id path
  with Not_found -> raise (Graph_error ("Node " ^ id ^ " does not exist in this path."))
  
  
let find_arc_path path id1 id2 =
  let out = out_arcs_path path id1 in
    try Some (List.assoc id2 out)
    with Not_found -> None

	
(** Fonctions de recherche de chemin **)	
(** Fonction principale renvoyant un chemin sous forme de liste de noeud assoyé à son arc sortant **)

(**
let rec search_path graph acu localisation target noeuds_dest = 
	if localisation = target then acu
		else let arcs_potentiel = List.filter ( fun (y, (z, v)) -> (v < z) ) noeuds_dest in
				begin match arcs_potentiel with
					| [] -> []
					| (y, (z, v)) :: tl -> 
						begin match search_path graph ((localisation, [(y, (z,v))]) :: acu) y target (out_arcs graph y) with
							| [] -> search_path graph acu localisation target tl
							| acu -> acu
						end
				end
**)
				
let rec search_path graph path localisation target noeuds_dest = 
	if localisation = target then path
		else let arcs_potentiel = List.filter ( fun (y, (z, v)) -> (v < z) ) noeuds_dest in
				begin match arcs_potentiel with
					| [] -> path
					| (y, (z, v)) :: tl -> 
						begin match search_path graph (add_arc path localisation y (z,v)) y target (out_arcs graph y) with
							| [] -> search_path graph path localisation target tl
							| path -> path
						end
				end				


				
				
let 2 = search_path
				

(** Fonction de recherche de chemin "User Friendly" **)				
let find_path graph source target =
	search_path graph [] source target ( (fun x -> out_arcs graph x) source)
	

(** Lecture de la valeur maximale de flux pouvant passer dans le chemin trouvé **)
let max_flux_passant path =
	let rec loop_fluxmax mini path =
		match path with
			| [] -> mini
			| (x, (y, (z, v))) :: tl -> if (v < mini) then loop_fluxmax v tl
				else loop_fluxmax mini tl
	in
		loop_fluxmax max_int path


(**
(** Revoir **)
(** Fonction renvoyant la valeur du Flow max circulant dans le graphe **)
let give_flow_max graph target =
	let rec loop_maxflow flowmax graph target =
		match graph with
			| [] -> flowmax
			| (x, (y, (z, v))) :: tl -> if (y = target) then loop_maxflow (flowmax + v) tl target
				else loop_maxflow flowmax tl target
	in
		loop_maxflow 0 graph target
**)

(** Mise à jour du graph d'écart lié **)
let update_graph graph path maxflux =
	let f acu x listArcs = 
		let rec loop_outarcs_update listArcs =
			match listArcs with
				| [] -> acu
				| (y, (z,v)) :: tl ->
						if ((find_arc_path path x y) = None) then loop_outarcs_update tl
						else
							let acu_upd_in_dest = add_arc acu x y (z, ((fun a -> (a + maxflux)) v)) in
								let acu_upd_out_dest = add_arc acu_upd_in_dest y x (z, ((fun (a,b) -> (a - b - maxflux)) (z, v) )) in
									acu_upd_out_dest
		in
			loop_outarcs_update listArcs
	in
		v_fold graph f graph

		
let graphe_sexy graph_origine graph_fin =
	let f acu x listArcs =
		let rec loop_outarcs_compare listArcs =
			match listArcs with
			| [] -> acu
			| (y, (z, v)) :: tl ->
				if ((find_arc graph_fin x y) = None) then loop_outarcs_compare listArcs
				else
					add_arc graph_origine x y (z,v)
		in
			loop_outarcs_compare listArcs
	in	
		v_fold graph_origine f graph_origine	

		
(** Fonction de résolution de graphe selon la méthode Ford-Fulkerson **)
let resolve_ford_fulkerson graph source puit =
	let graph_modifie = map graph ( fun z -> (z,0) ) in
		let rec resolve_loop acu =
			let pathfound = find_path graph_modifie source puit in
				match pathfound with
				| [] -> acu
				| x -> update_graph acu x (max_flux_passant x)
		in
			resolve_loop graph_modifie

let 5 = resolve_ford_fulkerson
					

(** Fonction user friendly renvoyant un graphe solution selon la méthode Ford-Fulkerson **)
let ford_fulkerson graph source puit = graphe_sexy (resolve_ford_fulkerson graphe source puit) graph
					

let 6 = ford_fulkerson
	
