open Graph


(** Algo Ford Fulkerson **)

(** Mise en forme d'un graphe pour prise en compte des variations de flux sur les arcs **)
let formate_graph graph = map graph ( fun z -> (z, 0) )


(** Fonctions de recherche de chemin **)
(** Fonction principale renvoyant un graphe chemin avec arcs sortants uniques pour chacun de ses noeuds **)
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

				
(** Habillage "User Friendly" de la fonction de recherche de chemin **)				
let find_path graph source target =
	search_path graph empty_graph source target ( (fun x -> out_arcs graph x) source)


(** Fonction de recherche du flux max pouvant passer par le graphe de chemin **)
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
			match listArc with
				| [] -> updatedgraph
				| (y, (z,v)) :: tl ->
						let acu_upd_in_dest = add_arc updatedgraph x y (z, (v + maxflux)) in
							add_arc acu_upd_in_dest y x (z, (z - v - maxflux))
	in
		v_fold path f graph


(** Suppression dans le graphe solution des arcs non présents dans le graphe d'origine **)		
let graphe_sexy graph_origine graph_fin =
	let f acu x listArcs =
		let rec loop_outarcs_compare listArcs =
			match listArcs with
			| [] -> acu
			| (y, (z, v)) :: tl ->
				if ((find_arc graph_origine x y) = None) then loop_outarcs_compare listArcs
				else
					add_arc graph_origine x y (z,v)
		in
			loop_outarcs_compare listArcs
	in	
		v_fold graph_fin f graph_origine	

		
(** Fonction de résolution de graphe selon la méthode Ford-Fulkerson **)
(** let resolve_ford_fulkerson graph source puit =
	let graph_modifie = map graph ( fun z -> (z,0) ) in
		let rec resolve_loop acu =
			let pathfound = find_path graph_modifie source puit in
				match pathfound with
				| [] -> acu
				| x -> update_graph acu x (max_flux_passant x)
		in
			resolve_loop graph_modifie
**)
			
let resolve_ford_fulkerson graph source puit =
	let rec loop_resolve_ff acu =
		let pathfound = find_path graph source puit in
			if (pathfound = empty_graph) then acu
			else
				let maxflow = max_flux_passant pathfound in
					loop_resolve_ff (update_graph acu pathfound maxflow)
		in
			loop_resolve_ff graph


(** Fonction user friendly renvoyant un graphe solution selon la méthode Ford-Fulkerson **)
let ford_fulkerson graph source puit =
	let graph_modifie = formate_graph graph in
		let graph_fin = resolve_ford_fulkerson graph_modifie source puit in
			graphe_sexy graph_modifie graph_fin
					
