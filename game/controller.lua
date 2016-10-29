local Controller = {}
Controller.__index = Controller

function Controller.new(game, drawEngine)
    local o = {}
    setmetatable(o, Controller)

    o.game = game
    o.drawEngine = drawEngine
    o.mouseDown = false

    return o
end

-- handles key presses
-- ! uses globals from main.lua !
function Controller:handleKeypressed(key)
    if key == "return" then
        self.drawEngine:toggleDrawMode()
    elseif key == "space" then
        self.game:togglePause()
    elseif key == "1" then
        self.game:init(numberOfAnts, 'normal', map, maxPheromones, initialDrawMode)
    elseif key == "2" then
        self.game:init(numberOfAnts, 'improved', map, maxPheromones, initialDrawMode)
    elseif key == "escape" then
        os.exit()
    end
end

-- handles mouse presses
function Controller:handleMousepressed(x, y, button, istouch)
    local board = self.game:getBoard()

    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    local cellWidth = width / board.width
    local cellHeight = height / board.height
    local x = math.ceil(x/cellWidth)
    local y = math.ceil(y/cellHeight)

    if x <= 0 then
        x = 1
    end

    if y <= 0 then
        y = 1
    end

    if button == 1 then
        board:setField(x, y, -1)
    else
        board:setField(x, y, 0)
    end

    self.mouseDown = button
end

-- handles releasing a mouse button
function Controller:handleMousereleased(x, y, button, istouch)
    if button == self.mouseDown then
        self.mouseDown = false
    end
end

-- handles moving the mouse
function Controller:handleMousemoved( x, y, dx, dy, istouch )
    if self.mouseDown then
        self:handleMousepressed(x, y, self.mouseDown, istouch)
    end
end

return Controller