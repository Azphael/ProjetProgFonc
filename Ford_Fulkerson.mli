(** Alg Ford Fulkerson **)

val find_arc_path: ('a * 'b) list -> 'a -> 'b

val out_arcs_path: ('a * ('b * 'c) list) list -> 'a -> 'b -> 'c option

(** Recherche le chemin dans un graphe entre un noeud initial et une cible finale, et renvoi **)
(** val search_path: ('a * 'a) Graph.graph ->
					(Graph.id * (Graph.id * ('a * 'a))) list ->
					Graph.id ->
					Graph.id ->
					('a * 'a) Graph.out_arcs -> (Graph.id * (Graph.id * ('a * 'a))) list **)
val search_path: int					
			
(** Trouve le chemin dans un graphe entre une "source" et un "puit" **)		   
val find_path: ('a * 'a) Graph.graph ->
         Graph.id -> Graph.id -> (Graph.id * (Graph.id * ('a * 'a))) list
		   
(** Valeur minimale de flux pouvant passer dans le chemin trouvé **)
val max_flux_passant: ('a * ('b * ('c * int))) list -> int

(** Fonction renvoyantla valeur du Flow max circulant dans le graphe **)
val give_flow_max: ('a * ('b * ('c * int))) list -> 'b -> int

(** Mise à jour du graph d'écart lié **)
(** val update_graph: ('a * 'a) Graph.graph ->
         'a Graph.graph -> 'a -> ('a * 'a) Graph.graph **)
val update_graph: ('a * 'a) Graph.graph ->
         (Graph.id * (Graph.id * 'b) list) list ->
         int -> ('a * 'a) Graph.graph

(** Fonction renvoyant un graphe sans les arcs retour du graphe d'écart  **)
val graphe_sexy:  ('a * 'b) Graph.graph -> 'c Graph.graph -> ('a * 'b) Graph.graph

(** Fonction de résolution de graphe selon la méthode Ford-Fulkerson **)
val resolve_ford_fulkerson: int

(** Fonction user friendly renvoyant un graphe solution selon la méthode Ford-Fulkerson **)
val ford_fulkerson: int






(** Transformation du Graphe d'origine en graphe complet avec Flow max et coût passage **)
(** val transfograph: ('a * ('b * 'c)) list ->
					('a * ('b * ('c * int))) list -> ('a * ('b * ('c * int))) list **)
