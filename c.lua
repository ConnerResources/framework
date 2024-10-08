sx, sy = guiGetScreenSize()
zoom = 1
local baseX = 1920
local minZoom = 2
if sx < baseX then
  zoom = math.min(minZoom, baseX/sx)
end

guiData = {
    fonts = {},

    buttonColor = {
        ["gray"] = {
          dark = {23, 25, 31, 255},
          light = {34, 36, 43, 255},
        },
        ["green"] = {
          dark = {173, 205, 69, 255},
          light = {207, 242, 103, 255},
        }
    },

    switch = {
        circle = dxCreateTexture("files/images/switch_circle.png", "argb", true, "clamp"),
    }
}

function isMouseInPosition(x, y, width, height)
	if (not isCursorShowing()) then return false end
    local cx, cy = getCursorPosition()
    local cx, cy = (cx*sx), (cy*sy)
    if (cx >= x and cx <= x + width) and (cy >= y and cy <= y + height) then
        return true
    end
    return false
end

function setOpenGUI(state)
    guiData.open = state
    toggleControl("next_weapon", not state)
    toggleControl("previous_weapon", not state)
end
  
function canOpenGUI()
    if isResponseEnabled() then return false end
    return not guiData.open
end

function isEscapeOpen()
    return guiData.isEscapeOpen
end

function setEscapeOpen(state)
    guiData.isEscapeOpen = state
    return true
end

function getFont(size, family)
    local font = guiData.fonts[string.format("size_%s_%d", family and family or "Inter-Regular", size)]
    if not font then font = createFont(size, family) end
    return font
end

function createFont(size, family)
    if not family then return false end
    guiData.fonts[string.format("size_%s_%d", family and family or "Inter-Regular", size)] = dxCreateFont(string.format("files/fonts/%s.ttf", family and family or "Inter-Regular"), size, false)
    return guiData.fonts[string.format("size_%s_%d", family and family or "Inter-Regular", size)]
end

function getButtonColor(color)
    return guiData.buttonColor[color] and guiData.buttonColor[color] or false
end

function removeStoppedResourceElements(res)
    local owner = getResourceName(res)
    for i, v in pairs(createdButtons) do
        if v:getOwner() == owner then
            v:destroy()
        end
    end

    for i, v in pairs(createdSwitches) do
        if v:getOwner() == owner then
            v:destroy()
        end
    end
end
addEventHandler("onClientResourceStop", root, removeStoppedResourceElements)