return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "leoluz/nvim-dap-go"
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        local dap_go = require("dap-go")

        dap_go.setup()
        dapui.setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end

        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end

        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end

        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        local keymap = vim.keymap
        keymap.set("n", "<leader>dt", dap.toggle_breakpoint, {})
        keymap.set("n", "<leader>dc", dap.continue, {})
    end
}
