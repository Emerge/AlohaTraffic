local zlib = require "zlib"
local buffer = {}

function tableLen(t)
	local count = 0
	for _ in pairs(t) do count = count + 1 end
	return count
end 

function extract(data)
	local t = {}
	--local sep = "\n"
	t.headers = {}
	t.data = ""
	local i = 1
	local head = true
	for str in string.gmatch(data, ".-\n") do
        --print("_________________________________", str)

        if (string.match(str, "^%s+$")) then
			--print("HEAD.................................................")
        	head = false
        	i = 1
        end

		if (head) then 
			t.headers[i] = str 
		else
			t.data = t.data..str
		end
        i = i + 1
        
        
    end

    if(tableLen(t.headers) == 0) then
    	t.type = "UNKOWN"	
    	print("============================== UNKOWN DATA BEGIN")
    	print(data)
    	print("============================== UNKOWN DATA END")
    else 
		t.statusCode = string.match(t.headers[1], "HTTP/1.1 (%d+)")
		if (t.statusCode) then
			if (string.match(data, "Content.Type. text/html")) then t.html = true end
			t.type = "RES"
		else
			t.type = "REQ"
		end
	end
	return t
end

function modify(data, isresp, ctx, encoding)
	print (isresp, ctx, encoding)
	if (encoding) then
		local decompres = zlib.inflate()
		local r = decompress(data)
		r = string.gsub(r, "<title>", "<title>HOLY")
		local compress = zlib.deflate()
		data = compress(r)
	else
		data = string.gsub(r, "<title>", "<title>HOLY")
	end	
	--if (isresp) then print(data) end
	--print("============================== DATA BEGIN")
	--print(data)
	--print("============================== DATA END")

	--local len = data.gmatch(data, "Content.Length. (%d)+")()
	--if (len) then
	--	print("replace len: " .. len .. " as : " .. (len + 4) )
	--	data = string.gsub(data, "Content.Length. %d+", "Content-Length: "..(len+4))
	--end

	--data = string.gsub(data, "Accept.Encoding.-\n", "")
	--data = string.gsub(data, "<title>", "<title>HOLY")
	--if (string.match(data, "Content.Type. text/html")) then
	--	local stream = zlib.inflate()
	--	local r = stream(t.data)
	--end

	--local t = extract(data)
	--local count = tableLen(t)

	--if (t.type == "UNKOWN") then
	--	print("UNKOWN TYPE")

	--elseif (t.type == "REQ") then
	--	if (string.match(data, "Accept.Encoding.-\n")) then
			--print("=========================== REMOVE GZIP DEFLATE")
	--		data = string.gsub(data, "Accept.Encoding.-\n", "")
	--	end

	--elseif (t.type == "RES" and t.html) then
	--	local total, current, buffer
	--	local len = data.gmatch(data, "Content.Length. (%d)+")()
	--	if (len) then
	--		buffer = ""
	--		current = 0
	--		total = len 
	--	end

	--	current = current + string.len(data)
	--	buffer = buffer..data

	--	if (string.match(data, "Content.Encoding. gzip")) then
	--		print("============================== GZIP DATA:")
	--		local stream = zlib.inflate()
	--		local r = stream(t.data)
	--		print(r)
			
	--	else 
	--		print("============================== PLAIN DATA:")
	--		print(data)
	--	end
	--end
    -- data = string.gsub(data, "gzip, deflate", "") --for requests
    --data = string.gsub(data, "<title>", "<title>HOLY") --for responses
    return data
end
