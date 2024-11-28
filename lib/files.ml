(* The main part of our ocaml parser which helpes us convert our initial coq code into our final coq script completely *)
open Core
open Poly
open Re

let find_time_elapsed (strings : string list) : float option =
  let starts_with_time_elapsed s = String.is_prefix s ~prefix:"Time Elapsed" in
  let extract_time s =
    match String.split ~on:' ' s with
    | _ :: _ :: time :: _ -> (
        try Some (Float.of_string (String.chop_suffix_exn time ~suffix:"s"))
        with _ -> None)
    | _ -> None
  in
  match List.find ~f:starts_with_time_elapsed strings with
  | Some s -> extract_time s
  | None -> None

let append_to_file (filename : string) (lines : string list) : unit =
  let oc = Out_channel.create ~append:true filename in
  List.iter ~f:(fun line -> Out_channel.output_string oc (line ^ "\n")) lines;
  Out_channel.close oc

let write_to_file (filename : string) (lines : string list) : unit =
  let oc = Out_channel.create filename in
  List.iter ~f:(fun line -> Out_channel.output_string oc (line ^ "\n")) lines;
  Out_channel.close oc

let replace_in_file filename x y =
  let input_channel = In_channel.create filename in
  let lines = In_channel.input_lines input_channel in
  let updated_lines =
    List.map lines ~f:(fun line ->
        line |> String.split ~on:' '
        |> List.map ~f:(fun word -> if String.equal word x then y else word)
        |> String.concat ~sep:" ")
  in
  In_channel.close input_channel;

  let output_channel = Out_channel.create filename in
  List.iter updated_lines ~f:(fun line ->
      Out_channel.output_string output_channel (line ^ "\n"));
  Out_channel.close output_channel

let from_until ~filename ~prefix ~suffix =
  let input_channel = In_channel.create filename in
  let lines = In_channel.input_lines input_channel in
  let rec find_inductive ls =
    match ls with
    | l :: ls ->
        if String.is_prefix l ~prefix then l :: ls else find_inductive ls
    | [] ->
        failwith
          (Printf.sprintf "Could not find prefix `%s`. Error in coq-of-ocaml?"
             prefix)
  in
  let lines = find_inductive lines in
  let rec find_period ls acc =
    match ls with
    | l :: ls ->
        if String.is_suffix l ~suffix then List.rev (l :: acc)
        else find_period ls (l :: acc)
    | [] -> failwith (Printf.sprintf "Could not find suffix `%s`?" suffix)
  in
  find_period lines []

let get_translated_type filename type_name =
  from_until ~filename
    ~prefix:(Printf.sprintf "Inductive %s" type_name)
    ~suffix:"."

let get_translated_function filename function_name =
  from_until ~filename
    ~prefix:(Printf.sprintf "Definition %s" function_name)
    ~suffix:"."
      
(* extracting the parameter type *)
let parse_params params =
  params
  |> String.split ~on:','
  |> List.map ~f:(fun param ->
          match String.split param ~on:':' with
          | [_; typ] -> String.strip typ
          | _ -> failwith "Invalid parameter format.")
  |> String.concat ~sep:" -> "

 (* extracting the parameter type and return type from the function prototype*) 
let extract_signature decl function_name =
  let decl = String.strip decl in
  let prefix = Printf.sprintf "Definition %s" function_name in
  match String.chop_prefix ~prefix decl with
  | None -> Error "Input must start with 'Definition'."
  | Some remaining ->
      let regex = Re.Pcre.re "\\s*\\(([^)]+)\\)\\s*:\\s*(\\w+)\\s*:=" in
      match Re.exec_opt (Re.compile regex) remaining with
      | Some groups ->
          let params = Re.Group.get groups 1 |> String.strip in
          let return_type = Re.Group.get groups 2 |> String.strip in
          (* Printf.printf "Params %s" params;
          Printf.printf "Return %s" return_type; *)
          Ok(function_name, params, return_type)
      | None ->
          Error "Failed to match the expected function signature pattern."

(* Creating our axioms for the properties *)
let axiomatize decl function_name =
  match extract_signature decl function_name with
  | Ok (name, params, return_type) ->
      let param_type = if params = "" then "" else parse_params params in
      if param_type = "" then
        Printf.sprintf "Axiom %s : %s." name return_type
      else
        Printf.sprintf "Axiom %s : %s -> %s." name param_type return_type
  | Error msg -> failwith msg

(* Filtering out the properties which are added and creating the equivalent axioms for them *)
let get_axiomatized_function filename function_name =
  let content = In_channel.read_lines filename in
  let decls =
    content
    |> List.filter ~f:(fun decl -> String.is_prefix decl ~prefix:(Printf.sprintf "Definition %s" function_name))  (* Filter only lines matching the function_name *)
    |> List.map ~f:(fun decl -> axiomatize decl function_name)  (* Apply axiomatization to filtered declarations *)
  in
  decls
