open Graph


(** Algo Ford Fulkerson **)

(**
(** Fonctions sur les paths **)
let out_arcs_path path id =
  try List.assoc id path
  with Not_found -> raise (Graph_error ("Node " ^ id ^ " does not exist in this path."))
  
  
let find_arc_path path id1 id2 =
  let out = out_arcs_path path id1 in
    try Some (List.assoc id2 out)
    with Not_found -> None
**)
	
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


(** 				
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
**)

let rec search_path graph path localisation target noeuds_dest =
	if localisation = target then path
	else
		let arcs_potentiel = List.filter ( fun (y, (z, v)) -> (v < z) ) noeuds_dest in
			let f path localisation arcs_potentiel = 
				let rec loop_search_path arcs_potentiel =
					match arcs_potentiel with
						| [] -> path
						| (y, (z, v)) :: tl ->
							if ((node_exists path y) = true ) then loop_search_path tl
							else
								let new_arc_path = add_arc path localisation y (z,v) in
									search_path graph new_arc_path y target (out_arcs graph y)
				in
					loop_search_path arcs_potentiel
			in
				v_fold path f graph


(** Fonction de recherche de chemin "User Friendly" **)				
let find_path graph source target =
	search_path graph empty_graph source target ( (fun x -> out_arcs graph x) source)


(** Lecture de la valeur maximale de flux pouvant passer dans le chemin trouvé **)
(** let max_flux_passant path =
	let rec loop_fluxmax mini path =
		match path with
			| [] -> mini
			| (x, (y, (z, v))) :: tl -> if (v < mini) then loop_fluxmax v tl
				else loop_fluxmax mini tl
	in
		loop_fluxmax max_int path **)


let max_flux_passant path =
	let f mini x listArcs =
		let rec loop_fluxmax mini listArcs =
			match listArcs with
				| [] -> mini
				| (y, (z, v)) :: tl -> if (v < mini) then loop_fluxmax v tl
					else loop_fluxmax mini tl
		in
			loop_fluxmax mini listArcs
	in
		v_fold path f max_int


(** Mise à jour du graph d'écart lié parcours de comparaison sur le graphe **)
let update_graph graph path maxflux =
	let f update x listArcs = 
		let rec loop_outarcs_update listArcs =
			match listArcs with
				| [] -> update
				| (y, (z,v)) :: tl ->
						if ((find_arc path x y) = None) then loop_outarcs_update tl
						else
							let acu_upd_in_dest = add_arc update x y (z, (v + maxflux)) in
								add_arc acu_upd_in_dest y x (z, (z - v - maxflux))
		in
			loop_outarcs_update listArcs
	in
		v_fold graph f graph


(** Mise à jour alternative du graph d'écart lié : parcours de comparaison sur le path **)		
let alt_update_graph graph path maxflux =
	let f updatedgraph x listArc =
		let rec loop_outarcs_update listArc =
			match listArc with
				| [] -> updatedgraph
				| (y, (z,v)) :: tl ->
						let acu_upd_in_dest = add_arc updatedgraph x y (z, (v + maxflux)) in
							add_arc acu_upd_in_dest y x (z, (z - v - maxflux))
		in
			loop_outarcs_update listArc
	in
		v_fold path f graph


(** Suppression dans le graphe solution des arcs non présents dans le graphe d'origine **)		
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

			
(** let resolve_ford_fulkerson graph source puit =
	let graph_modifie = map graph ( fun z -> (z, 0) ) in
		let rec loop_resolve_ff acu **)
			
			
			
			
let 5 = resolve_ford_fulkerson
					

(** Fonction user friendly renvoyant un graphe solution selon la méthode Ford-Fulkerson **)
let ford_fulkerson graph source puit =
	let graph_fin = resolve_ford_fulkerson graphe source puit in
		graphe_sexy graph graph_fin
					

let 6 = ford_fulkerson
	
