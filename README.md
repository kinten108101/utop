# UTop

The current OCaml LSP server implementation, `ocamllsp`, does not support the OCaml scripting environment. For example, writing any toplevel directives will have `ocamllsp` shout syntax error, and the rest of the file is skipped.

This is a version of the UTop interpreter that has LSP support.

---

This is a system of packages, editor plugins, interpreters,... It introduces some fundamental changes to your code:

- Well-typed directives: instead of writing `#use`, we write `!use`. Here, the exclamation mark is an overloaded operator made possible by OCaml's metaprogramming system; the `use` part is shorthand for `Topdirs.use` which is an opened function from an OPAM package this system provides provide.
- External module signature... auto-included in text: code as data.

To install this system, you must install five components:
1. The custom interpreter
2. The custom LSP server setup
3. The custom types for LSP
4. The custom syntax highlighting
5. The global OPAM switch
6. Some manual maintenance effort

## 1. Interpreter

The folder `interpreter` houses the interpreter. The interpreter transpiles our custom, well-typed directive syntax to original toplevel syntax.

1. Install with Meson

## 2. LSP Server

1. Install `dot-merlin-reader` with OPAM
2. (Neovim) Run the OCaml language server with a flag to enable reading `.merlin` configuration file. `ocamllsp --fallback-read-dot-merlin`
3. Create a `.merlin` file in your home directory

## 3. LSP Types

The folder `types` houses the abstract functions.

1. Install the folder with OPAM
2. Edit `.merlin` to include `topdirs`
3. If necessary, restart LSP servers

That's it! Now in your code, open the `Topdirs` module.

## 4. Syntax Highlighting

WIP

> See `doc/HIGHLIGHTING_PLACEHOLDER.md` for guide on a placeholder implementation.

## 5. Global OPAM Switch

Corresponds to a global `.merlin` file at home directory is a global switch for general-purpose scripting.

1. Create a global switch. `opam switch create ocaml-base-compiler scripts`
2. In your shell dotfile, activate the global switch. `eval "$(opam env --switch=scripts --set-switch)"`

## 6. Maintenance

Corresponds to a global `.merlin` file at home directory and the aforementioned global switch is some extra effort to synchronize the merlin file with the switch. The `.merlin` file has a `PKG` directive that lists usable OPAM packages. You must manually edit it to include the packages you have installed in the switch. This also acts as a white list.

