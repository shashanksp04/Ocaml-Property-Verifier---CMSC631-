Require Import CoqOfOCaml.CoqOfOCaml.
Require Import CoqOfOCaml.Settings.

Inductive tree : Set :=
| Leaf : nat -> tree
| Node : tree -> nat -> tree -> tree.

Fixpoint mirror_tree (t : tree) : tree :=
  match t with
  | Leaf a => Leaf a
  | Node l v r => Node (mirror_tree r) v (mirror_tree l)
  end.

Definition mirror_property_test (t : tree) : bool :=
  equiv_decb t (mirror_tree (mirror_tree t)).

Definition is_symmetric (t : tree) : bool := equiv_decb t (mirror_tree t).
