<<<<<<< HEAD
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
=======
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
>>>>>>> 59c795889d2695624fa5d750edd5ea2632e86e7f
end