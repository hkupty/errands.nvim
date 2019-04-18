--luacheck: globals vim
local utils = require("errands.utils")
local tasks = require("errands.tasks")
local persistence = require("errands.persistence")
local errands = {}
local defaultconfig = {
  path = "$HOME/.config/errands.nvim/",
  file = "errands.json"
}

local storage = {}

errands.config = utils.deepcopy(defaultconfig)

errands.set_config = function(obj)
  errands.config = utils.merge(defaultconfig, obj)
end


errands.task = function(obj)
  local task = tasks.new(obj)
  table.insert(storage, task)
  errands.sync()
  return task
end

errands.sync = function()
  --TODO Compare-and-swap?
  persistence.write(errands.config.path .. errands.config.file, storage)
end

return errands
