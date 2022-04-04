Ammo = GameObject:extend()

function Ammo:new(area, x, y, opts)
    Ammo.super.new(self, area, x, y, opts)
    self.type = 'ammo'

    self.w, self.h = 8, 8
    self.depth = 25

    Ammo.super.handleCollision(self)

    self.angle = math.random(0, 2 * math.pi)
    self.speed = math.random(2, 10)
    self.movingAngle = math.random(0.2 * math.pi)
    self.angleVelocity = math.pi

    self.ammoSize = 25
end

function Ammo:update(dt)
    Ammo.super.update(self, dt)

    local target = current_room.player
    
    local futureX = self.speed * math.cos(self.movingAngle)
    local futureY = self.speed * math.sin(self.movingAngle)
    
    if target then
        local angle = math.atan2(target.y - self.y, target.x - self.x)
        self.movingAngle = angle
    end 

    self.x = self.x + futureX * dt
    self.y = self.y + futureY * dt    
    self.angle = self.angle + self.angleVelocity * dt
end


function Ammo:draw()
    love.graphics.setColor(ammo_color)
    pushRotate(self.x, self.y, self.angle)
    
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)

    love.graphics.pop()
    love.graphics.setColor(default_color)
end

function Ammo:die()
    self.dead = true
    for i = 1, love.math.random(8, 12) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y)
    end
end

function Ammo:destroy()
    Ammo.super.destroy(self)
end