local route =  require("lua.config.route")
local cjson = require("cjson")

local method = ngx.req.get_method()
local url = ngx.var.uri 

local worker
local body

for  u , t in pairs(route) do
	
	if u == url then
		worker  = t  break
	end

end

if not worker or method ~= worker.method then -- forbidden
	ngx.status = ngx.HTTP_FORBIDDEN 
	ngx.exit(ngx.status)
	return
end 



if method == 'GET' then

	body = ngx.req.get_uri_args()

elseif method == 'POST' then

	ngx.req.read_body();
	body = ngx.req.get_post_args()

else

	ngx.req.read_body();
	body = ngx.req.get_body_data();

end

-- ngx.log(ngx.INFO , "body : " .. body)
if not body then   -- charge body in there , can notes this code
	ngx.status = ngx.HTTP_BAD_REQUEST
	ngx.exit(ngx.status)
	return
end

worker.object:feed(body)

