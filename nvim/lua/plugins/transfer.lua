return {
  "git@github.com:coffebar/transfer.nvim.git",
  config = function()
    local transfer = require("transfer")
    transfer.setup({
      configPath = vim.fn.stdpath("config") .. "/lua/transfer_config.lua",
    })

    -- Commands based on the actual module
    vim.api.nvim_create_user_command("TransferInit", function()
      transfer.init()
    end, {})

    vim.api.nvim_create_user_command("TransferDir", function()
      transfer.dir()
    end, {})

    vim.api.nvim_create_user_command("TransferStart", function()
      transfer.transfer()
    end, {})
  end,
  cmd = { "TransferInit", "TransferStart", "TransferDir" },
}
