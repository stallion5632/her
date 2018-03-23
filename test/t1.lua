local t = require("service.http.samples")

local route = require "resty.route".new()
if not route then
    ngx.say('route nil')
else
    print('router ok')
end 


route:as "@home" (function(self) ngx.say("home") end)
route {
    get = {
        ["=/"] = "@home",
        ["=/users"] = function(self) ngx.say("users get") end,
        ["=/t"] = t:new().feed()
    },
    ["=/help"] = function(self) ngx.say("help")  end,
    [{ "post", "put"}] = {
        ["=/me"] = function(self)
            ngx.say("me")
        end
    },
    ["=/you"] = {
        [{ "get", "head" }] = function(self) ngx.say("you") end
    },
}

route:dispatch()

ngx.log(ngx.ERR, "end!")


return _M
