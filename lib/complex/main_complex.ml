open Setup
open Driver
open Required
open Core
open Example_sample

(* Sample trees for testing *)
let sample_bool_tree =
  BoolNode (
    BoolLeaf true,
    false,
    BoolNode (
      BoolLeaf false,
      true,
      BoolLeaf true
    )
  )

let sample_int_tree =
  IntNode (
    IntLeaf 3,
    5,
    IntNode (
      IntLeaf 7,
      10,
      IntLeaf 2
    )
  )

let () =
  (* Setup the required environment *)
  setup_add_library "zarith";
  setup_add_library "core";  (* Add core for the property tests *)

  (* Add boolean tree tests *)
  setup_add_type "BoolTreeModule" "bool_tree" ["BoolLeaf"; "BoolNode"];
  setup_add_function "BoolTreeModule" "negate_tree";
  setup_add_function "BoolTreeModule" "is_uniform";
  setup_add_function "BoolTreeModule" "negate_tree_right";

  (* Add integer tree tests *)
  setup_add_type "IntTreeModule" "int_tree" ["IntLeaf"; "IntNode"];
  setup_add_function "IntTreeModule" "sum_tree";
  
  (* Define the Coq file to extract OCaml code and setup properties *)
  setup := {
    !setup with
    ml_file = "example_sample.ml";    (* Name of this OCaml file *)
    temp_dir = "../_build";        (* Temporary directory for intermediate files *)
    target = "uniform_to_sum_property_test";  (* Set target property test *)
  };

  (* Run the property tests *)
  let result1 = negate_property_test sample_bool_tree in
  let result2 = is_uniform_property_test sample_bool_tree in
  let result3 = negate_right_property_test sample_bool_tree in
  let result4 = is_uniform_property_test_right sample_bool_tree in
  let result5 = uniform_to_sum_property_test sample_bool_tree sample_int_tree in
  let result6 = sum_swap_property_test sample_int_tree in

  (* Output the results of the tests *)
  Printf.printf "Negate property test result: %b\n" result1;
  Printf.printf "Is uniform property test result: %b\n" result2;
  Printf.printf "Negate right property test result: %b\n" result3;
  Printf.printf "Uniform property test right result: %b\n" result4;
  Printf.printf "Uniform to sum property test result: %b\n" result5;
  Printf.printf "Sum swap property test result: %b\n" result6;

  (* Run QuickChick testing *)
  quickchick ()
