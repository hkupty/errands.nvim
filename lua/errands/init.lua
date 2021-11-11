--luacheck: globals vim
local utils = require("errands.utils")
local tasks = require("errands.tasks")
local persistence = require("errands.persistence")
local errands = {
  filters = {}
}
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
  errands.upsert(task)
  return task
end

errands.upsert = function(obj)
  errands.read()
  storage[obj.id] = obj
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

errands.filters.open = function(errs)
  return utils.filterkv(function(_, dt) return dt.completed == nil end, errs)
end

errands.filters.completed = function(errs)
  return utils.filterkv(function(_, dt) return dt.completed ~= nil end, errs)
end

return errands
