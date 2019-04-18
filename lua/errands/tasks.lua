local tasks = {}

tasks.new = function(obj)
  return {
    title = obj.title,
    status = "open"
  }
end

tasks.start = function(obj)
  obj.status = "started"
  return obj
end

tasks.complete = function(obj)
  obj.status = "completed"
  return obj
end

return tasks
