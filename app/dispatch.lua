local cjson = require("cjson.safe")
local f = require("utils.func")

local route = require("resty.route").new()

local method = ngx.req.get_method()
local url = ngx.var.uri
local param

route:on {
	error = function(self, code)
		print("route:on error")
		ngx.status = ngx.HTTP_FORBIDDEN
		ngx.exit(ngx.status)
		return
	end,
	success = function(self, code)
		print("route:on success")
	end,
	[302] = function(self)
		print("route:on 302")
	end
}

route:use(
	function(self)
		print("This code will be run before router")
		if method == "GET" then
			param = ngx.req.get_uri_args()

		elseif method == "POST" then
			ngx.req.read_body()
			param = ngx.req.get_body_data()
		else
			ngx.status = ngx.HTTP_FORBIDDEN
			ngx.exit(ngx.status)
			return
		end

		-- if not param then
		-- 	ngx.status = ngx.HTTP_BAD_REQUEST
		-- 	ngx.exit(ngx.status)
		-- 	return
		-- end

		self.yield() -- or coroutine.yield()

		print("This code will be run after the router")
	end
)

route {
	["~/s/*"] = function(self)
		print("------------- ws ws ---------------")
		local wschat = require("services.http.chat").new()
		wschat.run()
	end,
	
	-- ["=/"] = function(self)
	-- 	local hello = require("services.http.hello").new()
	-- 	hello.run(param)
	-- end,

	["=/mongo"] = function(self)
		local mongo = require("services.http.mongo").new()
		mongo.run(param)
	end,

	["=/mysql"] = function(self)
		local mysql = require("services.http.mysql").new()
		mysql.run(param)
	end,

	["=/mysql2"] = function(self)
		local mysql = require("services.http.mysql2").new()
		mysql.run(param)
	end,

	["=/mongo2"] = function(self)
		local mongo = require("services.http.mongo2").new()
		mongo.run(param)
	end,

	["=/vmstats"] = function(self)
		local vmstat = require("services.http.vmstat"):new()
		vmstat.run(param)
	end,

	["=/file_upload"] = function(self)
		local upload = require("services.http.upload"):new()
		upload.run(param)
	end,

	
	 
}

route:dispatch()

ngx.log(ngx.ERR, "end!")
