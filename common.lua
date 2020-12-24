com = {}

-- heading relative to placement orientation
com.heading = 0
-- 0: north
-- 1: east
-- 2: south
-- 3: west

-- Returns the slot number of item
function com.findItem(item)
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
function com.checkFuel(fuel_item, refuel_at, refuel_count)
    if turtle.getFuelLevel() <= refuel_at then
        slot = com.findItem(fuel_item)
        if not slot then error('Out of fuel') end
        print('Refueling')
        turtle.select(slot)
        turtle.refuel(refuel_count)
    end
end

-- Checks to see if inventory is full, and dumps to chest if so
function com.checkInventory()
    for slot=1,16 do
        if turtle.getItemCount(slot)==0 then
            return
        end
    end
    com.dumpInventory()
end

-- Returns true if item is important and should stay in inventory
function com.isItemImportant(slot, important_items)
    if turtle.getItemCount(slot)==0 then return false end
    local item = turtle.getItemDetail(slot)['name']
    local important = false
    for _,important_item in ipairs(important_items) do
        if item==important_item then important=true end
    end
    return important
end

-- DEPRECIATED
-- Returns true if the block in the given direction is important and shouldn't be mined
function com.isBlockImportant(dir)
    if dir=='f' then
        s,item = turtle.inspect()
    elseif dir=='u' then
        s,item = turtle.inspectUp()
    elseif dir=='d' then
        s,item = turtle.inspectDown()
    end

    return item['name']==STORAGE_ITEM
end

-- Dumps inventory to storage item
function com.dumpInventory(storage_item, pickup_storage)
    print('Dumping Inventory')
    
    -- Find the storage item in inventory
    local storage_slot = com.findItem(storage_item)
    if not storage_slot then error('Out of storage item') end
    turtle.select(storage_slot)

    -- Make sure the space above is free, and place it
    while turtle.detectUp() do
        turtle.digUp()
    end
    turtle.placeUp()

    -- Drop all unimportant items into the storage
    for slot=1,16 do
        if not com.isItemImportant(slot) then
            turtle.select(slot)
            turtle.dropUp()
        end
    end
    
    -- Break the storage if required
    if pickup_storage then
        turtle.digUp()
    end
end

function com.turnRight()
    turtle.turnRight()
    com.heading=com.heading+1
    if com.heading>3 then com.heading=0 end
end

function com.turnLeft()
    turtle.turnLeft()
    com.heading=com.heading-1
    if com.heading<0 then com.heading=3 end
end

function com.faceHeading(newHeading)
    while not (newHeading-com.heading==0) do
        if (newHeading-com.heading)>0 then com.turnRight()
        elseif (newHeading-com.heading)<0 then com.turnLeft() end
    end
end

function com.goForward(distance)
    if distance<0 then com.goBackward(-distance) end
    
    com.faceHeading(0) -- Face forward

    for i=1,distance do
        com.checkFuel()
        while turtle.detect() do
            turtle.dig()
        end
        turtle.forward()
    end
end

function com.goBackward(distance)
    if distance<0 then com.goForward(-distance) end
    
    com.faceHeading(2) -- Face backward

    for i=1,distance do
        com.checkFuel()
        while turtle.detect() do
            turtle.dig()
        end
        turtle.forward()
    end
end

function com.goRight(distance)
    if distance<0 then com.goLeft(-distance) end
    
    com.faceHeading(1) -- Face right

    for i=1,distance do
        com.checkFuel()
        while turtle.detect() do
            turtle.dig()
        end
        turtle.forward()
    end
end

function com.goLeft(distance)
    if distance<0 then com.goRight(-distance) end
    
    com.faceHeading(3) -- Face left

    for i=1,distance do
        com.checkFuel()
        while turtle.detect() do
            turtle.dig()
        end
        turtle.forward()
    end
end

function com.goUp(distance)
    if distance<0 then com.goDown(-distance) end
    
    for i=1,distance do
        com.checkFuel()
        while turtle.detectUp() do
            turtle.digUp()
        end
        turtle.up()
    end
end

function com.goDown(distance)
    if distance<0 then com.goUp(-distance) end
    
    for i=1,distance do
        com.checkFuel()
        while turtle.detectDown() do
            turtle.digDown()
        end
        turtle.down()
    end
end

function com.goTo(x, y, z)
    print('TODO')
end

-- Travel to original location
function com.goHome()
    print('Going home')
    
    com.goHomeX()
    com.goHomeY()
    com.goHomeZ()

    com.faceHeading(0)
end

function com.goHomeX()
    if xpos<0 then
        com.goRight(-xpos)
    elseif xpos>0 then
        com.goLeft(xpos)
    end
end

function com.goHomeY()
    if ypos<0 then
        goForward(-ypos)
    elseif ypos>0 then
        goBackward(ypos)
    end
end

function com.goHomeZ()
    if zpos<0 then
        goUp(-zpos)
    elseif zpos>0 then
        goDown(zpos)
    end
end

function com.getHeading()
    local x1,y1,z1 = gps.locate()

    com.checkFuel()
    while turtle.detect() do
        turtle.dig()
    end
    turtle.forward()

    local x2,y2,z2 = gps.locate()

    if x2<x1 then heading=3
    elseif x2>x1 then heading=1
    elseif z2<z1 then heading=0
    elseif z2>z1 then heading=2 end
end

return com