(* This file helps us in creating our final coq file by using Functions defined in files and combining their result*)
open Core
open Files

(* the holder file for our initial coq-code, needs to exist before hand but can be empty *)
let initial_coqfile = "Example.v"
(* the final coq code is stored in this file, it doesn't need to be created. Generated when the code is run *)
let final_coqfile = "Example_withQuickchick.v"
let substitutions = [("int", "nat")]

let process_extractions (info : Required.t) =
  List.concat_map info.extractions ~f:Required.Extractions.lines_of_t

(* Translating the non-convertible ocaml code into coq manually *)
let process_translations filename (info : Required.t) =
  List.concat_map (List.rev info.extractions) ~f:(fun ex ->
      match ex with
      | Ty { type_name; _ } -> Files.get_translated_type filename type_name
      | Func { function_name; _ } -> Files.get_axiomatized_function filename function_name
      | File _ -> [])

(* generating the dune file - not used anywhere though! *)
let generate_dune (info : Required.t) =
  [
    Printf.sprintf
      "(executable\n\
      \ (libraries %s zarith))\n\n\
       (env\n\
      \ (dev\n\
      \  (flags\n\
      \   (:standard -w -66-32-33-39-34-37))))\n"
      (String.concat ~sep:" " info.libraries);
  ]

(* Creating our final coq file script *)
let quickchick_arg (info : Required.t) =
  let raw_coqfile = Filename.concat info.temp_dir initial_coqfile in
  let post_coqfile = Filename.concat info.temp_dir final_coqfile in
  let dunefile = Filename.concat info.temp_dir "dune" in
  Cmd.run_coq_of_ocaml info.ml_file raw_coqfile;
  List.iter
    ~f:(Tuple2.uncurry (Files.replace_in_file raw_coqfile))
    substitutions;
  [
    "From QuickChick Require Import QuickChick.";
    "QCInclude \"../lib/example.ml\".";
    "Require Import ZArith.";
    "Definition int := Z.";
    "";
  ]
  @ process_translations raw_coqfile info
  @ process_extractions info
  @ [Printf.sprintf "QuickChick %s." info.target]
  |> Files.write_to_file post_coqfile;
  generate_dune info |> Files.write_to_file dunefile;
  let _ = Cmd.run_coqc info.temp_dir post_coqfile in
  ()

let quickchick () = quickchick_arg !Setup.setup
