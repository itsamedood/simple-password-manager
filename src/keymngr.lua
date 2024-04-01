local datamngr = require "datamngr"
local keymngr = {}

--- Generates a permanant key.
---@return string
function keymngr.genkey()
  return datamngr.gen(44, false) -- Generate a 44 char password (256 bits).
end

function keymngr.getkey()
  local dotkey = io.open('.key', 'r')
end

return keymngr
