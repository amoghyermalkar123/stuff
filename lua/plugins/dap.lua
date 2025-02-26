-- File: lua/plugins/dap.lua
return {
  -- Disable default debugger configurations from LazyVim
  { "lazyvim.plugins.extras.dap.core", enabled = false },
  { "lazyvim.plugins.extras.dap.nlua", enabled = false },

  -- Debug configuration
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
      },
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Initialize DAP UI
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.5 },
              { id = "breakpoints", size = 0.5 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 1.0 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      -- Initialize virtual text
      require("nvim-dap-virtual-text").setup()

      -- Clear existing adapters and configurations
      dap.adapters = {}
      dap.configurations = {}

      -- Configure codelldb adapter
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.exepath("codelldb"),
          args = { "--port", "${port}" },
        },
      }

      -- Helper function to build test binary
      local function prepare_test_binary()
        -- Get current file path
        local file_path = vim.fn.expand("%:p")

        -- Create a unique test binary name based on the file name
        local test_binary = vim.fn.expand("%:p:r") .. "_test"

        -- Build the test binary with debug info
        local cmd = string.format("zig test %s -femit-bin=%s -O Debug", file_path, test_binary)

        -- Execute the build command
        vim.notify("Building test binary...", vim.log.levels.INFO)
        local handle = io.popen(cmd .. " 2>&1")
        if not handle then
          vim.notify("Failed to execute zig test command", vim.log.levels.ERROR)
          return nil
        end

        local result = handle:read("*a")
        handle:close()

        -- Check if the binary exists
        if vim.fn.filereadable(test_binary) == 1 then
          vim.notify("Test binary built successfully", vim.log.levels.INFO)
          return test_binary
        else
          vim.notify("Failed to build test binary:\n" .. result, vim.log.levels.ERROR)
          return nil
        end
      end

      -- Setup Zig configurations
      dap.configurations.zig = {
        {
          name = "Launch Zig Program",
          type = "codelldb",
          request = "launch",
          program = function()
            local exe_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            local exe_path = vim.fn.getcwd() .. "/zig-out/bin/" .. exe_name
            if vim.fn.filereadable(exe_path) == 1 then
              return exe_path
            else
              vim.notify("No executable found. Build project first with 'zig build'", vim.log.levels.ERROR)
              return ""
            end
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "Debug Zig Test",
          type = "codelldb",
          request = "launch",
          program = function()
            return prepare_test_binary()
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- Debug keymaps
      vim.keymap.set("n", "<Leader>1", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<Leader>2", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<Leader>4", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<Leader>bt", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<Leader>dt", dapui.toggle, { desc = "Debug: Toggle UI" })

      -- Add test-specific keymaps
      vim.keymap.set("n", "<Leader>td", function()
        -- Select the "Debug Zig Test" configuration
        local configurations = dap.configurations.zig or {}
        for _, config in ipairs(configurations) do
          if config.name == "Debug Zig Test" then
            dap.run(config)
            return
          end
        end
        vim.notify("Test debug configuration not found", vim.log.levels.ERROR)
      end, { desc = "Debug: Run Test Under Cursor" })
    end,
  },
}
