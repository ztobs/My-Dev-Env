return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  lazy = false,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
      },
      move = {
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    local function select_keymaps(captures)
      for lhs, capture in pairs(captures) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(capture.query, "textobjects")
        end, { desc = capture.desc })
      end
    end

    select_keymaps({
      -- You can use the capture groups defined in textobjects.scm
      ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
      ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
      ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
      ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

      -- works for javascript/typescript files (custom capture in after/queries/ecma/textobjects.scm)
      ["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
      ["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
      ["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
      ["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },

      ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
      ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

      ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
      ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

      ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
      ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

      ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
      ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

      ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
      ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

      ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
      ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
    })

    -- swap
    vim.keymap.set("n", "<leader>na", function()
      swap.swap_next("@parameter.inner", "textobjects")
    end, { desc = "Swap parameter/argument with next" })
    vim.keymap.set("n", "<leader>n:", function()
      swap.swap_next("@property.outer", "textobjects")
    end, { desc = "Swap object property with next" })
    vim.keymap.set("n", "<leader>nm", function()
      swap.swap_next("@function.outer", "textobjects")
    end, { desc = "Swap function with next" })

    vim.keymap.set("n", "<leader>pa", function()
      swap.swap_previous("@parameter.inner", "textobjects")
    end, { desc = "Swap parameter/argument with prev" })
    vim.keymap.set("n", "<leader>p:", function()
      swap.swap_previous("@property.outer", "textobjects")
    end, { desc = "Swap object property with prev" })
    vim.keymap.set("n", "<leader>pm", function()
      swap.swap_previous("@function.outer", "textobjects")
    end, { desc = "Swap function with previous" })

    -- move
    local move_keymaps = {
      goto_next_start = {
        ["]f"] = { query = "@call.outer", desc = "Next function call start" },
        ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
        ["]c"] = { query = "@class.outer", desc = "Next class start" },
        ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
        ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]F"] = { query = "@call.outer", desc = "Next function call end" },
        ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
        ["]C"] = { query = "@class.outer", desc = "Next class end" },
        ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
        ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
      },
      goto_previous_start = {
        ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
        ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
        ["[c"] = { query = "@class.outer", desc = "Prev class start" },
        ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
        ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
      },
      goto_previous_end = {
        ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
        ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
        ["[C"] = { query = "@class.outer", desc = "Prev class end" },
        ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
        ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
      },
    }

    for method, mappings in pairs(move_keymaps) do
      for lhs, capture in pairs(mappings) do
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          move[method](capture.query, capture.query_group or "textobjects")
        end, { desc = capture.desc })
      end
    end

    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

    -- vim way: ; goes to the direction you were moving.
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
