open Setup
open Driver
open Required
open Core
open Example_sample

let () =
  (* Setup the required environment *)
  setup_add_library "zarith";
  setup_add_library "core";  (* Add core for the property tests *)

  (* Add boolean tree tests *)
  setup_add_type "Example" "bool_tree" ["BoolLeaf"; "BoolNode"];
  setup_add_function "Example" "negate_tree";
  setup_add_function "Example" "is_uniform";
  setup_add_function "Example" "negate_tree_right";

  (* Add integer tree tests *)
  setup_add_type "Example" "int_tree" ["IntLeaf"; "IntNode"];
  setup_add_function "Example" "sum_tree";
  
  (* Define the Coq file to extract OCaml code and setup properties *)
  setup := {
    !setup with
    ml_file = "example.ml"; (* Name of the sample OCaml file *)
    temp_dir = "../_build";     (* Temporary directory for intermediate files *)
    target = "is_uniform"; (* Set target property test *)
  };

  (* Run QuickChick testing *)
  quickchick ()
