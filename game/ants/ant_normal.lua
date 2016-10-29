require 'lib/inheritance'

local baseClass = require 'game/ants/ant_abstract'

local Ant = {}
Ant.__index = Ant
inherit(Ant, baseClass)


-- simple constructor with coordinates and reference to the board object
function Ant.new(x, y, board)
    local a = baseClass.new(x, y, board)
    setmetatable(a, Ant)

    a.pheromones = 50

    return a
end

-- move this ant. called every step for every ant
function Ant:move()
    local cell = self:calculateNextCell()
    table.insert(self.path, cell)
    self.board:addPheromone(cell[1], cell[2], self.pheromones)

    if self.status == 'search' then
        if self.board:isFood(cell[1], cell[2]) then
            self.status = 'carrying'
            self.path = {cell}
        end
    else
        if self.board:isHome(cell[1], cell[2]) then
            self.status = 'search'
            self.path = {cell}
            print('back')
        end
    end
end

return Ant
