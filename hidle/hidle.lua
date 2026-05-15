#!/usr/bin/env lua

-- $Id: hidle.lua,v 1.1 2026/05/15 04:33:50 stratos Exp $

-- Script to manage hypridle in Lua
-- Usage:
--   hidle          (Toggles between start/stop)
--   hidle stop     (Force stop)
--   hidle start    (Force start)
--   hidle restart  (Kill and start)

local function is_running()
    local handle = io.popen("pgrep -x hypridle")
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end

local function stop_hypridle()
    if is_running() then
        os.execute("pkill -x hypridle")
        print("hypridle stopped.")
    else
        print("hypridle was not running.")
    end
end

local function start_hypridle()
    if is_running() then
        print("hypridle is already running.")
    else
        -- Using '&' to run in background
        os.execute("hypridle &")
        print("hypridle started.")
    end
end

local cmd = arg[1]
local app = arg[0]

if cmd == "stop" then
    stop_hypridle()
elseif cmd == "start" then
    start_hypridle()
elseif cmd == "restart" then
    stop_hypridle()
    os.execute("sleep 0.5")
    start_hypridle()
elseif cmd == "help" then
   print(" Usage:")
   print("   " .. app .. "          (Toggles between start/stop)")
   print("   " .. app .. " stop     (Force stop)")
   print("   " .. app .. " start    (Force start)")
   print("   " .. app .. " restart  (Kill and start)")
   
else
    -- Default toggle behavior
    if is_running() then
        stop_hypridle()
    else
        start_hypridle()
    end
end
