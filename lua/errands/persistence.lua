-- luacheck: globals vim
local persistence = {}

persistence.write = function(path, data)
  vim.api.nvim_call_function('writefile', {
    {vim.api.nvim_call_function('json_encode', {data})} -- writes the whole thing into a single line :(
    , path})
end

persistence.read = function(path)
  vim.api.nvim_call_function('json_decode', {
      vim.api.nvim_call_function('readfile', {path})
  })
end


return persistence
