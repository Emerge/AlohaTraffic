local zip = require("zlib")

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

		if (head) then 
			t.headers[i] = str 
		else
			t.data = t.data..str
		end
        i = i + 1
        
        if (string.match(str, "^%s+$")) then
			--print("HEAD.................................................")
        	head = false
        	i = 1
        end
    end

    if(tableLen(t.headers) == 0) then
    	t.type = "UNKOWN"	
    else 
		t.statusCode = string.match(t.headers[1], "HTTP/1.1 (%d+)")
		if (t.statusCode) then
			t.type = "RES"
		else
			t.type = "REQ"
		end
	end
	return t
end

function modify(data)
	--print("============================== INFO:")
	local t = extract(data)
	local count = tableLen(t)
	--print("lines count:", count, t.type, t.lines[1])

	if (t.type == "UNKOWN") then
		print("UNKOWN TYPE")

	elseif (t.type == "REQ") then
		if (string.match(data, "Accept.Encoding.-\n")) then
			--print("=========================== REMOVE GZIP DEFLATE")
			data = string.gsub(data, "Accept.Encoding.-\n", "")
		end

	elseif (t.type == "RES") then
		if (string.match(data, "Content.Encoding. gzip") and string.match(data, "Content.Type. text/html")) then
			print("============================== GZIP DATA:")
			print(t.data)
		end
	end
    -- data = string.gsub(data, "gzip, deflate", "") --for requests
    --data = string.gsub(data, "<title>", "<title>HOLY") --for responses
    return data
end
