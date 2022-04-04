Object = require 'libraries/classic/classic'
autoRequire = require 'libraries/auto-require/auto-require'
Timer = require 'libraries/hump/timer'
Camera = require 'libraries/hump/camera'
require 'libraries/uuid/uuid'
Bump = require 'libraries/bump/bump'
TypeCount = require 'libraries/count/count'
require 'globals'

function collect()
    print("Before collection: " .. collectgarbage("count") / 1024)
    collectgarbage()
    print("After collection: " .. collectgarbage("count") / 1024)
    print("Object count: ")
    local counts = type_count()
    for k, v in pairs(counts) do print(k, v) end
    print("-------------------------------------")
end

function love.load()
    autoRequire({'objects', 'rooms'})

    globalObjectOrder = 0
    slowAmount = 1
    timer = Timer.new()
    camera = Camera()
    current_room = nil

    goToRoom('Stage')
    love.graphics.setBackgroundColor(background_color)
end

function love.update(dt)
    timer:update(dt * slowAmount)
    if current_room then 
        current_room:update(dt * slowAmount) 
    end 
end

function love.draw() 
    if current_room then 
        current_room:draw() 
    end end

function goToRoom(room_type, ...)
    if current_room and current_room.destroy then current_room.destroy() end
    current_room = _G[room_type](...)
end

function pushRotate(x, y, r)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.translate(-x, -y)
end

function slow(amount, duration)
    slowAmount = amount
    timer:tween(duration, _G, {slowAmount = 1}, 'in-out-cubic')
end