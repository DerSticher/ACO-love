require 'lib/inheritance'

local baseClass = require 'game/ants/ant_abstract'

local Ant = {}
Ant.__index = Ant
inherit(Ant, baseClass)


-- simple constructor with coordinates and reference to the board object
function Ant.new(x, y, board)
    local a = baseClass.new(x, y, board)
    setmetatable(a, {__index = baseClass})
    setmetatable(a, Ant)

    return a
end

-- move this ant. called every step for every ant
function Ant:move()
    if self.status == 'search' then
        local cell = self:calculateNextCell(self)
        table.insert(self.path, cell)

        if self.board:isFood(cell[1], cell[2]) then
            self.status = 'carrying'
            self.path = self:eliminateLoops(self.path)

            local length = #self.path

            self.pheromone = self:calcPheromones(length)
        end
    else
        local path = self.path
        if #path == 1 then
            self.status = 'search'
        else
            table.remove(self.path, #self.path)
            local cell = self.path[#self.path]
            self.board:addPheromone(cell[1], cell[2], self.pheromone)
        end
    end
end

-- calculates the level of pheromones laid on this way back
function Ant:calcPheromones(length)
    local optimalLength = self.board:getOptimalLength()
    local badLength = self.board:getBadLength()
    return math.floor(100 - 4*(length - optimalLength) * 100 / (badLength - optimalLength))
end

-- eliminates loops in the path
function Ant:eliminateLoops(path)
    local helperBoard = {}

    for i=1,#path do
        local helperKey = path[i][1] .. '-' .. path[i][2]

        if helperBoard[helperKey] == nil then
            helperBoard[helperKey] = i
        else
            for j=i, helperBoard[helperKey]+1, -1 do
                table.remove(path, j)
            end
            return self:eliminateLoops(path)
        end
    end

    return path
end


return Ant
