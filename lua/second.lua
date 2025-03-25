--Aim : -- fibonacci series, factorial, and prime number functions

--<Source Code> –
function fibonacci(n)
    if n == 0 then return 0
    elseif n == 1 then return 1
    end
    
    local a, b = 0, 1
    for i = 2, n do
        a, b = b, a + b
    end
    return b
end

function factorial(n)
    if n == 0 then return 1 end
    local result = 1
    for i = 1, n do
        result = result * i
    end
    return result
end

function prime_num(n)
    if n < 2 then return false end
    for i = 2, math.sqrt(n) do
        if n % i == 0 then return false end
    end
    return true
end

function love.draw()
    local num = 10 -- Change this number to test different values

    love.graphics.print("Number: " .. num, 10, 10)
    love.graphics.print("Prime Number: " .. tostring(prime_num(num)), 10, 30)
    love.graphics.print(num .. "th Fibonacci: " .. fibonacci(num), 10, 50)
    love.graphics.print("Factorial: " .. factorial(num), 10, 70)
end
