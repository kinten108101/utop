A treesitter grammar is planned, it will extend the exisiting OCaml treesitter with additional semantics.

Before this, we can use `younger-1/paint.nvim` to add overlaying highlights with regex pattern.

```lua
use {
    "younger-1/paint.nvim",
    branch = "feat/add-priority-option",
    config = function() 
        require"paint".setup {
            highlights = {
                {
                    filter = {
		                filetype = "ocaml"
	                },
	                pattern = "^%s*(%!%s*[%w_0-9]+)%s*.*",
	                hl = "@keyword.directive.ocaml",
	                priority = 999
                }
            }
        }
    end
}
```
