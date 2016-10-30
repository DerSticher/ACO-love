require 'lib/util'

local Ant = {}
Ant.__index = Ant


-- simple constructor with coordinates and reference to the board object
function Ant.new(x, y, board)
    local a = {}
    setmetatable(a, Ant)

    a.board = board
    a.path = { {x, y} }
    a.status = 'search'
    a.pheromone = 0

    return a
end

-- move this ant. called every step for every ant
function Ant:move()
    print('Abstract ants can\'t move')
end

-- returns the current position of the ant as a table with key: values x: xPos, y: yPos
function Ant:getPosition()
    local position = self.path[#self.path]
    return { x=position[1], y=position[2] }
end

-- returns the next cell/node we go to
function Ant:calculateNextCell()
    local cells = self:getPossibleCells()
    local rand = math.random(self:getProbCounter(cells))
    return self:chooseCell(cells, rand)
end

-- returns a table with all cells that are possible to walk to right now
function Ant:getPossibleCells()
    local path = self.path
    local helper = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    local current = path[#path]
    local last = nil
    local cells = {}

    if #path > 1 then
        last = path[#path-1]
    end

    for i,v in ipairs(helper) do
        local x = current[1] + v[1]
        local y = current[2] + v[2]

        if self.board:isWalkable(x, y) then
            local pheromone = self.board:getPheromones(x, y)
            local oldPosition = path[#path-1]

            if (self.status == 'search' and pheromone == 'food')
                or (self.status == 'carrying' and pheromone == 'start') then
                return {{x, y, 30}}
            elseif oldPosition ~= nil and oldPosition[1] == x and oldPosition[2] == y then
            elseif type(pheromone) == 'number' then
                table.insert(cells, {x, y, pheromone + 30})
            end
        end
    end

    if #cells == 0 then
        local x = path[#path-1][1]
        local y = path[#path-1][2]
        print_r(path)
        print(x, y)
        return {{x, y, self.board:getPheromones(x, y) + 30}}
    end

    return cells
end

-- gets the sum of all probabilities for the cells
function Ant:getProbCounter(cells)
    local counter = 0

    for i,v in ipairs(cells) do
        counter = counter + v[3]
    end

    return counter
end

-- we choose a cell depending on the cells pheremone levels and the rand value
function Ant:chooseCell(cells, rand)
    local counter = 0

    for i,v in ipairs(cells) do
        if counter < rand and rand <= counter + v[3] then
            return {v[1], v[2]}
        end
        counter = counter + v[3]
    end

    print('No cell chosen :(')
    return nil
end

return Ant
