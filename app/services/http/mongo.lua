local cjson = require("cjson.safe")
local user = require("models.user_mongo"):new()

local _M = { _VERSION = '0.1.0' }

local result = {}

function _M.new( self )
    return setmetatable( {} , { __index = _M } )
end

function _M.run( param )

    local ret, err
    --insert into mongodb
    ret, err = user:insert_user({param})
    if not ret then
        ngx.log(ngx.ERR, err)
    end
    
    -- query
    ret, err = user:query_user(param)
    if not ret then
        ngx.log(ngx.ERR, err)
    else
        if ret._id then -- remove '_id'
            ret._id = nil
        end
        ngx.say('mongo :' .. cjson.encode(ret))
    end
end

return _M