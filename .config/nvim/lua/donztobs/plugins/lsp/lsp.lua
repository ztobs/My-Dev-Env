return {
  "hrsh7th/cmp-nvim-lsp",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", opts = {} },
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- Get Vue language server path for TypeScript plugin integration
    local vue_language_server_path = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

    -- Configure vtsls (TypeScript server with Vue plugin support)
    -- Must modify the config BEFORE calling vim.lsp.enable()
    local vtsls_config = vim.lsp.config.vtsls or {}
    vtsls_config.filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }
    vtsls_config.settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_language_server_path,
              languages = { "vue" },
              configNamespace = "typescript",
            },
          },
        },
      },
    }
    vtsls_config.capabilities = capabilities
    vim.lsp.config.vtsls = vtsls_config

    -- Configure Vue language server (works with vtsls)
    vim.lsp.config.vue_ls = {
      default_config = {
        filetypes = { "vue" },
      },
      on_init = function(client)
        -- Forward TypeScript requests from vue_ls to vtsls or ts_ls
        client.handlers['tsserver/request'] = function(_, result, context)
          local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })
          local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
          local clients = {}

          vim.list_extend(clients, ts_clients)
          vim.list_extend(clients, vtsls_clients)

          if #clients == 0 then
            vim.notify('Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
            return
          end
          local ts_client = clients[1]

          local param = unpack(result)
          local id, command, payload = unpack(param)
          ts_client:exec_cmd({
            title = 'vue_request_forward',
            command = 'typescript.tsserverRequest',
            arguments = {
              command,
              payload,
            },
          }, { bufnr = context.bufnr }, function(_, r)
              local response = r and r.body
              local response_data = { { id, response } }
              client:notify('tsserver/response', response_data)
            end)
        end
      end,
      capabilities = capabilities,
    }

    -- Configure intelephense for PHP/WordPress
    vim.lsp.config.intelephense = {
      default_config = {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php" },
        root_markers = { "composer.json", ".git", "wp-config.php" },
      },
      settings = {
        intelephense = {
          stubs = {
            "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "ctype", "curl", "date",
            "dba", "dom", "enchant", "exif", "FFI", "fileinfo", "filter", "fpm", "ftp", "gd",
            "gettext", "gmp", "hash", "iconv", "imap", "intl", "json", "ldap", "libxml",
            "mbstring", "meta", "mysqli", "oci8", "odbc", "openssl", "pcntl", "pcre", "PDO",
            "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix",
            "pspell", "readline", "Reflection", "session", "shmop", "SimpleXML", "snmp", "soap",
            "sockets", "sodium", "SPL", "sqlite3", "standard", "superglobals", "sysvmsg",
            "sysvsem", "sysvshm", "tidy", "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter",
            "xsl", "Zend OPcache", "zip", "zlib",
            "wordpress", "woocommerce", "acf-pro", "wordpress-globals", "wp-cli", "genesis", "polylang",
          },
          files = {
            maxSize = 5000000,
            associations = { "*.php", "*.phtml" },
            exclude = {
              "**/.git/**", "**/.svn/**", "**/.hg/**", "**/CVS/**", "**/.DS_Store/**",
              "**/node_modules/**", "**/bower_components/**", "**/vendor/**/{Tests,tests}/**",
              "**/.history/**", "**/vendor/**/vendor/**",
            },
          },
          format = {
            enable = true,
          },
        },
      },
      capabilities = capabilities,
    }

    -- Enable the LSP servers (required for vim.lsp.config API)
    -- IMPORTANT: vtsls must be enabled first so vue_ls can find it
    vim.lsp.enable("vtsls")
    vim.lsp.enable("vue_ls")
    vim.lsp.enable("intelephense")
  end,
}
