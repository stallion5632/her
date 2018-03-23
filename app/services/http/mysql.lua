local cjson = require("cjson.safe")
local user = require("models.user_mysql"):new()
local f = require("utils.func")

local _M = { _VERSION = '0.1.0' }

local result = {}

function _M.new( self )
    return setmetatable( {} , { __index = _M } )
end

function _M.run( param )
    print(f.dump(param))
    local ret, err
    --insert into mysql
    ret, err = user:insert_user(param)
    if not ret then
        ngx.log(ngx.ERR, err)
        return 
    end

    -- query
    local field = {}
    for k in pairs(param) do
       table.insert(field, k)
    end
     
    --local t = {name = 'a'}
    local t = param
    ret, err = user:query_user(field, param)
    if not ret then
        ngx.log(ngx.ERR, err)
        return 
    else
        if ret._id then -- remove '_id'
            ret._id = nil
        end
        ngx.say('mysql :' .. cjson.encode(ret))
    end
end

return _M