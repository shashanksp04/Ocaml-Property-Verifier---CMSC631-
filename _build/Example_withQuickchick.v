From QuickChick Require Import QuickChick.
QCInclude "../lib/example.ml".
Require Import ZArith.
Definition int := Z.

Inductive tree : Set :=
| Leaf : nat -> tree
| Node : tree -> nat -> tree -> tree.
Axiom mirror_property_test : tree -> bool.
Axiom is_symmetric : tree -> bool.
Extract Constant is_symmetric => "Example.is_symmetric".
Extract Constant mirror_property_test => "Example.mirror_property_test".
Derive (Show, Arbitrary) for tree.
Extract Inductive tree => "Example.tree"
  [
    "Example.Leaf"
    "Example.Node"
  ].
QuickChick mirror_property_test.
