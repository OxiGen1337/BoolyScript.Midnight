local filesys = {}

function filesys.doesFileExist(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
	   if code == 13 then
		  return true
	   end
	end
	return ok, err
end

function filesys.doesFolderExist(path)
	return filesys.doesFileExist(path.."/")
end

function filesys.createDir(path)
    return os.execute("mkdir " .. "\"" .. path .. "\"")
end

function filesys.delete(path)
	if filesys.doesFileExist(path) or filesys.doesFolderExist(path) then
		os.remove(path)
	end
end

function filesys.getInitScriptPath()
	local out = fs.get_dir_script():gsub("\\\\lua", "\\lua")
	if DEBUG then return out .. "\\Git" end
	return out
end

function filesys.logInFile(path_s, header_s, text_s)
	local file = io.open(path_s, 'a+')
	local outStr = string.format("[%s] [%s] %s\n", os.date("%c"), tostring(header_s), tostring(text_s))
	file:write(outStr)
	file:close()
end

return filesys
