local Object = {}
Object.__index = Object

function Object:new()

return Object

function inherit(child, parent)
    for k,v in pairs(parent) do
        if child[k] == nil then
            child[k] = v
        end
    end
end