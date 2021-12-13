function inList(val, list)
    for k, v in pairs(list) do
        if v == val then
            return true
        end
    end
    return false
end

function listSize(list)
    count = 0
    for k, v in pairs(list) do
        count = count + 1
    end
    return count
end