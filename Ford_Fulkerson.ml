open Graph


(** Algo Ford Fulkerson **)

(** Fonctions de recherche de chemin **)

(** Transformation du Graphe d'origine en graphe complet avec Flow max et coût passage **)
let rec transfograph graph_origine graph_modifie = 
	match graph_origine with
		| [] -> graph_modifie
		| (x, (y, z)) :: tl -> transfograph tl ((x, (y, (z, 0))) :: graph_modifie)

(** let rec transfograph graph_origine graph_modifie =
	| [] -> graph_modifie
	| (x, (y, z, c)) :: tl -> transfograph tl ((x, (y, (z, c, 0))) :: graph_modifie) **)


(** Fonction principale renvoyant un chemin sous forme de liste de noeud assoyé à son arc sortant **)	
let rec search_path graph_modifie acu localisation target noeuds_dest = 
	if localisation = target then acu
		else let arcs_potentiel = List.filter ( fun (y,(z, v)) -> (v < z) ) noeuds_dest in
				begin match arcs_potentiel with
					| [] -> []
					| (y, (z, v)) :: tl -> 
						begin match search_path graph_modifie ((localisation, (y, (z,v))) :: acu) y target (out_arcs graph_modifie y) with
							| [] -> search_path graph_modifie acu localisation target tl
							| acu -> acu
						end
				end


(** Fonction de recherche de chemin "User Friendly" **)				
let find_path graph_modifie source target =
	search_path graph_modifie [] source target ( (fun x -> out_arcs graph_modifie x) source)
	

(** Lecture de la valeur minimale de flux pouvant passer dans le chemin trouvé **)
let minflux foundpath =
	let rec loop_fluxmin acu foundpath =
	match foundpath with
		| [] -> acu
		| (x, (y, (z, v))) :: tl -> if (v < acu) then loop_fluxmin v tl
			else loop_fluxmin acu tl
	in
		loop_fluxmin max_int foundpath


(** Fonction renvoyant la valeur du Flow max circulant dans le graphe **)
let give_flow_max graph_modifie target =
	let rec loop_maxflow flowmax graph_modifie target =
		match graph_modifie with
			| [] -> flowmax
			| (x, (y, (z, v))) :: tl -> if (y = target) then loop_maxflow (flowmax + v) tl target
				else loop_maxflow flowmax tl target
	in
		loop_maxflow 0 graph_modifie target

		
(** Mise à jour du graph d'écart lié **)
let update_graph_modifie graph_modifie found_path minflux =
	let rec loop_update acu graph_modifie found_path minflux =
		match graph_modifie with
			| [] -> acu
			| (x, (y, (z, v))) :: tl -> if ((find_arc found_path x y) = None) then loop_update acu tl found_path minflux
				else
					let acu_upd_in_dest = add_arc acu x y (z, ((fun a -> (a + minflux)) v)) in
						let acu_upd_out_dest = add_arc acu_upd_in_dest y x (z, ((fun (a,b) -> (a - b - minflux)) (z, v) )) in
							loop_update acu_upd_out_dest tl found_path minflux
	in
		loop_update graph_modifie graph_modifie found_path minflux

let 3 = update_graph_modifie

		
(**	
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
	let graph_modifie = transfograph graph [] in
		let pathfinder = find_path graph_modifie source sink in
			let minfluxpath = minflux pathfinder in
				let rec resolve_loop acu pathfinder =
					match pathfinder with
						| [] -> acu
						| x -> acu = update_graph_modifie graph_modifie pathfinder minfluxpath
				in
					resolve_loop [] pathfinder

let 5 = resolve_ford_fulkerson
					

(** Fonction user friendly renvoyant un graphe solution selon la méthode Ford-Fulkerson **)
let ford_fulkerson graph source sink = graphe_sexy (resolve_ford_fulkerson graphe source sink) graph
					

let 6 = ford_fulkerson
**)			
