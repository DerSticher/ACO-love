local board = {
    {    0,   0, -1,  0, -1,  0, -1,  0,  0, "start"},
    {   -1,   0, -1,  0, -1,  0, -1,  0, -1,  0},
    {    0,   0,  0,  0, -1,  0,  0,  0,  0,  0},
    {    0,  -1, -1,  0, -1, -1, -1,  0, -1,  0},
    {    0,   0, -1,  0,  0,  0,  0,  0, -1,  0},
    {   -1,   0, -1,  0, -1,  0,  0,  0, -1,  0},
    {    0,   0,  0,  0, -1,  0, -1, -1,  0,  0},
    {   -1,   0, -1,  0, -1,  0,  0,  0,  0,  0},
    {    0,   0,  0,  0,  0,  0, -1,  0, -1,  0},
    { "food", 0, -1, -1, -1,  0, -1,  0, -1, -1},
}

local t = {}
t.board = board
t.width = 10
t.height = 10
t.start = {1, 10}
t.food = {10, 1}

return t