require 'lib/util'

local Board = {}
Board.__index = Board

-- basic constructor, should be called internally
function Board.createBasic(maxPheromones)
    local b = {}
    setmetatable(b, Board)

    b.width = 0
    b.height = 0
    b.start = nil
    b.board = nil
    b.maxPheromones = maxPheromones

    return b
end

-- constructor that loads a board from a file
function Board.fromFile(maxPheromones, filename)
    local b = Board.createBasic(maxPheromones)
    local loaded = require('game/maps/' .. filename)
    b.width = loaded.width
    b.height = loaded.height
    b.start = loaded.start
    b.food = loaded.food
    b.board = loaded.board

    return b
end

-- constructor that creates a random board with a given side length
function Board.createRandom(maxPheromones, width, height)
    local b = Board.createBasic(maxPheromones)
    b.width = width
    b.height = height

    b.start = { math.random(width), math.random(height) }
    b.food = { math.random(width), math.random(height) }

    b.board = {}

    for x=1,width do
        b.board[x] = {}
        for y=1,height do
            if x == b.start[1] and y == b.start[2] then
                b.board[x][y] = "start"
            elseif x == b.food[1] and y == b.food[2] then
                b.board[x][y] = "food"
            else
                b.board[x][y] = 0
            end
        end
    end

    return b
end

-- changes a field on the board
function Board:setField(x, y, val)
    assert(x and y and val and type(x) == 'number' and type(y) == 'number', 'wrong arguments supplied for Bord:setField')
    self.board[x][y] = val
end

function Board:evaporate(e)
    e = e or 1

    if e > 0 then
        for x=1,self.width do
            for y=1,self.height do
                if type(self.board[x][y]) == "number" and self.board[x][y] >= 0 then
                    if self.board[x][y] - e > 0 then
                        self.board[x][y] = self.board[x][y] - e
                    else
                        self.board[x][y] = 0
                    end
                end
            end
        end
    end
end

-- retrieve the optimal length
function Board:getOptimalLength(force)
    force = force or false

    if force or self.optimalLength == nil then
        self.optimalLength = math.abs(self.start[1] - self.food[1]) + math.abs(self.start[2] - self.food[2])
    end

    return self.optimalLength
end


function Board:getBadLength()
    return self.width * self.height
end

function Board:isFood(x, y)
    return self.board[x][y] == 'food'
end

function Board:isHome(x, y)
    return self.board[x][y] == 'start'
end

function Board:addPheromone(x, y, add)
    if type(self.board[x][y]) == "number" and self.board[x][y] >= 0  then
        if self.board[x][y] + add <= self.maxPheromones then
            self.board[x][y] = self.board[x][y] + add
        else
            self.board[x][y] = self.maxPheromones
        end
    end
end

-- get the pheromone level at a position
function Board:getPheromones(x, y)
    return self.board[x][y]
end


function Board:isWalkable(x, y)
    if 1 > x or x > self.width or 1 > y or y > self.height then
        return false
    end

    local cell = self.board[x][y]

    return cell == 'food' or cell == 'start' or cell >= 0
end

return Board
