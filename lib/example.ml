(* Our sample ocaml file on which we perform QuickChick testing *)

type tree = 
    Leaf of int
    | Node of tree * int * tree
;;

let rec mirror_tree (t: tree) = 
    match t with 
    | Leaf(a) -> Leaf(a)
    | Node(l,v,r) -> Node(mirror_tree(r), v, mirror_tree(l))
;;

let mirror_property_test (t:tree) = 
    t = mirror_tree(mirror_tree(t))
;;

let is_symmetric (t:tree) = 
    t = mirror_tree(t)
;;