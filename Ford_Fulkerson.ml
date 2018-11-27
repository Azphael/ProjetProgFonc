open Graph


(** Algo Ford Fulkerson **)
(** let noeuds_dest = out_arcs graph localisation in	**)	
 
let rec search_path graph acu localisation target noeuds_dest = 
	if localisation = target then acu
		else let arcs_potentiel = List.filter ( fun (x,y) -> (y > 0) ) noeuds_dest in
				begin match arcs_potentiel with
					| [] -> []
					| (x, y)::tl -> 
						begin match search_path graph ((localisation, (x, y))::acu) x target (out_arcs graph x) with
							| [] -> search_path graph acu localisation target tl
							| acu -> acu
						end
				end
					
					
(** let 3 = search_path **)