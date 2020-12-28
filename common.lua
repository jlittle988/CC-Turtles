com = {}

com.IMPORTANT_ITEMS = {}
com.FUEL_ITEM = 'minecraft:lava_bucket'
com.FUEL_STORAGE_ITEM = 'enderstorage:ender_chest'
com.FUEL_STORAGE_ITEM_SLOT = 2
com.REFUEL_AT = 5
com.REFUEL_COUNT = 1
com.STORAGE_ITEM = 'enderstorage:ender_chest'
com.STORAGE_ITEM_SLOT = 1
com.PICKUP_STORAGE = true


com.heading = 0
-- 0: north
-- 1: east
-- 2: south
-- 3: west

-- position
com.xpos = 0
com.ypos = 0
com.zpos = 0

-- home position
com.xhome = nil
com.yhome = nil
com.zhome = nil
com.hhome = nil

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
function com.checkFuel()
    if turtle.getFuelLevel() <= com.REFUEL_AT then
        com.refuel()
    end
end

function com.refuel()
    --slot = com.findItem(com.FUEL_ITEM)
    --if not slot then error('Out of fuel') end
    print('Refueling')

    turtle.select(com.FUEL_STORAGE_ITEM_SLOT)
    while turtle.detectUp() do
        turtle.digUp()
    end
    turtle.placeUp()

    turtle.suckUp()
    turtle.refuel()
    turtle.dropUp()

    turtle.digUp()
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
function com.isItemImportant(slot)
    if turtle.getItemCount(slot)==0 then return false end
    local item = turtle.getItemDetail(slot)['name']
    local important = false
    for _,important_item in ipairs(com.IMPORTANT_ITEMS) do
        if item==important_item then important=true end
    end
    return important
end

-- DEPRECIATED
-- Returns true if the block in the given direction is important and shouldn't be mined
function isBlockImportant(dir)
    print('DEPRECIATED')
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
function com.dumpInventory()
    print('Dumping Inventory')
    
    -- Find the storage item in inventory
    --local storage_slot = com.findItem(com.STORAGE_ITEM)
    --if not storage_slot then error('Out of storage item') end
    turtle.select(com.STORAGE_ITEM_SLOT)

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
    if com.PICKUP_STORAGE then
        turtle.select(com.STORAGE_ITEM_SLOT)
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
    if (com.heading==0) and (newHeading==3) then com.turnLeft()
    elseif (com.heading==3) and (newHeading==0) then com.turnRight()
    else
        while not (newHeading-com.heading==0) do
            if (newHeading-com.heading)>0 then com.turnRight()
            elseif (newHeading-com.heading)<0 then com.turnLeft() end
        end
    end
end

function com.goNorth(distance)
    if distance==0 then return end
    if distance<0 then com.goSouth(-distance)
    else
        com.faceHeading(0) -- Face north

        for i=1,distance do
            com.checkFuel()
            while turtle.detect() do
                turtle.dig()
            end
            turtle.forward()
        end
    end
end

function com.goSouth(distance)
    if distance==0 then return end
    if distance<0 then com.goNorth(-distance)
    else
        com.faceHeading(2) -- Face south

        for i=1,distance do
            com.checkFuel()
            while turtle.detect() do
                turtle.dig()
            end
            turtle.forward()
        end
    end
end

function com.goEast(distance)
    if distance==0 then return end
    if distance<0 then com.goWest(-distance)
    else
        com.faceHeading(1) -- Face east

        for i=1,distance do
            com.checkFuel()
            while turtle.detect() do
                turtle.dig()
            end
            turtle.forward()
        end
    end
end

function com.goWest(distance)
    if distance==0 then return end
    if distance<0 then com.goEast(-distance)
    else
        com.faceHeading(3) -- Face west

        for i=1,distance do
            com.checkFuel()
            while turtle.detect() do
                turtle.dig()
            end
            turtle.forward()
        end
    end
end

function com.goUp(distance)
    if distance==0 then return end
    if distance<0 then com.goDown(-distance)
    else
        for i=1,distance do
            com.checkFuel()
            while turtle.detectUp() do
                turtle.digUp()
            end
            turtle.up()
        end
    end
end

function com.goDown(distance)
    if distance==0 then return end
    if distance<0 then com.goUp(-distance)
    else
        for i=1,distance do
            com.checkFuel()
            while turtle.detectDown() do
                turtle.digDown()
            end
            turtle.down()
        end
    end
end

function com.goTo(x, y, z)
    com.getLocation()
    
    if y then com.goUp(y-com.ypos) end
    if z then com.goSouth(z-com.zpos) end
    if x then com.goEast(x-com.xpos) end
end

function com.goHome()
    if com.xhome and com.yhome and com.zhome and com.hhome then
        com.goTo(com.xhome,com.yhome,com.zhome)
        com.faceHeading(com.hhome)
        print('Returning to home location')
    else
        print('No home location saved')
    end
end

function com.setHome()
    com.getLocation()
    com.xhome = com.xpos
    com.yhome = com.ypos
    com.zhome = com.zpos
    com.hhome = com.heading
    print('Home location saved')
end

function com.obtainHeading()
    local x1,y1,z1 = gps.locate()

    com.checkFuel()
    while turtle.detect() do
        turtle.dig()
    end
    turtle.forward()

    local x2,y2,z2 = gps.locate()

    if x2<x1 then com.heading=3
    elseif x2>x1 then com.heading=1
    elseif z2<z1 then com.heading=0
    elseif z2>z1 then com.heading=2 end

    turtle.back()
end

function com.getLocation()
    com.xpos,com.ypos,com.zpos = gps.locate()
end

return com