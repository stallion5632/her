local cjson = require("cjson.safe")
local user = require("models.user_mongo2"):new()
local f = require("utils.func")

local _M = { _VERSION = '0.1.0' }

local result = {}

function _M.new( self )
    return setmetatable( {} , { __index = _M } )
end

function _M.run( param )

    local args = ngx.req.get_uri_args()
    local action = args['action']
    print('---- arction ' .. action)
    
    local res, err
    ngx.req.read_body()
    local t = ngx.req.get_post_args()
    print(f.dump(t))
    if action == 'lists' then
        res = user:lists(t)
    elseif action == 'detail' then
        res = user:detail(t)
    elseif action == 'add' then
        res = user:add(t)
    elseif action == 'delete' then
        res = user:delete(t)
    elseif action == 'update' then
        res = user:update(t)
    end
    print(res)
    ngx.say(res)
     
end

return _M