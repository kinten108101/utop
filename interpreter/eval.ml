let _u = ref ""

let eval code =
  let as_buf = Lexing.from_string code in
  let parsed = !Toploop.parse_toplevel_phrase as_buf in
  Toploop.execute_phrase true Format.std_formatter parsed
