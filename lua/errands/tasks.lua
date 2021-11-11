local utils = require("errands.utils")
local ulid = require("errands.extra.ulid")

local timestamp = function() return vim.fn.strftime("%Y %b %d %X") end
local tasks = {}

tasks.get_tags = function(obj)
end

-- This should have a better API
tasks.meta = {}

tasks.info = function(obj)
  local properties = {
    id = ulid()
  }

  return utils.merge(tasks.meta, properties, obj)
end

tasks.new = function(obj)
    obj.created = timestamp()
    return tasks.info(obj)
end

tasks.start = function(obj)
  obj.started = timestamp()
  return obj
end

tasks.complete = function(obj)
  obj.completed = timestamp()
  return obj
end

tasks.status = function(task)
  for _, i in ipairs{"completed", "started", "created"} do
    if task[i] ~= nil then
      return i
    end
  end
  return "draft"
end

return tasks
