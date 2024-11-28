(* Contains command-line based tools for generating initial coq files and performing QuickChick testing *)

let run_command cmd =
  let inp = Core_unix.open_process_in cmd in
  let r = Core.In_channel.input_lines inp in
  Core.In_channel.close inp;
  r

(* Runs the coq-of-ocaml library to convert the ocaml file into coq file *)
let run_coq_of_ocaml infile outfile =
  run_command (Printf.sprintf "coq-of-ocaml %s -output=%s" infile outfile)
  |> ignore

(* Runs the coqc to perform QuickChick testing *)
let run_coqc dir coqfile =
  run_command (Printf.sprintf "cd %s; coqc -w none %s" dir coqfile)


