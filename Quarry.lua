FUEL_ITEM = "minecraft:coal"
REFUEL_AT = 5 -- Fuel level at which the turtle will refuel
REFUEL_COUNT = 1 -- How many fuel items to consume at each refuel

STORAGE_ITEM = "enderstorage:ender_chest"
PICKUP_STORAGE = true

IMPORTANT_ITEMS = {
    [1] = FUEL_ITEM,
    [2] = STORAGE_ITEM,
}

require 'common'

-- position relative to placement position
ypos = 0
xpos = 0
zpos = 0

-- length, width, depth (levels)
args = {...}

length = args[1]
width = args[2]
depth = args[3]

if not length or not width or not depth then
    error("Usage: Quarry [length] [width] [depth]")

-- Dig up down and front, and check to make sure no new block fell into place (gravel)
-- then move forward and check fuel level
function digMove()
    checkFuel()
    
    while turtle.detect() do
        turtle.dig()
    end

    while turtle.detectUp() do
        turtle.digUp()
    end

    while turtle.detectDown() do
        turtle.digDown()
    end

    checkInventory()

    turtle.forward()
    if heading==0 then ypos=ypos+1 end
    if heading==1 then xpos=xpos+1 end
    if heading==2 then ypos=ypos-1 end
    if heading==3 then xpos=xpos-1 end
end

function mineLayer(w, l)
    xdir = w / math.abs(w)
    l = l - (l / math.abs(l))
    ydir = 1
    for i=1,w-1 do
        goForward(l*ydir)
        goRight(xdir)
        ydir = ydir*-1
    end
    goForward(l*ydir)
end

for i=1,depth-1 do
    mineLayer(width, length)
    goHomeX()
    goHomeY()
    goDown(3)
end
mineLayer(width, length)
goHome()



