gui = {}

local desktop = nil

function gui.init(term)
    local w,h = term.getSize()
    desktop = window.create(term, 1, 1, w, h)
    desktop.setBackgroundColor(colors.gray)
    desktop.clear()
end

return gui