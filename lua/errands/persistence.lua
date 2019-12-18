-- luacheck: globals vim
local persistence = {}

persistence.write = function(path, data)
  vim.api.nvim_call_function('writefile', {
    {vim.api.nvim_call_function('json_encode', {data})} -- writes the whole thing into a single line :(
    , vim.api.nvim_call_function('expand', {path})
  })
end

persistence.read = function(path)
  local v = vim.api.nvim_call_function('readfile', {vim.api.nvim_call_function('expand', {path})})
  if next(v) ~= nil then
    return vim.api.nvim_call_function('json_decode', {v})
  else
    return {}
  end
end


return persistence
