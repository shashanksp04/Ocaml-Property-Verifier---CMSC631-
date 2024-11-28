(* Main OCaml file: mainFile.ml *)

(* Open required modules *)
open Setup
open Core
open QCheck
open Driver
open Required
open Example  (* Import the Example_sample module *)

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
    ml_file = "example.ml"; (* Name of the sample OCaml file *)
    temp_dir = "../_build";     (* Temporary directory for intermediate files *)
    target = "mirror_property_test"; (* Set target property test *)
  };

 
  (* Run QuickChick testing *)
  quickchick ()
