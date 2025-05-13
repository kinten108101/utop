(** Prepare a compile-time directive *)
let uu f = f

let (!) = uu

(**
   implement OCamlfind directives.
   references:
   - https://github.com/ocaml/ocamlfind/blob/master/src/findlib/topfind.mli
 *)

(**
loads the package (and if necessary the prerequisites of the package)
  *)
let require : string -> unit =
  fun str ->
  failwith ("You did not run with a postprocessor " ^ str)

(**
   implement OCaml Toplevel directives.
   references:
   - https://ocaml.org/manual/5.3/toplevel.html#s%3Atoplevel-directives
 *)

(**
Read, compile and execute source phrases from the given file. This is textual inclusion: phrases are processed just as if they were typed on standard input. The reading of the file stops at the first error encountered.
  *)
let use : string -> unit =
  fun str ->
  failwith ("You did not run with a postprocessor " ^ str)

(**
Similar to !use but also wrap the code into a top-level module of the same name as capitalized file name without extensions, following semantics of the compiler.
  *)
let mod_use : string -> unit =
  fun str ->
  failwith ("You did not run with a postprocessor " ^ str)

module KM = struct
  let unfold (path : string) : string =
    failwith ("You did not run with a postprocessor " ^ path)
end
