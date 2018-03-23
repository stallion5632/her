local t = require("service.http.samples")
local route = require "resty.route".new()
-- local m = require("service.m")
-- local u = require("service.u")
-- local d = require("service.d")
-- local mi = require("service.mi")
-- local mq = require("service.mq")
-- local md = require("service.md")
-- local mu = require("service.mu")
-- local h = require("service.h")

local _M = {
    ["/t"] = {method = "GET", object = t:new()},
    -- ['/m'] = {method = 'GET',object = m:new()},
    -- ['/u'] = {method = 'POST',object = u:new()},
    -- ['/d'] = {method = 'POST',object = d:new()},
    -- ['/mi'] = {method = 'POST',object = mi:new()},
    -- ['/mq'] = {method = 'GET',object = mq.new()},
    -- ['/md'] = {method = 'POST',object = md.new()},
    -- ['/mu'] = {method = 'POST',object = mu.new()},
    -- ['/h'] = {method = 'GET',object = h.new()},
    route:get(
        "/test",
        function(self)
            ngx.say("1111111111111111test")
        end
    )
}

return _M
