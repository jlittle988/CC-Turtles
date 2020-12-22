-- length, width, depth (levels)
args = {...}

length = args[1]
width = args[2]
depth = args[3]

-- dig up down and front, and check to make sure no new block fell into place (gravel)
function dig()
    while turtle.detect()==1 do
        turtle.dig()
    end
end

dig()
