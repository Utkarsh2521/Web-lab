function add(num1, num2)
    return num1 + num2
end

function sub(num1, num2)
    return math.abs(num1 - num2) -- Absolute subtraction
end

function mul(num1, num2)
    return num1 * num2
end

function div(num1, num2)
    if num2 == 0 then
        return "Error: Division by zero"
    end
    return num1 / num2
end

print("Enter first number:")
local num1 = tonumber(io.read()) -- Read first number

print("Enter second number:")
local num2 = tonumber(io.read()) -- Read second number

print("Enter operation (+, -, *, /):")
local op = io.read() -- Read operation

local result
if op == "+" then
    result = add(num1, num2)
elseif op == "-" then
    result = sub(num1, num2)
elseif op == "*" then
    result = mul(num1, num2)
elseif op == "/" then
    result = div(num1, num2)
else
    result = "Invalid operation"
end

print("Result: " .. result)
