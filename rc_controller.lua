RX_CHANNEL = 420
TX_CHANNEL = 69

local modem = peripheral.find('modem')
local id = os.getComputerID()
modem.open(RX_CHANNEL)