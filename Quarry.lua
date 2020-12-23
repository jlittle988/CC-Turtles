FUEL_ITEM = "minecraft:coal"
REFUEL_AT = 30 -- Fuel level at which the turtle will refuel
REFUEL_COUNT = 1 -- How many fuel items to consume at each refuel

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
        if turtle.getItemDetail(slot) == item then
            return slot
        end
    end
end

    -- Checks fuel level and refuels if needed
function checkFuel()
    if turtle.getFuelLevel() <= REFUEL_AT then
        slot = turtle.findItem(FUEL_ITEM)
        if not slot then error("Out of fuel") end
        turtle.refuel(REFUEL_COUNT)
    end
end

-- Dig up down and front, and check to make sure no new block fell into place (gravel)
-- then move forward and check fuel level
function digMove()
    while turtle.detect() do
        turtle.dig()
    end

    while turtle.detectUp() do
        turtle.digUp()
    end

    while turtle.detectDown() do
        turtle.digDown()
    end

    turtle.forward()

    checkFuel()
end

checkFuel()
