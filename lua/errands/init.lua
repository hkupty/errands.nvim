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

errands.read = function()
  storage = persistence.read(errands.config.path .. errands.config.file)
end

errands.task = function(obj)
  local task = tasks.new(obj)
  errands.read()
  table.insert(storage, task)
  errands.sync()
  return task
end

errands.update = function(obj)
  errands.read()
  table.storage[obj.id] = obj.update(table.storage[obj.id])
  errands.sync()
end

errands.tasks = function(xform)
  local view = xform or function(i) return i end
  return view(storage)
end

errands.sync = function()
  --TODO Compare-and-swap?
  persistence.write(errands.config.path .. errands.config.file, storage)
end

return errands
