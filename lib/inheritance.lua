-- fakes inheritence pretty easily
function inherit(child, parent)
    for k,v in pairs(parent) do
        if child[k] == nil then
            child[k] = v
        end
    end
end