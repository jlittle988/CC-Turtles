FUEL_ITEM = "minecraft:coal"
REFUEL_AT = 32 -- Fuel level at which the turtle will refuel
REFUEL_COUNT = 1 -- How many fuel items to consume at each refuel

STORAGE_ITEM = "minecraft:chest"
PICKUP_STORAGE = false

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
        if turtle.getItemDetail(slot)['name'] == item then
            return slot
        end
    end
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
function isImportant(slot)
    if turtle.getItemCount(slot)==0 then return false end
    item = turtle.getItemDetail(slot)['name']
    return item==FUEL_ITEM or item==STORAGE_ITEM
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
        if not isImportant(slot) then
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
end

dir = true
for i=1,width do
    for j=1,length do
        digMove()
    end

    if dir then
        turtle.turnRight()
        digMove()
        turtle.turnRight()
        dir = false
    else
        turtle.turnLeft()
        digMove()
        turtle.turnLeft()
        dir = true
    end
end

turtle.turnRight()
for i=1,width do
    turtle.forward()
end

turtle.turnLeft()
for i=1,length do
    turtle.forward()
end