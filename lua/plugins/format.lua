local function has_config(ctx, markers)
  local found = vim.fs.find(markers, { upward = true, path = ctx.filename })[1]
  return found ~= nil
end

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        javascript = { "prettier", "eslint", "deno_fmt" },
        typescript = { "prettier", "eslint", "deno_fmt" },
        javascriptreact = { "prettier", "eslint", "deno_fmt" },
        typescriptreact = { "prettier", "eslint", "deno_fmt" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        astro = { "prettier" },
      },
      formatters = {
        shfmt = {
          args = { "-i", "2", "-ln", "bash", "-bn", "-sr" },
        },
        prettier = {
          require_cwd = function(ctx)
            return has_config(ctx, {
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.json5",
              ".prettierrc.yml",
              ".prettierrc.yaml",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              ".prettierrc.ts",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
              "prettier.config.ts",
            })
          end,
        },
        eslint = {
          require_cwd = function(ctx)
            return has_config(ctx, {
              ".eslintrc",
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.json",
              ".eslintrc.yml",
              ".eslintrc.yaml",
              "eslint.config.js",
              "eslint.config.mjs",
              "eslint.config.cjs",
              "eslint.config.ts",
            })
          end,
        },
        deno_fmt = {
          command = "deno",
          args = { "fmt", "--ext", "$FILENAME" },
          require_cwd = function(ctx)
            return has_config(ctx, { "deno.json", "deno.jsonc" })
          end,
        },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }
    end,
  },
}
