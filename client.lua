-- client.lua

local socket = require("socket")
local struct = require("lib.struct")
if arg then
    host = arg[1] or host
    port = arg[2] or port
end

local host = host or "127.0.0.1"
local port = port or 1234

print("Attempting connection to host '" .. host .. "' and port " .. port .. "...")

local sock = assert(socket.connect(host, port))

local len, type, input, recvt, sendt, status
while true do
    print("Press enter after input something:")
    input = io.read()
    -- for self test
    if input == "1" then
        input = '{"hello" : "world"}'
    end

    if #input > 0 then
        type = 1001
        len = #input + 4
        print("len type message ", len, type, input)
        local packed = struct.pack("<II", len, type) .. input
        assert(sock:send(packed))
    end

    recvt = socket.select({sock}, nil, 0)
    while #recvt > 0 do
        local response, status = sock:receive()
        if status ~= "closed" then
            if response then
                print("recv from server: ", response)
                recvt = socket.select({sock}, nil, 0)
            end
        else
            print("status: ", status, " -- exit!")
            sock:close()
            return
        end
    end
    print("\n")
end
sock:close()
