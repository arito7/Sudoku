function inList(val, list)
    for k, v in pairs(list) do
        if v == val then
            return true
        end
    end
    return false
end