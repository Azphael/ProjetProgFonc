open Graph
open Printf


(** Algo Ford Fulkerson **)

(** Mise en forme d'un graphe pour prise en compte des variations de flux sur les arcs **)
let formate_graph graph = Graph.map graph ( fun z -> (z, 0) )


(** Fonctions de recherche de chemin **)
(** Fonction principale renvoyant un graphe chemin avec arcs sortants uniques pour chacun de ses noeuds **)
let rec search_path graph path localisation target =
	if localisation = target then path
	else
		let f path localisation out_arcs = 
			let rec loop_search_path out_arcs =
				match out_arcs with
					| [] -> path
					| (y, (z, v)) :: tl ->
						if ((Graph.node_exists path y) = true ) then loop_search_path tl
						else
							if (v < z) then 
								let new_arc_path = Graph.add_arc path localisation y (z,v) in
									search_path graph new_arc_path y target
							else
								loop_search_path tl
			in
				loop_search_path out_arcs
		in
			Graph.v_fold path f graph

				
(** Habillage "User Friendly" de la fonction de recherche de chemin **)				
let find_path graph source target =
	search_path graph Graph.empty_graph source target


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
		Graph.v_fold path f max_int


(** Mise à jour du graph d'écart lié : parcours de comparaison sur le graphe **)
let update_graph graph path maxflux =
	let f update x listArcs = 
		let rec loop_outarcs_update listArcs =
			match listArcs with
				| [] -> update
				| (y, (z,v)) :: tl ->
						if ((Graph.find_arc path x y) = None) then loop_outarcs_update tl
						else
							let acu_upd_in_dest = Graph.add_arc update x y (z, (v + maxflux)) in
								Graph.add_arc acu_upd_in_dest y x (z, (z - v - maxflux))
		in
			loop_outarcs_update listArcs
	in
		Graph.v_fold graph f graph


(** Mise à jour alternative du graph d'écart lié : parcours de comparaison sur le path **)		
let alt_update_graph graph path maxflux =
	let f updatedgraph x listArc =
			match listArc with
				| [] -> updatedgraph
				| (y, (z,v)) :: tl ->
						let acu_upd_in_dest = Graph.add_arc updatedgraph x y (z, (v + maxflux)) in
							Graph.add_arc acu_upd_in_dest y x (z, (z - v - maxflux))
	in
		Graph.v_fold path f graph


(** Suppression dans le graphe solution des arcs non présents dans le graphe d'origine **)		
let graphe_sexy graph_origine graph_fin =
	let f acu x listArcs =
		let rec loop_outarcs_compare listArcs =
			match listArcs with
			| [] -> acu
			| (y, (z, v)) :: tl ->
				if ((Graph.find_arc graph_origine x y) = None) then loop_outarcs_compare listArcs
				else
					Graph.add_arc graph_origine x y (z,v)
		in
			loop_outarcs_compare listArcs
	in	
		Graph.v_fold graph_fin f graph_origine	

		
(** Fonction de résolution de graphe selon la méthode Ford-Fulkerson **)
let resolve_ford_fulkerson graph source puit =
	let rec loop_resolve_ff acu =
		let pathfound = find_path graph source puit in
			if (pathfound = Graph.empty_graph) then acu
			else
				let maxflow = max_flux_passant pathfound in
					loop_resolve_ff (alt_update_graph acu pathfound maxflow)
		in
			loop_resolve_ff graph


(** Fonction user friendly renvoyant un graphe solution selon la méthode Ford-Fulkerson **)
let ford_fulkerson graph source puit =
	let graph_modifie = formate_graph graph in
		let graph_fin = resolve_ford_fulkerson graph_modifie source puit in
			graphe_sexy graph_modifie graph_fin


(** Fonction d'export des graphes solution de l'algorithme Ford-Fulkerson **)			
let export file graph source target =

  (* Open an export-file. *)
  let ff = open_out file in

  (* Write in this file the standard Graphviz form. *)
  fprintf ff "digraph finite_state_machine {\n" ;
  fprintf ff "rankdir=LR;\n" ;
  fprintf ff "size=\"8.5\"\n" ;
 
  fprintf ff "node [shape= circle];\n" ;
  fprintf ff "\t%s [color = green];\n" source ;
  fprintf ff "\t%s [color = red];\n" target ;
   
  (* Write all arcs with origin, target and labels *)
  v_iter graph (fun id out -> List.iter (fun (id2, (a,b)) -> fprintf ff "%s -> %s [ label = \"%d/%d\" ];\n" id id2 b a) out) ;
   
  fprintf ff "}\n" ;

  close_out ff ;
  ()
