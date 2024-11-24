(* Main OCaml file: mainFile.ml *)

(* Open required modules *)
open Setup
open Core
open QCheck
open Driver
open Required
open Example  (* Import the Example_sample module *)

(* Sample trees for testing *)
let sample_tree =
  Node (
    Node (
      Leaf 1,
      2,
      Leaf 3
    ),
    4,
    Node (
      Leaf 5,
      6,
      Leaf 7
    )
  )

let () =
  (* Setup the environment *)
  setup_add_library "zarith";
  setup_add_library "core";  (* Add core for the property tests *)

  (* Add tree tests *)
  setup_add_type "Example" "tree" ["Leaf"; "Node"];
  setup_add_function "Example" "mirror_property_test";
  setup_add_function "Example" "is_symmetric";

  (* Define Coq file to extract OCaml code *)
  setup := {
    !setup with
    ml_file = "example.ml"; (* Name of this OCaml file *)
    temp_dir = "../_build";     (* Temporary directory for intermediate files *)
    target = "mirror_property_test"; (* Set target property test *)
  };

  (* Run the property tests *)
  let result1 = mirror_property_test sample_tree in
  let result2 = is_symmetric sample_tree in

  (* Output the results of the tests *)
  Printf.printf "Mirror property test result: %b\n" result1;
  Printf.printf "Is symmetric property test result: %b\n" result2;

  (* Run QuickChick testing *)
  quickchick ()
