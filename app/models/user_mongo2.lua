--[[
    用户信息集合
    {
   　role:角色，  　		
   　userName:用户名,
　　　pwd:密码，  //md5加密
   　time:注册时间,
   　phoneNum:手机号, 
　　　Email:邮箱,	
 　　}
]] --

local mongol = require("utils.mongol")
local conf = require("config.mongol_conf")
local cjson = require("cjson")
local f = require("utils.func")
local _M = {_VERSION = "0.1.0"}

function _M.new(self)
    local db =
        mongol:init(
        {
            -- set db operate info
            timeout = 10000,
            port = conf.port,
            host = conf.host,
            user = conf.user,
            pwd = conf.pwd,
            db_name = conf.db_name,
            pool_size = 10000,
            idle_time = 10000
        }
    )

    if db ~= nil then
        _M.db = db
    end

    _M.collection = "mongo2" --　set collection

    return setmetatable({}, {__index = _M})
end


function _M.lists(self, query, returnfields, number)
	print('----------lists -----------------')

	local query = query or {}
	local res, err = _M.db:query(_M.collection, query, returnfields, number)
	
	if not res then
		return cjson.encode({code=200, message=err, data=nil})
	else
		if res._id then -- remove '_id'
            res._id = nil
		end
		for i,v in ipairs(res) do
			res[i].id = i --addid
			if res[i]._id then -- remove '_id'
				res[i]._id = nil
			end
		end
		print(f.dump(res))
		return cjson.encode({code=200, message="", data=res})
	end
end

-- 添加操作
function _M.add(self, param)

	if  param.name ~= nil then
		local doc = {param}
		local res, err =  _M.db:insert(_M.collection, doc)
		print(f.dump(res))
        if not res then
			return cjson.encode({code=501, message="添加失败"..err..';sql:'..sql, data=nil})
		else
			return cjson.encode({code=200, message="添加成功", data=param.name})
		end
    else
		return cjson.encode({code=501, message="参数不对", data=nil})
	end
end


return _M
