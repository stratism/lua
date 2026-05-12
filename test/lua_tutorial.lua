-- Lua Comprehensive Tutorial
-- This script covers basic syntax, tables, functions, control flow, and metatables.

---------------------------------------------------------
-- 1. BASIC SYNTAX & VARIABLES
---------------------------------------------------------
-- Single-line comment
--[[
    Multi-line
    comment block
--]]

local name = "Gemini CLI"  -- Use 'local' to keep variables scoped to this file/block
local version = 1.0
local is_learning = true

print("--- 1. Basic Syntax ---")
print("Greeting: Hello, I am " .. name) -- '..' is the concatenation operator
print("Version: " .. version)
print("")

---------------------------------------------------------
-- 2. TABLES (The Only Data Structure)
---------------------------------------------------------
print("--- 2. Tables ---")

-- Array-style (Note: Lua uses 1-based indexing!)
local fruits = {"Apple", "Banana", "Cherry"}
print("First fruit: " .. fruits[1])

-- Dictionary-style (Key-Value pairs)
local player = {
    name = "Stratos",
    health = 100,
    inventory = {"Sword", "Shield"}
}
print("Player Name: " .. player.name)
print("Player Health: " .. player["health"])
print("")

---------------------------------------------------------
-- 3. FUNCTIONS
---------------------------------------------------------
print("--- 3. Functions ---")

-- A standard named function
local function calculate_damage(base, multiplier)
    return base * multiplier
end

-- An anonymous function stored in a variable
local greet = function(target)
    return "Hello, " .. target .. "!"
end

print(greet(player.name))
local damage = calculate_damage(10, 2.5)
print("Calculated Damage: " .. damage)
print("")

---------------------------------------------------------
-- 4. CONTROL FLOW
---------------------------------------------------------
print("--- 4. Control Flow ---")

-- If-Else statements
if player.health > 50 then
    print("Status: Feeling Great")
elseif player.health > 0 then
    print("Status: Injured")
else
    print("Status: Game Over")
end

-- Numeric For-loop (start, end, step)
print("Counting to 3:")
for i = 1, 3 do
    print("  Step " .. i)
end

-- Generic For-loop (iterating over a table)
print("Player Data:")
for key, value in pairs(player) do
    -- Note: value could be a table (like inventory), so we check type
    if type(value) ~= "table" then
        print("  " .. key .. ": " .. tostring(value))
    end
end
print("")

---------------------------------------------------------
-- 5. METATABLES (Advanced / OOP)
---------------------------------------------------------
print("--- 5. Metatables ---")

-- Create tables representing Vectors
local vec1 = { x = 10, y = 20 }
local vec2 = { x = 5,  y = 5  }

-- Define a metatable with metamethods
-- __add: Overloads the '+' operator
-- __tostring: Controls how the table is printed
local vector_mt = {
    __add = function(v1, v2)
        local res = { x = v1.x + v2.x, y = v1.y + v2.y }
        setmetatable(res, getmetatable(v1)) -- Inherit the same metatable
        return res
    end,
    __tostring = function(v)
        return "Vector(" .. v.x .. ", " .. v.y .. ")"
    end
}

-- Attach the metatable to our vectors
setmetatable(vec1, vector_mt)
setmetatable(vec2, vector_mt)

-- Now we can use the '+' operator on tables!
local result = vec1 + vec2
print("vec1: " .. tostring(vec1))
print("vec2: " .. tostring(vec2))
print("vec1 + vec2 = " .. tostring(result))
print("")

---------------------------------------------------------
-- 6. SYSTEM COMMANDS
---------------------------------------------------------
print("--- 6. System Commands ---")

-- os.execute: Best for running a command without needing the output.
-- Returns: success (bool), exit_reason (string), exit_code (number)
print("Creating a temporary directory...")
local success, reason, code = os.execute("mkdir -p temp_lua_test")
if success then
    print("  Folder created successfully.")
end

-- io.popen: Best for capturing the output of a command.
print("Listing files in current directory:")
local handle = io.popen("ls -F | head -n 5")
if handle then
    local result = handle:read("*a")
    handle:close()
    print(result)
end

-- Cleaning up
os.execute("rmdir temp_lua_test")
print("")

print("Tutorial Complete! Happy coding in Lua.")
