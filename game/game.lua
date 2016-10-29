local Board = require 'game/board'
local AntTypes = { normal = require 'game/ants/ant_normal', improved = require 'game/ants/ant_improved' }

local Game = {}
Game.__index = Game

-- simple constructor, calls the init function
function Game.new(antAmount, anttype, map, maxPheromones)
    local o = {}
    setmetatable(o, Game)

    o:init(antAmount, anttype, map, maxPheromones)

    return o
end

-- (re)initializes the game with the number of ants, the type of ants ('improved' or 'normal')
-- and either the name of a map file, or a table with 1: width and 2: height
function Game:init(antAmount, anttype, map, maxPheromones)
    anttype = anttype or 'improved'
    map = map or nil

    math.randomseed(os.time())

    self.isPaused = true
    self:init_board(map, maxPheromones)
    self:init_anttype(anttype)
    self:init_ants(antAmount)
end

-- initializes the board
function Game:init_board(map, maxPheromones)
    if map == nil then
        self.board = Board.createRandom(maxPheromones, 20, 20)
    elseif type(map) == 'table' then
        self.board = Board.createRandom(maxPheromones, map[1], map[2])
    else
        self.board = Board.fromFile(maxPheromones, map)
    end
end

-- initializes the anttype
function Game:init_anttype(anttype)
    assert(AntTypes[anttype] ~= nil, "invalid anttype")
    self.antClass = AntTypes[anttype]
    self.anttype = anttype
end

-- initializes the ants
function Game:init_ants(antAmount)
    self.ants = {}
    self.antCounter = antAmount
    for a=1,self.antCounter do
        self.ants[a] = self.antClass.new(self.board.start[1], self.board.start[2], self.board)
        self.ants[a]:getPosition()
    end
end

-- returns the board
function Game:getBoard()
    return self.board
end

-- simulation goes a step forward
function Game:update()
    if self.isPaused then
        return
    end

    for a=self.antCounter,1,-1 do
        self.ants[a]:move()
    end

    if self.anttype =='improved' then
        self.board:evaporate(1)
    end
end

-- toggles pause, returns the new value of isPaused
function Game:togglePause()
    self.isPaused = not self.isPaused
    return self.isPaused
end

-- sets isPaused
function Game:setIsPaused(bool)
    assert(bool and type(bool) == 'boolean', 'parameter must be boolean')
    self.isPaused = bool
end

return Game