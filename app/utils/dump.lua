local _M = { _VERSION =  '0.1.0'}

function _M.dump(v)
    if not __dump then
    	function __dump(v, t, p)    
			local k = p or "";

			if type(v) ~= "table" then
				table.insert(t, k .. " : " .. tostring(v));
			else
				for key, value in pairs(v) do
					__dump(value, t, k .. "[" .. key .. "]");
				end
			end
		end
	end 
	local t = {'--------DUMP--------'};
	__dump(v, t);
	print(table.concat(t, "\n"));
end

return _M