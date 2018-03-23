local cjson = require("cjson.safe")
local struct = require("struct")
local user_dao = require("models.user_mongo"):new()

local _M = {_VERSION = "0.1.0"}


local sock, err
local function send_respone(type, message)
	local len = 4
	if message then
		len =  len + #message
	end

	local res = struct.pack("<II", len, type) 
	if message then
		res = res .. message
	end

	--send back to tcp client
	_, err = sock:send(res)
	if err then
		ngx.log(ngx.ERR, "unable to read request socket: ", err)
		return ngx.exit(500)
	end
end

local function do_work()

	-- message len
	local len, type, message, ret
	while true do
		message, err = sock:receive(4)
		if not message or err then
			ngx.log(ngx.ERR, err)
			break
		end
		len = struct.unpack("<I", message)
		print("len: ", len)

		-- message type
		message, err = sock:receive(4)
		if not message or err then
			ngx.log(ngx.ERR, err)
			break
		end
		local type = struct.unpack("<I", message)
		print("type: ", type)

		if type == 1111 then	-- heartbeat request
			type = 2222			-- heartbeat respone
			send_respone(type, nil)
		else

			--message content
			message, err = sock:receive(len - 4)
			if not message or err then
				ngx.log(ngx.ERR, err)
				break
			end

			local t = cjson.decode(message)
			if not t or not next(t) then
				ngx.log(ngx.ERR, "message content is not a json string")
			else
				--insert into mongodb
				ret, err = user_dao:insert_user({t})
				if not ret then
					ngx.log(ngx.ERR, err)
					break
				end
				
				ret, err = user_dao:query_user(t)
				if not ret then
					ngx.log(ngx.ERR, err)
					break
				end
			end

			print("message content: ", message)
			
			--send back to tcp client
			_, err = sock:send(message .. "\n")
			if err then
				ngx.log(ngx.ERR, "unable to read request socket: ", err)
				return ngx.exit(500)
			end
		end 
	end
end

function _M.run()
	print("run............................................\n")

	sock, err = ngx.req.socket()
	if not sock then
		ngx.log(ngx.ERR, "unable to obtain request socket: ", err)
		return
	end

	-- each connection has a light thread working
	ngx.thread.spawn(do_work)
end

return _M
