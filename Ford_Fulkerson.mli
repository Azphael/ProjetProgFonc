(** Alg Ford Fulkerson **)

(** Mise en forme d'un graphe pour prise en compte des variations de flux sur les arcs **)
(** formate_graph graph --> renvoi un graphe avec le label modifié et initialisé en (flux_max_acceptable, 0)  **)
val formate_graph: 'a Graph.graph -> ('a * int) Graph.graph


(** Recherche le chemin dans un graphe entre un noeud initial et une cible finale, et renvoi **)
(** search_path graph path localisation target --> renvoi un graphe de chemin **)
val search_path: ('a * 'a) Graph.graph -> ('a * 'a) Graph.graph -> Graph.id -> Graph.id -> ('a * 'a) Graph.graph


(** Trouve le chemin dans un graphe entre une "source" et un "puit" **)
(** find_path graph source target --> renvoi un graphe de chemin **)   
val find_path: ('a * 'a) Graph.graph -> Graph.id -> Graph.id -> ('a * 'a) Graph.graph


(** Valeur minimale de flux pouvant passer dans le chemin trouvé **)
(** max_flux_passant path --> renvoi la valeur de flux maximal pouvant circuler dans le graphe de chemin **)
val max_flux_passant: (int * int) Graph.graph -> int


(** Mise à jour du graph d'écart lié : parcours de comparaison sur le graphe **)
(** update_graph graph path maxflux --> renvoi un graphe d'écart **)
val update_graph: (int * int) Graph.graph -> 'a Graph.graph -> int -> (int * int) Graph.graph


(** Mise à jour alternative du graph d'écart lié : parcours de comparaison sur le path **)	
(** update_graph graph path maxflux --> renvoi un graphe d'écart **)
val alt_update_graph: (int * int) Graph.graph -> (int * int) Graph.graph -> int -> (int * int) Graph.graph


(** Fonction renvoyant un graphe sans les arcs retour du graphe d'écart  **)
(** graphe_sexy graph_origine graph_fin --> transforme un graphe d'écart en graphe normal **)
val graphe_sexy:  ('a * 'b) Graph.graph -> ('a * 'b) Graph.graph -> ('a * 'b) Graph.graph


(** Fonction de résolution de graphe selon la méthode Ford-Fulkerson **)
(** resolve_ford_fulkerson graph source puit --> renvoi un graphe solution **)
val resolve_ford_fulkerson: (int * int) Graph.graph -> Graph.id -> Graph.id -> (int * int) Graph.graph


(** Fonction user friendly renvoyant un graphe solution selon la méthode Ford-Fulkerson **)
(** ford_fulkerson graph source puit --> renvoi un graphe solution à partir d'un graphe avec label simple **)
val ford_fulkerson: int Graph.graph -> Graph.id -> Graph.id -> (int * int) Graph.graph


(** Fonction d'export des graphes solution de l'algorithme Ford-Fulkerson **)			
(** export file graph source target --> permet d'exporter pour affichage un graphe solution **)
val export: string -> (int * int) Graph.graph -> string -> string -> unit

