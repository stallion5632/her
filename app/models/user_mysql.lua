--[[
CREATE TABLE `user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL ,
  `address` text ,
  `time` int(11) unsigned DEFAULT '0',
  `age` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
]] --

local mysql = require("utils.mysql")
local conf = require("config.mysql_conf")
local cjson = require("cjson")


local _M = {_VERSION = "0.1.0"}

function _M.new(self)

    conf.pool_size = 10000;
    conf.max_idle_timeout = 10000
    local db =
        mysql:new(conf)

    if db ~= nil then
        _M.db = db
    end

    _M.table = "user" --　set table name

    return setmetatable({}, {__index = _M})
end

function _M.insert_user(self, t)
    if not _M.db  or not t then
        return nil, "user dao can not get db or t"
    end

    return _M.db:insert(_M.table, t)
end

function _M.query_user_sql(self, opt)
    if not _M.db or not field or not where then
        return nil, "user dao bad query_user_sql"
    end

    local sql = 'SELECT * FROM `'.._M.table .. opt;

    return _M.db:query(sql)
end


function _M.query_user(self, field, where)
    if not _M.db or not field or not where then
        return nil, "user dao bad query_user"
    end


    return _M.db:find(_M.table, field, where)
end

function _M.query_users(self, field, where)
    if not _M.db or not field or not where then
        return nil, "user dao bad query_users"
    end

    return _M.db:findAll(_M.table, field, where)
end

function _M.update_user(self, field, where)
    if not _M.db or not field or not where then
        return nil, "user dao bad update_user"
    end

    return _M.db:update(_M.table, field, where)
end

return _M
