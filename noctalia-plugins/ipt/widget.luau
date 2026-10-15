--!nonstrict

noctalia.setUpdateInterval(600000)
barWidget.setTooltip("Tor IP")

local currentText = "..."
local isRunning = false

local function render()
    local container = barWidget.isVertical() and ui.column or ui.row
    barWidget.render(container({ align = "center" }, {
        ui.label({ text = currentText })
    }))
end

local function refresh()
    if isRunning then return end
    isRunning = true

    noctalia.runAsync("/home/stratos/bin/ipnet -e t", function(result)
        isRunning = false
        if result.exitCode == 0 then
            currentText = result.stdout:gsub("^%s+", ""):gsub("%s+$", "")
        else
            currentText = "Tor err"
        end
        render()
    end)
end

function update()
    refresh()
end

function onClick()
    refresh()
end

refresh()
