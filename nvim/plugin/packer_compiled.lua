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
local package_path_str = "/home/lee/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/lee/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/lee/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/lee/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/lee/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
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
  Colorizer = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lee/.local/share/nvim/site/pack/packer/opt/Colorizer"
  },
  ["barbar.nvim"] = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/barbar.nvim"
  },
  ["deoplete-phpactor"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lee/.local/share/nvim/site/pack/packer/opt/deoplete-phpactor"
  },
  ["deoplete.nvim"] = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/deoplete.nvim"
  },
  ["editorconfig-vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lee/.local/share/nvim/site/pack/packer/opt/editorconfig-vim"
  },
  ["emmet-vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lee/.local/share/nvim/site/pack/packer/opt/emmet-vim"
  },
  fzf = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\1\0026\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\1\2/\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\20plugins/lualine\frequire\0" },
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  neomake = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/neomake"
  },
  nerdcommenter = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/nerdcommenter"
  },
  ["nightfox.nvim"] = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/nightfox.nvim"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins/nvim-tree\frequire\0" },
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["php.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lee/.local/share/nvim/site/pack/packer/opt/php.vim"
  },
  phpactor = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lee/.local/share/nvim/site/pack/packer/opt/phpactor"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  tagbar = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/lee/.local/share/nvim/site/pack/packer/opt/tagbar"
  },
  ["tmuxline.vim"] = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/tmuxline.vim"
  },
  ["vim-blade"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/lee/.local/share/nvim/site/pack/packer/opt/vim-blade"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/home/lee/.local/share/nvim/site/pack/packer/start/vim-rhubarb"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\1\0026\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\1\2/\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\20plugins/lualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins/nvim-tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType js ++once lua require("packer.load")({'editorconfig-vim'}, { ft = "js" }, _G.packer_plugins)]]
vim.cmd [[au FileType css ++once lua require("packer.load")({'editorconfig-vim', 'Colorizer'}, { ft = "css" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'emmet-vim'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType php ++once lua require("packer.load")({'deoplete-phpactor', 'editorconfig-vim', 'tagbar', 'phpactor', 'emmet-vim', 'php.vim'}, { ft = "php" }, _G.packer_plugins)]]
vim.cmd [[au FileType scss ++once lua require("packer.load")({'editorconfig-vim', 'Colorizer'}, { ft = "scss" }, _G.packer_plugins)]]
vim.cmd [[au FileType blade ++once lua require("packer.load")({'editorconfig-vim', 'vim-blade', 'emmet-vim'}, { ft = "blade" }, _G.packer_plugins)]]
vim.cmd [[au FileType ts ++once lua require("packer.load")({'editorconfig-vim'}, { ft = "ts" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/lee/.local/share/nvim/site/pack/packer/opt/vim-blade/ftdetect/blade.vim]], true)
vim.cmd [[source /home/lee/.local/share/nvim/site/pack/packer/opt/vim-blade/ftdetect/blade.vim]]
time([[Sourcing ftdetect script at: /home/lee/.local/share/nvim/site/pack/packer/opt/vim-blade/ftdetect/blade.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
