(** Alg Ford Fulkerson **)

(** Mise en forme d'un graphe pour prise en compte des variations de flux sur les arcs **)
val formate_graph: 'a Graph.graph -> ('a * int) Graph.graph

(** Recherche le chemin dans un graphe entre un noeud initial et une cible finale, et renvoi **)
val search_path: ('a * 'a) Graph.graph -> ('a * 'a) Graph.graph -> Graph.id -> Graph.id -> ('a * 'a) Graph.out_arcs -> ('a * 'a) Graph.graph

(** Trouve le chemin dans un graphe entre une "source" et un "puit" **)		   
val find_path: ('a * 'a) Graph.graph -> Graph.id -> Graph.id -> ('a * 'a) Graph.graph

(** Valeur minimale de flux pouvant passer dans le chemin trouvé **)
val max_flux_passant: ('a * int) Graph.graph -> int

(** Fonction renvoyantla valeur du Flow max circulant dans le graphe **)
(** val give_flow_max: int **)

(** Mise à jour du graph d'écart lié **)
val update_graph: (int * int) Graph.graph -> 'a Graph.graph -> int -> (int * int) Graph.graph

val alt_update_graph: (int * int) Graph.graph -> (int * int) Graph.graph -> int -> (int * int) Graph.graph

(** Fonction renvoyant un graphe sans les arcs retour du graphe d'écart  **)
val graphe_sexy:  ('a * 'b) Graph.graph -> ('a * 'b) Graph.graph -> ('a * 'b) Graph.graph

(** Fonction de résolution de graphe selon la méthode Ford-Fulkerson **)
val resolve_ford_fulkerson: (int * int) Graph.graph -> Graph.id -> Graph.id -> (int * int) Graph.graph

(** Fonction user friendly renvoyant un graphe solution selon la méthode Ford-Fulkerson **)
val ford_fulkerson: int Graph.graph -> Graph.id -> Graph.id -> (int * int) Graph.graph

