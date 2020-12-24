LOG_BLOCK = 'minecraft:oak_log'
MAX_HEIGHT = 16

FUEL_ITEM = 'minecraft:coal'
REFUEL_AT = 5 -- Fuel level at which the turtle will refuel
REFUEL_COUNT = 1 -- How many fuel items to consume at each refuel

-- heading relative to placement orientation
heading = 0
-- 0: forward
-- 1: right
-- 2: backward
-- 3: left

function turnRight()
    turtle.turnRight()
    heading=heading+1
    if heading>3 then heading=0 end
end

function turnLeft()
    turtle.turnLeft()
    heading=heading-1
    if heading<0 then heading=3 end
end

function faceHeading(newHeading)
    while not (newHeading-heading==0) do
        if (newHeading-heading)>0 then turnRight()
        elseif (newHeading-heading)<0 then turnLeft() end
    end
end

-- Returns true if item is important and should stay in inventory
function isItemImportant(slot)
    if turtle.getItemCount(slot)==0 then return false end
    item = turtle.getItemDetail(slot)['name']
    return item==FUEL_ITEM
end

-- Returns the slot number of item
function findItem(item)
    for slot=1,16 do
        if turtle.getItemCount(slot)>0 then
            if turtle.getItemDetail(slot)['name'] == item then
                return slot
            end
        end
    end
    return nil
end

-- Checks fuel level and refuels if needed
function checkFuel()
    if turtle.getFuelLevel() <= REFUEL_AT then
        slot = findItem(FUEL_ITEM)
        if not slot then error('Out of fuel') end
        print('Refueling')
        turtle.select(slot)
        turtle.refuel(REFUEL_COUNT)
    end
end

function chopTree()
    -- Dig the tree
    i=0
    s,data = turtle.inspect()
    while data.name==LOG_BLOCK do
        turtle.dig()
        turtle.digUp()
        turtle.up()
        i=i+1
        s,data = turtle.inspect()
        if i>=MAX_HEIGHT then break end
    end

    -- Go back down
    while i>0 do
        turtle.down()
        i=i-1
    end
end

function deposit()
    -- Drop all unimportant items
    for slot=1,16 do
        if not isItemImportant(slot) then
            turtle.select(slot)
            turtle.drop()
        end
    end
end

while true do
    faceHeading(0)
    local s,data = turtle.inspect()
    if data.name==LOG_BLOCK then
        checkFuel()
        chopTree()
        faceHeading(2)
        deposit()
        faceHeading(0)
    end
end
