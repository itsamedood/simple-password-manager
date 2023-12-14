package.path = "src/?.lua;" .. package.path
local cli = require("cli")
local datamngr = require("datamngr")

local tbl = cli.readargv()
-- No need for flags, there's none necessary.
-- local flags = tbl[1] --- @type table
local cmd = tbl[2] --- @type string|nil

-- Create `.pws` if it doesn't exist.
if not datamngr.checkfordotpws() then os.execute("touch .pws") end

-- Determine action here.
if cmd == "new" then datamngr.new()
elseif cmd == "get" then datamngr.get()
elseif cmd == "rm" then datamngr.rm()
elseif cmd == "gen" then datamngr.gen()
elseif cmd == "help" then datamngr.help()
else print(("Unknown command: %s"):format(cmd))
end
