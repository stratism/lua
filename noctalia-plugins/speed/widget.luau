--!nonstrict

noctalia.setUpdateInterval(1800000)
barWidget.setTooltip("Internet Speed (click to test)")

local currentText = "..."
local cacheFile = "/tmp/noctalia-speed.txt"
local lastRunTime = os.time()

local function render()
    local container = barWidget.isVertical() and ui.column or ui.row
    barWidget.render(container({ align = "center" }, {
        ui.label({ text = currentText })
    }))
end

local function readCache()
    noctalia.runAsync("cat " .. cacheFile, function(result)
        if result.exitCode == 0 and result.stdout ~= "" then
            local val = result.stdout:gsub("^%s+", ""):gsub("%s+$", "")
            if val ~= "" then
                currentText = val
                render()
            end
        end
    end)
end

local function triggerSpeedTest()
    currentText = "measuring..."
    render()
    noctalia.runAsync("/bin/bash -c '/home/stratos/bin/speed > " .. cacheFile .. " 2>/dev/null &'")
end

function update()
    readCache()

    local now = os.time()
    if now - lastRunTime >= 300 then
        lastRunTime = now
        triggerSpeedTest()
    end
end

function onClick()
    lastRunTime = os.time()
    triggerSpeedTest()
end

readCache()
