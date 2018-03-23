--[[
DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
]] --

local mysql = require("utils.mysql")
local conf = require("config.mysql_conf")
local cjson = require("cjson.safe")
local f = require("utils.func")

local _M = {_VERSION = "0.1.0"}

function _M.new(self)

    conf.pool_size = 10000;
    conf.max_idle_timeout = 10000
    local db =
        mysql:new(conf)

    if db ~= nil then
        _M.db = db
    end

    _M.table = "tb_user" --　set table name

    return setmetatable({}, {__index = _M})
end

-- 列表
function _M.lists(self, data)
    print('----------lists -----------------')
	local page, pagesize, offset = 0, 15, 0
	if data.page then
		page = data.page
	end
	if data.pagesize then
		pagesize = data.pagesize
	end
	if page > 1 then
		offset = (page -1)*pagesize
	end

	local res, err, errno, sqlstate = _M.db:query('SELECT * FROM `'.._M.table..'` LIMIT '..offset..','..pagesize)
    
    local data = {}
    if not res then
		return cjson.encode({code=200, message=err, data=nil})
	else
		return cjson.encode({code=200, message="", data=res})
	end
	
end

-- 添加操作
function _M.add(self, data)

	if  data.name ~= nil then
		local sql = 'INSERT INTO '.._M.table..'(name) VALUES ("'..data.name..'")';
		local res, err, errno, sqlstate = _M.db:query(sql)
        if not res then
			return cjson.encode({code=501, message="添加失败"..err..';sql:'..sql, data=nil})
        else
			return cjson.encode({code=200, message="添加成功", data=res.insert_id})
		end
    else
		return cjson.encode({code=501, message="参数不对", data=nil})
	end
end

-- 详情页
function _M.detail(self, data)

    print('----------detail -----------------')
	if data.id ~= nil then
		local data, err, errno, sqlstate = _M.db:query('SELECT * FROM '.._M.table..' WHERE id='..data.id..' LIMIT 1', 1)
		local res = {}
		if data ~= nil then
			res.code = 200
			res.message = '请求成功'
			res.data = data[1]
		else
			res.code = 502
			res.message = '没有数据'
			res.data = data
		end
		return cjson.encode(res)
	else
		return cjson.encode({code = 501, message = '参数错误', data = nil})
	end
	
end

-- 删除操作
function _M.delete(self, data)
	if data.id ~= nil then
		local res, err, errno, sqlstate = _M.db:query('DELETE FROM '.._M.table..' WHERE id='..data.id)
		if not res or res.affected_rows < 1 then
			return cjson.encode({code = 504, message = '删除失败', data = nil})
		else
			return cjson.encode({code = 200, message = '修改成功', data = nil})
		end
	else
		return cjson.encode({code = 501, message = '参数错误', data = nil})
	end
end

-- 修改操作
function _M.update(self, data)
	if data.id ~= nil and data.name ~= nil then
		local res, err, errno, sqlstate = _M.db:query('UPDATE '.._M.table..' SET `name` = "'..data.name..'" WHERE id='..data.id)
		if  not res or res.affected_rows < 1 then
			return cjson.encode({code = 504, message = '修改失败', data = nil})
		else
			return cjson.encode({code = 200, message = '修改成功', data = nil})
		end
	else
		return cjson.encode({code = 501, message = '参数错误', data = nil})
	end
end


return _M
