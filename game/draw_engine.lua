require 'lib/util'

local DrawEngine = {}
DrawEngine.__index = DrawEngine

-- constructs the DrawEngine
function DrawEngine.new(game, initialMode)
    local o = {}
    setmetatable(o, DrawEngine)

    o.game = game
    o:selectDrawMode(initialMode)

    return o
end

-- toggles between the draw modes
function DrawEngine:toggleDrawMode()
    if self.draw == DrawEngine.drawPheromones then
        self.draw = DrawEngine.drawAnts
    else
        self.draw = DrawEngine.drawPheromones
    end
end

-- selects a draw mode
function DrawEngine:selectDrawMode(mode)
    if mode == 'pheromones' then
        self.draw = DrawEngine.drawPheromones
    else
        self.draw = DrawEngine.drawAnts
    end
end

-- draws the ant view
function DrawEngine:drawAnts()
    -- what we need from the game object
    local board = self.game:getBoard()
    local ants = self.game.ants

    -- what we need from löve
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    -- our individual cell width and height
    local cellWidth = width / board.width
    local cellHeight = height / board.height

    self:_drawBackground(width, height)

    local helperBoard = {}

    for a=1, #ants do
        local position = ants[a]:getPosition()
        self:_drawAnt((position.x-1)*cellWidth, (position.y-1)*cellHeight, cellWidth, cellHeight)

        helperBoard[position.x .. '-' .. position.y] = true
    end

    for x=1,board.width do
        for y=1,board.height do
            local pheromones = board:getPheromones(x, y)
            local _x = (x-1)*cellWidth
            local _y = (y-1)*cellHeight

            if pheromones ~= -1 and not (type(pheromones) == 'number' and helperBoard[x .. '-'  .. y]) then
                local color = {r=55, g=55, b=55}

                if pheromones == 'start' then
                    color.g = 255
                elseif pheromones == 'food' then
                    color.b = 255
                end

                self:_drawPheromones(_x, _y, cellWidth, cellHeight, color)
            end

            self:_printPheromoneLevel(_x, _y, pheromones)
        end
    end
end

-- draws the pheromone view
function DrawEngine:drawPheromones()
    -- what we need from the game object
    local board = self.game:getBoard()

    -- what we need from löve
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    -- our individual cell width and height
    local cellWidth = width / board.width
    local cellHeight = height / board.height

    self:_drawBackground(width, height)

    for x=1,board.width do
        for y=1,board.height do
            local pheromones = board:getPheromones(x, y)

            if pheromones ~= -1 then
                local color = {r=55, g=55, b=55}

                if pheromones == 'start' then
                    color.g = 255
                elseif pheromones == 'food' then
                    color.b = 255
                elseif pheromones > 0 then
                    color.r = math.clamp(pheromones + 55, 55, 255)
                    color.g = math.clamp(pheromones - 145, 55, 255)
                    color.b = math.clamp(pheromones - 345, 55, 255)
                end

                local _x = (x-1)*cellWidth
                local _y = (y-1)*cellHeight

                self:_drawPheromones(_x, _y, cellWidth, cellHeight, color)
                self:_printPheromoneLevel(_x, _y, pheromones)
            end
        end
    end
end


-- internal helper functions for drawing

function DrawEngine:_drawBackground(width, height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, width, height)
end

function DrawEngine:_drawPheromones(x, y, width, height, color)
    love.graphics.setColor(color.r, color.g, color.b)
    love.graphics.rectangle("fill", x+1, y+1, width-2, height-2)
end

function DrawEngine:_printPheromoneLevel(x, y, pheromones)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(pheromones, x + 4, y + 4, 0, 2)
end

function DrawEngine:_drawAnt(x, y, width, height)
    self:_drawPheromones(x, y, width, height, {r=255, g=55, b=55})
end

return DrawEngine