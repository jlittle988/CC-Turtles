-- length, width, depth (levels)
args = {...}

int length = args[1]
int width = args[2]
int depth = args[3]

-- dig up down and front, and check to make sure no new block fell into place (gravel)
function dig()
    while turtle.detect()==1 do
        turtle.dig()
    end

dig()
