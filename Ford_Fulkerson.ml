open Graph


(** Algo Ford Fulkerson **)

(** Fonctions de recherche de chemin **)

(** Fonction principale renvoyant un chemin sous forme de liste de noeud assoyé à son arc sortant **)	
let rec search_path graph acu localisation target noeuds_dest = 
	if localisation = target then acu
		else let arcs_potentiel = List.filter ( fun (y, (z, v)) -> (v < z) ) noeuds_dest in
				begin match arcs_potentiel with
					| [] -> []
					| (y, (z, v)) :: tl -> 
						begin match search_path graph ((localisation, (y, (z,v))) :: acu) y target (out_arcs graph y) with
							| [] -> search_path graph acu localisation target tl
							| acu -> acu
						end
				end


(** Fonction de recherche de chemin "User Friendly" **)				
let find_path graph source target =
	search_path graph [] source target ( (fun x -> out_arcs graph x) source)
	

(** Lecture de la valeur minimale de flux pouvant passer dans le chemin trouvé **)
let minflux path =
	let rec loop_fluxmin acu path =
		match path with
			| [] -> acu
			| (x, (y, (z, v))) :: tl -> if (v < acu) then loop_fluxmin v tl
				else loop_fluxmin acu tl
	in
		loop_fluxmin max_int path


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

	

(**		
(** Recherche dans le path l'arc associé au sommet **)
let out_arcs_path path id =
  try List.assoc id path
  with Not_found -> raise (Graph_error ("Node " ^ id ^ " does not exist in this path."))


		
(** Fonction cherchant la présence d'un arc particulier dans un path **)
let find_arc_path path id1 id2 =
  let out = out_arcs_path path id1 in
    try Some (List.assoc id2 out)
    with Not_found -> None
**)


(** Revoir **)		
(** Mise à jour du graph d'écart lié **)
let update_graph graph path minflux =
	let rec loop_update acu graph path minflux =
		match graph with
			| [] -> acu
			| (x, (y, (z, v)) :: tl -> if ((find_arc path x y) = None) then loop_update acu tl path minflux (** le probleme semble venir du fait que graph est de la forme liste(id1, liste (id2, value) **)
				else
					let acu_upd_in_dest = add_arc acu x y (z, ((fun a -> (a + minflux)) v)) in
						let acu_upd_out_dest = add_arc acu_upd_in_dest y x (z, ((fun (a,b) -> (a - b - minflux)) (z, v) )) in
							loop_update acu_upd_out_dest tl path minflux
	in
		loop_update graph graph path minflux

let 3 = update_graph

let update_graph2 graph path minflux =
	let rec loop_update2 acu graph path minflux =
		match graph with
			| [] -> acu
			| (x, y) :: tl -> if ((find_arc path x y) = None)
				then loop_update2 acu tl path minflux
				else
					begin match ((find_arc path x y) with
						| (z, v) -> let acu_upd_in_dest = add_arc acu x y (z, ((fun a -> (a + minflux)) v)) in
										let acu_upd_out_dest = add_arc acu_upd_in_dest y x (z, ((fun (a,b) -> (a - b - minflux)) (z, v) )) in
											loop_update2 acu_upd_out_dest tl path minflux
	in
		loop_update2 graph graph path minflux


		
(** Revoir **)	
(** Fonction renvoyant un graphe sans les arcs retour du graphe d'écart  **)
let graphe_sexy graph_origine graph_modifie =
	let rec sexy_loop acu graph_origine graph_modifie =
		match graph_origine with
			| [] -> acu
			| (x, (y, (z, v))) :: tl -> 
				let updated_label = find_arc graph_modifie x y in
					if (updated_label = None) then sexy_loop acu tl graph_modifie
					else
						let acu_upd_arc = add_arc x y updated_label in
							sexy_loop acu_upd_arc tl graph_modifie
	in
		sexy_loop graph_origine graph_origine graph_modifie

let 4 = graphe_sexy


		
(** Fonction de résolution de graphe selon la méthode Ford-Fulkerson **)
let resolve_ford_fulkerson graph source sink =
	let graph_modifie = map graph ( fun z -> (z,0) ) in
		let pathfound = find_path graph_modifie source sink in
			let minfluxpath = minflux pathfound in
				let rec resolve_loop acu pathfound =
					match pathfound with
						| [] -> acu
						| x -> acu = update_graph graph_modifie pathfound minfluxpath
				in
					resolve_loop [] pathfound

let 5 = resolve_ford_fulkerson
					

(** Fonction user friendly renvoyant un graphe solution selon la méthode Ford-Fulkerson **)
let ford_fulkerson graph source sink = graphe_sexy (resolve_ford_fulkerson graphe source sink) graph
					

let 6 = ford_fulkerson
	
