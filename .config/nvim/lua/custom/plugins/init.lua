-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    'github/copilot.vim',
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        dependencies = { 'github/copilot.vim' },
        config = function()
            require('CopilotChat').setup()
        end,
        cmd = 'CopilotChat',
    },
}
