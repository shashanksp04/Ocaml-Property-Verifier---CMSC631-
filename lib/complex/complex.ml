(* Define an integer binary tree *)
type int_tree = 
    | IntLeaf of int
    | IntNode of int_tree * int * int_tree
;;

(* Define a binary tree with boolean values *)
type bool_tree = 
    | BoolLeaf of bool
    | BoolNode of bool_tree * bool * bool_tree
;;

(* Define a function to negate all boolean values in the tree *)
let rec negate_tree (t: bool_tree) = 
    match t with 
    | BoolLeaf(b) -> BoolLeaf(not b)
    | BoolNode(l, v, r) -> BoolNode(negate_tree(l), not v, negate_tree(r))
;;

(* Property test: Negating the tree twice should return the original tree *)
let negate_property_test (t: bool_tree) = 
    t = negate_tree(negate_tree(t))
;;

(* Define a function to check if a tree is uniform (all nodes have the same boolean value) *)
let rec is_uniform (t: bool_tree) = 
    match t with
    | BoolLeaf(_) -> true
    | BoolNode(l, v, r) -> 
        let is_uniform_l = is_uniform l 
        and is_uniform_r = is_uniform r in
        is_uniform_l && is_uniform_r &&
        (match l, r with
         | BoolLeaf(bl), BoolLeaf(br) -> bl = v && br = v
         | BoolNode(_, vl, _), BoolNode(_, vr, _) -> vl = v && vr = v
         | _, _ -> false)
;;


(* Property test: A tree is uniform if and only if its negation is uniform *)
let is_uniform_property_test (t: bool_tree) = 
    is_uniform(t) = is_uniform(negate_tree(t))

(* Define a function to negate all boolean values in the right side of the tree including the root *)
let rec negate_tree_right (t: bool_tree) = 
  match t with 
  | BoolLeaf(b) -> BoolLeaf(not b)  (* Negate the root if it's a leaf *)
  | BoolNode(l, v, r) -> BoolNode(l, not v, negate_tree_right(r))  (* Negate root and recurse on right subtree *)
;;


(* Property test: Double negating the right side of the tree should return the original tree *)
let negate_right_property_test (t: bool_tree) = 
  t = negate_tree_right(negate_tree_right(t))

(* Incorrect Property test *)
let is_uniform_property_test_right (t: bool_tree) = 
    is_uniform(t) = is_uniform(negate_tree_right(t))

let rec sum_tree (t: int_tree) = 
  match t with
  | IntLeaf(n) -> n
  | IntNode(l, v, r) -> sum_tree l + v + sum_tree r
;;

(* Define a property test that combines bool_tree and int_tree *)
(* The property: A uniform bool_tree has a corresponding int_tree where all elements can be summed to a multiple of 2 *)
let uniform_to_sum_property_test (bt: bool_tree) (it: int_tree) =
  if is_uniform bt then
      let sum = sum_tree it in
      sum mod 2 = 0
  else 
      true  (* If the bool_tree is not uniform, the property is vacuously true *)
;;

let sum_swap_property_test (t: int_tree) =
  match t with
  | IntLeaf(_) -> true  (* No subtrees to swap for a leaf *)
  | IntNode(l, v, r) ->
      let swapped_tree = IntNode(r, v, l) in
      sum_tree t = sum_tree swapped_tree
;;