function love.load()
    -- Player (Mario)
    mario = { x = 50, y = 300, width = 30, height = 30, speed = 120, velocityY = 0, jumpPower = -250 }

    -- Gravity
    gravity = 600
    onGround = false
    gameOver = false

    -- World Settings
    worldScroll = 0
    platformSpacing = 200  -- Increased platform spacing for jumping

    -- Platforms
    platforms = {}
    for i = 0, 5 do
        addPlatform(i * platformSpacing, 380)
    end

    -- Coins
    coins = {}
    for i = 1, 3 do
        addCoin(i * platformSpacing + 50, 320)
    end

    -- Enemies (Goombas) - Random Placement
    goombas = {}
    for i = 1, 3 do
        addGoomba(i * platformSpacing + math.random(50, 100), 350)
    end

    -- Score
    score = 0
end

function love.update(dt)
    if gameOver then return end

    -- Mario movement (Balanced speed)
    if love.keyboard.isDown("right") then
        mario.x = mario.x + mario.speed * dt
        worldScroll = worldScroll - (mario.speed * dt * 0.5)  
    end
    if love.keyboard.isDown("left") and mario.x > 50 then
        mario.x = mario.x - mario.speed * dt
    end

    -- Apply gravity
    mario.velocityY = mario.velocityY + gravity * dt
    mario.y = mario.y + mario.velocityY * dt

    -- Platform Collision
    onGround = false
    for _, platform in ipairs(platforms) do
        platform.x = platform.x + worldScroll
        if checkCollision(mario, platform) then
            mario.y = platform.y - mario.height
            mario.velocityY = 0
            onGround = true
        end
    end

    -- Generate new platforms dynamically
    if platforms[#platforms].x < love.graphics.getWidth() then
        addPlatform(platforms[#platforms].x + platformSpacing, math.random(280, 380))
        if math.random(1, 3) == 1 then
            addGoomba(platforms[#platforms].x + 50, 350)  -- Not every platform has an enemy!
        end
    end

    -- Coin Collection
    for _, coin in ipairs(coins) do
        coin.x = coin.x + worldScroll
        if not coin.collected and checkCollision(mario, { x = coin.x, y = coin.y, width = 20, height = 20 }) then
            coin.collected = true
            score = score + 1
        end
    end

    -- Enemy (Goomba) Movement & Collision
    for _, goomba in ipairs(goombas) do
        goomba.x = goomba.x + goomba.speed * goomba.direction * dt + worldScroll
        if goomba.x <= 0 or goomba.x >= love.graphics.getWidth() then
            goomba.direction = -goomba.direction
        end
        if checkCollision(mario, goomba) then
            gameOver = true
        end
    end

    -- Game Over if Mario falls
    if mario.y > love.graphics.getHeight() + 50 then
        gameOver = true
    end
end

function love.draw()
    if gameOver then
        love.graphics.printf("Game Over! Press R to Restart", 200, 200, 400, "center")
        return
    end

    -- Draw Mario
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", mario.x, mario.y, mario.width, mario.height)

    -- Draw Platforms
    love.graphics.setColor(0.3, 0.6, 1)
    for _, platform in ipairs(platforms) do
        love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
    end

    -- Draw Coins
    love.graphics.setColor(1, 0.9, 0)
    for _, coin in ipairs(coins) do
        if not coin.collected then
            love.graphics.circle("fill", coin.x, coin.y, 10)
        end
    end

    -- Draw Goombas
    love.graphics.setColor(0.6, 0.3, 0)
    for _, goomba in ipairs(goombas) do
        love.graphics.rectangle("fill", goomba.x, goomba.y, goomba.width, goomba.height)
    end

    -- Score Display
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)
end

function love.keypressed(key)
    if key == "space" and onGround then
        mario.velocityY = mario.jumpPower
    elseif key == "r" and gameOver then
        love.load()
    end
end

-- Function to add a new platform
function addPlatform(x, y)
    table.insert(platforms, { x = x, y = y, width = 100, height = 20 })
end

-- Function to add a new coin
function addCoin(x, y)
    table.insert(coins, { x = x, y = y, collected = false })
end

-- Function to add a new enemy (Goomba)
function addGoomba(x, y)
    table.insert(goombas, { x = x, y = y, width = 30, height = 30, speed = 40, direction = -1 })
end

-- Collision detection function
function checkCollision(a, b)
    return a.x < b.x + b.width and a.x + a.width > b.x and a.y + a.height > b.y and a.y < b.y + b.height
end
