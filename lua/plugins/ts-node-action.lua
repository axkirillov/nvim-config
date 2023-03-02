local padding = {
  [","] = "%s ",
--  ["{"] = "%s ",
--  ["}"] = " %s",
--  ["="] = " %s ",
--  ["or"] = " %s ",
--  ["and"] = " %s ",
--  ["+"] = " %s ",
--  ["-"] = " %s ",
--  ["*"] = " %s ",
--  ["/"] = " %s ",
}

require("ts-node-action").setup({
    php = {
        ["arguments"] = require("ts-node-action.actions.toggle_multiline")(padding)
    },
})
vim.keymap.set({ "n" }, "<leader>a", require("ts-node-action").node_action, { desc = "Trigger Node Action" })
