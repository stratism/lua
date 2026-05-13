#!/usr/bin/env lua

-- $Id: ceph_calc.lua,v 1.1 2026/05/13 09:02:06 stratos Exp $

-- Ceph Sizing & PG Calculator
-- Based on logic from: https://zdalnyadmin.com.pl/ceph-calculator/

local function get_nearest_power_of_2(n)
    if n <= 0 then return 1 end
    return 2 ^ math.floor(math.log(n, 2) + 0.5)
end

local function prompt(msg, default)
    io.write(msg .. " [" .. tostring(default) .. "]: ")
    local input = io.read()
    if input == "" or input == nil then
        return default
    end
    return input
end

local function calculate()
    print("------------------------------------------")
    print("       Ceph Sizing & PG Calculator        ")
    print("------------------------------------------")

    local osd_count = tonumber(prompt("Total Number of OSDs", 12))
    local disk_capacity = tonumber(prompt("Individual Disk Capacity (TB)", 4.0))
    local full_ratio = tonumber(prompt("Ceph 'Full' Ratio (Safety limit)", 0.85))
    
    local redundancy_type = prompt("Redundancy Method (replication/ec)", "replication")
    
    local usable_capacity = 0.0
    local efficiency = 0.0
    local redundancy_info = ""

    if redundancy_type == "replication" then
        local repl_factor = tonumber(prompt("Replication Factor", 3))
        efficiency = (1 / repl_factor) * 100
        usable_capacity = (osd_count * disk_capacity) / repl_factor
        redundancy_info = "Replication " .. repl_factor .. "x"
    else
        local k = tonumber(prompt("Data Chunks (k)", 4))
        local m = tonumber(prompt("Coding Chunks (m)", 2))
        efficiency = (k / (k + m)) * 100
        usable_capacity = (osd_count * disk_capacity) * (k / (k + m))
        redundancy_info = "Erasure Coding " .. k .. "+" .. m
    end

    local raw_capacity = osd_count * disk_capacity
    local safe_usable_capacity = usable_capacity * full_ratio
    local target_pgs = osd_count * 100
    local optimal_pgs = get_nearest_power_of_2(target_pgs)

    print("\n---------------- RESULTS ----------------")
    print(string.format("%-25s : %d", "Total OSDs", osd_count))
    print(string.format("%-25s : %.2f TB", "Individual Disk Capacity", disk_capacity))
    print(string.format("%-25s : %s", "Redundancy Method", redundancy_info))
    print(string.format("%-25s : %.1f%%", "Storage Efficiency", efficiency))
    print("------------------------------------------")
    print(string.format("%-25s : %.2f TB", "Total Raw Capacity", raw_capacity))
    print(string.format("%-25s : %.2f TB", "Total Usable Capacity", usable_capacity))
    print(string.format("%-25s : %.2f TB", "Safe Usable Space (" .. (full_ratio*100) .. "%)", safe_usable_capacity))
    print("------------------------------------------")
    print(string.format("%-25s : %d", "Target PGs (100/OSD)", target_pgs))
    print(string.format("%-25s : %d (Optimal)", "Optimal pg_num", optimal_pgs))
    print("------------------------------------------")
    print("\nPool Creation Command Example:")
    print(string.format("ceph osd pool create <pool_name> %d %d", optimal_pgs, optimal_pgs))
    print("------------------------------------------")
end

calculate()
