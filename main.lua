local Game = require 'game/game'
local DrawEngine = require 'game/draw_engine'
local Controller = require 'game/controller'

-- game object
local g = nil
local de = nil
local c = nil

----- global parameters to play with -----

-- any number value > 0
numberOfAnts = 20

-- either 'normal' or 'improved'
typeOfAnts = 'normal'

-- either name of a map file or a table with key: values 1: width, 2: height
map = {20, 20}
-- local map = { 20, 20 }

-- max number of pheromones on one cell
maxPheromones = 600

-- initial draw mode, either 'ants' or 'pheromones'
initialDrawMode = 'ants'

----- end of parameters -----






function love.load()
    g = Game.new(numberOfAnts, typeOfAnts, map, maxPheromones)
    de = DrawEngine.new(g, initialDrawMode)
    c = Controller.new(g, de)
end

local timer = 0
local stepTime = 0.2

function love.update(dt)
    timer = timer + dt

    if timer < stepTime then
        return
    end

    timer = 0

    g:update(dt)
end

function love.draw()
    de:draw()
end

local mouseDown = false

function love.keypressed(key)
    c:handleKeypressed(key)
end

function love.mousepressed(x, y, button, istouch)
    c:handleMousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
    c:handleMousereleased(x, y, button, istouch)
end

function love.mousemoved( x, y, dx, dy, istouch )
    c:handleMousemoved(x, y, dx, dy, istouch)
end