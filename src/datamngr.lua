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

-- Generates a password of a specified length.
function datamngr.gen()
  math.randomseed(os.time()) -- Initialize randomseed.

  local charset = "abcdefghijklmnopqrstuvwxyz0123456789`~!@#$%^&*()-_+={}[]|:;<>',./?"
  local length

  -- Get a length from the user, continuing until user provides a number.
  while length == nil do
    io.write("Length: ")
    length = tonumber(io.read())
  end

  io.write("Password: \27[32m") -- Set password to be green text.

  for _=1, length do
    local c = math.random(1, #charset)
    local char = charset:sub(c, c)

    if c <= 26 then if math.random(0, 1) == 1 then char = char:upper() end end
    io.write(char)
  end

  io.write("\27[0m\n") -- Reset color from green and end password.
end

--- Prints a list of valid commands.
function datamngr.help() print("Cmds:\n  new\n  get\n  rm\n  gen\n  help") end

return datamngr
