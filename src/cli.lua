local cli = {}

--- Reads through argv, returning program flags and the command, `nil` if there isn't one.
--- @return table
function cli.readargv()
  local flags = {
    verbose = false
  }
  local cmd

  for i=1, #arg do
    local a = arg[i]
    local asub = a:sub(1, 2)
    if asub == "--" then
      local flagnoprefix = a:sub(3)

      if flags[flagnoprefix] ~= nil then flags[flagnoprefix] = true
      else print(("Unknown flag: %s"):format(a)); os.exit(1)
      end
    end
  end

  local last = arg[#arg]
  if last:sub(1, 2) ~= "--" then cmd = last else cmd = nil end

  return {flags, cmd}
end

return cli
