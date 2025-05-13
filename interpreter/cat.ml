Topfind.load_deeply [ "re"; "compiler-libs" ]
;;
#use "u/utop/libtopdirs.ml"
;;

let rec perform acc filein filepath = try (
  let line = input_line filein in
  let newacc =
    match line |> get_topdirs_use filepath with
    | None ->
      (line :: acc)
      |> (fun lineacc ->
        match line |> get_topdirs_require with
        | None -> lineacc
        | Some (path) -> (Printf.sprintf "Topfind.load_deeply [\"%s\"];;" path) :: (List.tl lineacc) )
      |> (fun lineacc ->
        match line |> get_comment_ignore with
        | None -> lineacc
        | Some () -> "" :: (List.tl lineacc) )
      |> (fun lineacc ->
        match line |> get_topdirs_reset_text with
        | None    -> lineacc
        | Some () -> []
      )
    | Some (path, ismoduse, modname) ->
      ( let anotherfile = open_in path
        and postprocess = match ismoduse with
          | false -> fun x -> x
          | true ->
            fun x -> ["end"] @ x @ ["module " ^ modname ^ " = struct"]
        in
        let x = (postprocess (perform [] anotherfile path) ) @ acc in
        close_in anotherfile; x )
  in
  perform newacc filein filepath
) with End_of_file -> acc

let () =
	let filepath = Sys.argv.(1) in
  ( let file = open_in filepath in
    let x = perform [] file filepath in
    close_in file; x )
  |> List.rev
  |> List.map (fun x -> print_endline x; x)
  |> ignore
