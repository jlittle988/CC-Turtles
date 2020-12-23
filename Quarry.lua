FUEL_ITEM = "minecraft:coal"
REFUEL_AT = 32 -- Fuel level at which the turtle will refuel
REFUEL_COUNT = 1 -- How many fuel items to consume at each refuel

STORAGE_ITEM = "minecraft:chest"
PICKUP_STORAGE = false

-- heading relative to placement orientation
heading = 0
-- 0: forward
-- 1: right
-- 2: backward
-- 3: left

-- position relative to placement position
ypos = 0
xpos = 0
zpos = 0

-- length, width, depth (levels)
args = {...}

length = args[1]
width = args[2]
depth = args[3]

--if not length or not width or not depth then
    --error("Usage: Quarry [length] [width] [depth]")

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
        turtle.refuel(REFUEL_COUNT)
    end
end

-- Checks to see if inventory is full, and dumps to chest if so
function checkInventory()
    for slot=1,16 do
        if turtle.getItemCount(slot)==0 then
            return
        end
    end
    dumpInventory()
end

-- Returns true if item is important and should stay in inventory
function isItemImportant(slot)
    if turtle.getItemCount(slot)==0 then return false end
    item = turtle.getItemDetail(slot)['name']
    return item==FUEL_ITEM or item==STORAGE_ITEM
end

-- Returns true if the block in the given direction is important and shouldn't be mined
function isBlockImportant(dir)
    if dir=='f' then
        s,item = turtle.inspect()
    elseif dir=='u' then
        s,item = turtle.inspectUp()
    elseif dir=='d' then
        s,item = turtle.inspectDown()
    end

    return item['name']==STORAGE_ITEM
end

-- Dumps inventory to a chest and leaves it behind
function dumpInventory()
    print('Dumping Inventory')
    
    -- Find the storage item in inventory
    storage_slot = findItem(STORAGE_ITEM)
    if not storage_slot then error('Out of storage item') end
    turtle.select(storage_slot)

    -- Make sure the space above is free, and place it
    while turtle.detectUp() do
        turtle.digUp()
    end
    turtle.placeUp()

    -- Drop all unimportant items into the storage
    for slot=1,16 do
        if not isItemImportant(slot) then
            turtle.select(slot)
            turtle.dropUp(slot)
        end
    end
    
    -- Break the storage if required
    if PICKUP_STORAGE then
        turtle.digUp()
    end
end

-- Dig up down and front, and check to make sure no new block fell into place (gravel)
-- then move forward and check fuel level
function digMove()
    checkFuel()
    
    while turtle.detect() do
        if isBlockImportant('f') then error('Encountered obstacle') end
        turtle.dig()
    end

    while turtle.detectUp() do
        if isBlockImportant('u') then error('Encountered obstacle') end
        turtle.digUp()
    end

    while turtle.detectDown() do
        if isBlockImportant('d') then error('Encountered obstacle') end
        turtle.digDown()
    end

    checkInventory()

    turtle.forward()
    if heading==0 then ypos=ypos+1 end
    if heading==1 then xpos=xpos+1 end
    if heading==2 then ypos=ypos-1 end
    if heading==3 then xpos=xpos-1 end
end

function turnRight()
    turtle.turnRight()
    heading=heading+1
    if heading>3 then heading=0 end
end

function turnLeft()
    turtle.turnLeft()
    heading=heading+1
    if heading<0 then heading=3 end
end

function faceHeading(newHeading)
    while not (newHeading-heading==0) do
        turnRight()
    end
end

function goForward(distance)
    faceHeading(0) -- Face forward

    for i=1,distance do
        digMove()
    end
end

function goBackward(distance)
    faceHeading(2) -- Face backward

    for i=1,distance do
        digMove()
    end
end

function goRight(distance)
    faceHeading(1) -- Face right

    for i=1,distance do
        digMove()
    end
end

function goLeft(distance)
    faceHeading(3) -- Face left

    for i=1,distance do
        digMove()
    end
end

function goUp(distance)
    for i=1,distance do
        checkFuel()

        while turtle.detectUp() do
            if isBlockImportant('u') then error('Encountered obstacle') end
            turtle.digUp()
        end

        turtle.up()
        zpos=zpos+1
    end
end

function goDown(distance)
    for i=1,distance do
        checkFuel()

        while turtle.detectDown() do
            if isBlockImportant('d') then error('Encountered obstacle') end
            turtle.digDown()
        end

        turtle.down()
        zpos=zpos-1
    end
end

-- Travel to original location
function goHome()
    print('Going home')
    
    if ypos<0 then
        goForward(-ypos)
    elseif ypos>0 then
        goBackward(ypos)
    end

    if xpos<0 then
        goRight(-xpos)
    elseif xpos>0 then
        goLeft(xpos)
    end

    if zpos<0 then
        goUp(-zpos)
    elseif zpos>0 then
        goDown(zpos)
    end

    faceHeading(0)
end


x_reverse = false
y_reverse = false
for i=1,depth do
    for j=1,width do
        if y_reverse then goBackward(length)
        else goForward(length) end
        y_reverse = not y_reverse

        if x_reverse then goLeft(1)
        else goRight(1) end
    end
    x_reverse = not x_reverse

    goDown(3)
end

print(xpos)
print(ypos)

goHome()