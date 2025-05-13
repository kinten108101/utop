#use "u/utop/libtopdirs.ml.d/1-km.ml";;
module KM = struct
	let unfold = unfold
end
;;
#use "u/utop/libeval.ml";;
let tilde_substitute =
  let re =
    let open Re in
    char '~'
    |> compile
  and by = Sys.getenv "HOME"
  in
  function str ->
  Re.replace_string ~all:true re ~by str
;;
let percent_substitute =
  let re =
    let open Re in
    str "%/.."
    |> compile
  in
  fun file str ->
  let by = Filename.dirname file in
  Re.replace_string ~all:true re ~by str
;;

let get_topdirs_require =
  let re =
    let open Re in
    seq
    [ alt
      [ seq
        [ str "Topdirs"
        ; blank |> rep
        ; char '.'
        ; blank |> rep
        ; str "require"
        ; blank |> rep
        ]
      ; seq
        [ char '!'
        ; blank |> rep
        ; str "require"
        ; blank |> rep
        ]
      ]
    ; char '"'
    ; group (notnl |> rep1)
    ; char '"'
    ; opt (str ";;")
    ]
    |> whole_string
    |> compile
  in
  fun str ->
  Re.exec_opt re str
  |> Option.map (
    fun results ->
      let path =
        Re.Group.get results 1 in
      path
  )

let get_topdirs_use =
  let moduse, str_moduse =
    Re.mark (
      let open Re in
      str "mod_use"
    )
  in
  let re =
    let open Re in
    seq
    [ alt
      [ seq
        [ str "Topdirs"
        ; blank |> rep
        ; char '.'
        ; blank |> rep
        ; alt [str "use"; str_moduse]
        ; blank |> rep
        ]
      ; seq
        [ char '!'
        ; blank |> rep
        ; alt [str "use"; str_moduse]
        ; blank |> rep
        ]
      ]
    ; group (notnl |> rep1)
    ]
    |> whole_string
    |> compile
  in
  fun file str ->
  Re.exec_opt re str
  |> Option.map (
    fun results ->
      let expr =
        Re.Group.get results 1 in
      ( eval (Printf.sprintf "_u := %s;;" expr) ) |> ignore;
      let path =
        !_u
        |> tilde_substitute
        |> percent_substitute file
      in
      let modname =
        let barename =
          path
          |> Filename.basename
          |> Filename.remove_extension
        in
        ( match barename with
        | "lib" ->
          let barename =
          path |> Filename.dirname |> Filename.basename |> Filename.remove_extension
          in
          ( match (String.sub barename 0 3) with
          | "lib" -> String.sub barename 3 (String.length barename - 3)
          | _     -> barename
          )
        | _ as barename -> barename
        )
        |> String.capitalize_ascii
      in
      ( path
      , moduse
        |> Re.Mark.test results
      , modname
      )
  )

let get_topdirs_reset_text =
  let re =
    let open Re in
    seq
    [ str "Topdirs"
    ; blank |> rep
    ; char '.'
    ; blank |> rep
    ; str "reset_text"
    ; blank |> rep
    ; str "()"
    ; blank |> rep
    ; opt (str ";;")
    ]
    |> whole_string
    |> compile
  in function str ->
  Re.exec_opt re str
  |> Option.map (
    fun results -> ()
  )

let get_comment_ignore =
  let re =
    let open Re in
    seq
    [ str "(*"
    ; blank |> rep
    ; str "!no-eval"
    ; blank |> rep
    ; str "*)"
    ; notnl |> rep
    ]
    |> whole_string
    |> compile
  in function str ->
  Re.exec_opt re str
  |> Option.map (
    fun results -> ()
  )

let fold_blanks =
  let re =
    let open Re in
    group (blank |> rep1)
    |> compile
  in
  function str ->
  Re.replace re
    ~all:true
    ~f:(fun _ -> " ")
    str
