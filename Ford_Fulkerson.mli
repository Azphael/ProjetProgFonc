(** Alg Ford Fulkerson **)
val search_path: int Graph.graph ->
           (Graph.id * (Graph.id * int)) list ->
           Graph.id ->
           Graph.id ->
           int Graph.out_arcs -> (Graph.id * (Graph.id * int)) list