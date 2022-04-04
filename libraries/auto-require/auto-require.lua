function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        local fileInfo = love.filesystem.getInfo(file)
        
        if fileInfo.type == 'file' then
            table.insert(file_list, file)
        elseif fileInfo.type == 'directory' then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end

function autoRequire(folders)
  local file_list = {}
  for _, folderName in ipairs(folders) do
    if(folders) then recursiveEnumerate(folderName, file_list) end
  end
  requireFiles(file_list)
end

return autoRequire