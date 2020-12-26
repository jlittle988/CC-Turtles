require 'common'

RX_CHANNEL = 69
TX_CHANNEL = 420

local modem = peripheral.find('modem')
local id = os.getComputerID()
modem.open(RX_CHANNEL)

while true do
    _,_,_,_,msg,_ = os.pullEvent()
    if msg.id == id then
        if msg.cmd == 'goTo' then
            com.goTo(msg.x, msg.y, msg.z)
            modem.transmit(TX_CHANNEL, 0, true)
        elseif msg.cmd == 'quarry' then
            shell.run('quarry', tostring(msg.length), tostring(msg.width), tostring(msg.depth))
            modem.transmit(TX_CHANNEL, 0, true)
        elseif msg.cmd == 'quit' then
            modem.transmit(TX_CHANNEL, 0, true)
            break
        end
    end
end