require 'common'

com.FUEL_ITEM = 'minecraft:lava_bucket'
com.REFUEL_AT = 5 -- Fuel level at which the turtle will refuel
com.REFUEL_COUNT = 1 -- How many fuel items to consume at each refuel

com.STORAGE_ITEM = 'enderstorage:ender_chest'
com.PICKUP_STORAGE = true

com.IMPORTANT_ITEMS = {
    [1] = com.FUEL_STORAGE_ITEM,
    [2] = com.STORAGE_ITEM,
}

function mineLayer(xdist, zdist)
    com.getLocation()
    local x0 = com.xpos
    local z0 = com.zpos
    local xdir = xdist / math.abs(xdist)
    local zdir = zdist / math.abs(zdist)
    local z_flipped = false

    for x=x0,x0+xdist,xdir do
        if z_flipped then
            for z=z0+zdist,z0,-zdir do
                com.goTo(x,nil,z)
                com.checkInventory()
            end
        else
            for z=z0,z0+zdist,zdir do
                com.goTo(x,nil,z)
                com.checkInventory()
            end
        end
        z_flipped = not z_flipped
    end

    com.goTo(x0,nil,z0)
end




-- length, width, depth (levels)
args = {...}

xdist = args[1]
ydist = args[2]
zdist = args[3]

if not xdist or not ydist or not zdist then
    error("Usage: Quarry [xdist] [ydist] [zdist]")
end

com.getLocation()
local y0 = com.ypos
local xdir = xdist / math.abs(xdist)
local ydir = ydist / math.abs(ydist)
local zdir = zdist / math.abs(zdist)

com.obtainHeading()
for i=1,math.abs(ydist)-1 do
    mineLayer(xdist-xdir, zdist-zdir)
    com.goUp(ydir)
end
mineLayer(xdist-xdir, zdist-zdir)
com.dumpInventory()

com.goTo(nil,y0,nil)



