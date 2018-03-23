local cjson = require("cjson.safe")

local _M = { _VERSION = '0.1.0' }


function _M.new( self )
    return setmetatable( {} , { __index = _M } )
end

function _M.run( param )
    ngx.say('hello :' .. cjson.encode(param))
end

return _M