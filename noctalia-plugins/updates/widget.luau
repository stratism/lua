--!nonstrict

noctalia.setUpdateInterval(3600000)
barWidget.setTooltip("Check Updates")

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

    noctalia.runAsync("/home/stratos/bin/updates-check", function(result)
        isRunning = false
        if result.exitCode == 0 then
            currentText = result.stdout:gsub("^%s+", ""):gsub("%s+$", "")
        else
            currentText = "Con err"
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
