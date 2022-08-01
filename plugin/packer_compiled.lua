-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/aleksandr.kirillov/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/aleksandr.kirillov/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/aleksandr.kirillov/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/aleksandr.kirillov/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/aleksandr.kirillov/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["command-center.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/command-center.nvim",
    url = "https://github.com/gfeiyou/command-center.nvim"
  },
  diffconflicts = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/diffconflicts",
    url = "https://github.com/whiteinge/diffconflicts"
  },
  ["dressing.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["easypick.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/easypick.nvim",
    url = "https://github.com/axkirillov/easypick.nvim"
  },
  fzf = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf-lua"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/fzf-lua",
    url = "https://github.com/ibhagwan/fzf-lua"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["gh.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/gh.nvim",
    url = "https://github.com/ldelossa/gh.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  gruvbox = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/gruvbox",
    url = "https://github.com/morhetz/gruvbox"
  },
  ["litee.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/litee.nvim",
    url = "https://github.com/ldelossa/litee.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["neo-tree.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["nvim-bqf"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-go"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/nvim-dap-go",
    url = "https://github.com/leoluz/nvim-dap-go"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["octo.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/octo.nvim",
    url = "https://github.com/pwntester/octo.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  phpactor = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/opt/phpactor",
    url = "https://github.com/phpactor/phpactor"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["splitjoin.vim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/splitjoin.vim",
    url = "https://github.com/AndrewRadev/splitjoin.vim"
  },
  ["telescope-changed-files"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/telescope-changed-files",
    url = "https://github.com/axkirillov/telescope-changed-files"
  },
  ["telescope-conflicts"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/telescope-conflicts",
    url = "https://github.com/axkirillov/telescope-conflicts"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/ultisnips",
    url = "https://github.com/SirVer/ultisnips"
  },
  ["vim-easycomplete"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/vim-easycomplete",
    url = "https://github.com/jayli/vim-easycomplete"
  },
  ["vim-fish"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/vim-fish",
    url = "https://github.com/dag/vim-fish"
  },
  ["vim-floaterm"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/vim-floaterm",
    url = "https://github.com/voldikss/vim-floaterm"
  },
  ["vim-php-refactoring-toolbox"] = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/vim-php-refactoring-toolbox",
    url = "https://github.com/adoy/vim-php-refactoring-toolbox"
  },
  vimspector = {
    loaded = true,
    path = "/Users/aleksandr.kirillov/.local/share/nvim/site/pack/packer/start/vimspector",
    url = "https://github.com/puremourning/vimspector"
  }
}

time([[Defining packer_plugins]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType php ++once lua require("packer.load")({'phpactor'}, { ft = "php" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
