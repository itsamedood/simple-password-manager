local datamngr = {}

--- Sorts parents and passwords into a table.
---@return table
local function sortpws()
  local pws = {}
  local dotpws = io.open(".pws", 'r')
  if dotpws == nil then print("Failed to open `.pws`."); os.exit(1) end

  local content = dotpws:read('a') --- @type string
  local colon = false
  local parent = ''
  local password = ''

  for i=1, #content do
    local char = content:sub(i, i)

    if char == nil then -- Do nothing.
    elseif char == "\n" then
      pws[parent] = password
      colon = false
      parent = ''
      password = ''

    elseif char == ":" then
      if not colon then colon = true end
    else
      if colon then password = password .. char
      else parent = parent .. char
      end
    end
  end

  dotpws:close()
  return pws
end

--- Checks to see if `.pws` exists.
--- @return boolean
function datamngr.checkfordotpws()
  local exists = false
  local dotpws = io.open(".pws", 'r')

  if dotpws ~= nil then exists = true; dotpws:close() end
  return exists
end

--- Creates a new entry in `.pws`.
function datamngr.new()
  local dotpws = io.open(".pws", 'a')
  if dotpws == nil then print("Failed to open `.pws`."); os.exit(1) end

  -- Get data for entry.
  io.write("Parent: ")
  local parent = io.read()

  io.write("Password: ")
  local password = io.read()

  dotpws:write(("%s:%s\n"):format(parent, password)) -- parent:password
  dotpws:close()
end

--- Gets an entry from `.pws`.

function datamngr.get()
  io.write("Parent: ")
  local parent = io.read()
  local pws = sortpws()
  local password = pws[parent]

  if password ~= nil then print(password)
  else print(("%s doesn't exist."):format(parent)); os.exit(1)
  end
end

--- Removes an entry from `.pws`.
function datamngr.rm()
  io.write("Parent: ")
  local parent = io.read()
  local pws = sortpws()
  if pws[parent] == nil then print(("%s doesn't exist."):format(parent)); os.exit(1) end

  local dotpws = io.open(".pws", 'w')
  if dotpws == nil then print("Failed to open `.pws`."); os.exit(1) end

  local towrite = ''
  for k, v in pairs(pws) do if k ~= parent then towrite = towrite .. ("%s:%s\n"):format(k, v) end end

  dotpws:write(towrite)
  dotpws:close()
end

--- Prints a list of valid commands.
function datamngr.help() print("Cmds:\n  new\n  get\n  rm\n  help") end

return datamngr
