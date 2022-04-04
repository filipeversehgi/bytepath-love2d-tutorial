Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = 12, 12

    Player.super.handleCollision(self)

    self.angle = math.pi / 2
    self.turnSpeed = 1.66 * math.pi
    self.speed = 0
    self.baseMaxSpeed = 75
    self.maxSpeed = self.baseMaxSpeed
    self.acl = 50

    -- BOOST
    self.maxBoost = 100
    self.boost = self.maxBoost
    self.boostMultipier = 1.5
    self.brakeMultiplier = 0.5
    self.boostGainPerSecond = 10
    self.boostConsumtionPerSecond = 50
    self.boosting = false
    self.boostColor = trail_color
    self.canBoost = true
    self.boostTimer = 0
    self.boostCooldown = 2

    self.shootSpeed = 0.25
    self.tickSpeed = 5

    -- HP
    self.maxHp = 100
    self.hp = self.maxHp

    -- Ammo
    self.maxAmmo = 20
    self.ammo = self.maxAmmo

    self.timer:every(self.shootSpeed, function() self:shoot() end)

    self.timer:every(self.tickSpeed, function() self:tick() end)

    self.timer:every(0.008, function() self:spawnFire() end)

    self.timer:every(0.5, function()
        self.area:addGameObject('Ammo', math.random(0, gw), math.random(0, gh))
    end)

    self.polygons = {}

    self.ship = 'Fighter'

    if self.ship == 'Fighter' then

        self.polygons[1] = {
            self.w, 0, -- 1
            self.w / 2, -self.w / 2, -- 2
            -self.w / 2, -self.w / 2, -- 3
            -self.w, 0, -- 4
            -self.w / 2, self.w / 2, -- 5
            self.w / 2, self.w / 2 -- 6
        }

        self.polygons[2] = {
            self.w / 2, -self.w / 2, -- 7
            0, -self.w, -- 8
            -self.w - self.w / 2, -self.w, -- 9
            -3 * self.w / 4, -self.w / 4, -- 10
            -self.w / 2, -self.w / 2 -- 11
        }

        self.polygons[3] = {
            self.w / 2, self.w / 2, -- 12
            -self.w / 2, self.w / 2, -- 13
            -3 * self.w / 4, self.w / 4, -- 14
            -self.w - self.w / 2, self.w, -- 15
            0, self.w -- 16
        }

    end

    if self.ship == 'Arrow' then

        self.polygons[1] = {
            self.w, 0, -- 1
            self.w / 2, -self.w / 2, -- 2
            -self.w, -self.w / 2, -- 3
            -self.w / 2, 0, -- 4
            -self.w, self.w / 2, -- 5
            self.w / 2, self.w / 2 -- 6
        }

        self.polygons[2] = {
            -self.w / 4, -self.w / 2, -- 3
            -self.w / 2 - self.w / 4, 0, -- 4
            -self.w / 4, self.w / 2 -- 5
        }

    end
end

function Player:update(dt)
    Player.super.update(self, dt)

    if self.hp == 0 then
        self:die()
        return
    end

    self.boost = math.min(self.maxBoost,
                          self.boost + self.boostGainPerSecond * dt)
    self.boostTimer = self.boostTimer + dt

    if self.boostTimer > self.boostCooldown then self.canBoost = true end

    if love.keyboard.isDown('left') then
        self.angle = self.angle - self.turnSpeed * dt
    end

    if love.keyboard.isDown('right') then
        self.angle = self.angle + self.turnSpeed * dt
    end

    if love.keyboard.isDown('d') then self:die() end

    self.maxSpeed = self.baseMaxSpeed
    self.boosting = false

    if love.keyboard.isDown('up') and self.boost > 0 and self.canBoost then
        self:boostOrBrake(self.boostMultipier, dt)
    end

    if love.keyboard.isDown('down') and self.boost > 0 and self.canBoost then
        self:boostOrBrake(self.brakeMultiplier, dt)
    end

    self.speed = math.min(self.speed + self.acl * dt, self.maxSpeed)

    self.boostColor = trail_color
    if self.boosting then self.boostColor = boost_color end

    self.x = self.x + self.speed * math.cos(self.angle) * dt
    self.y = self.y + self.speed * math.sin(self.angle) * dt

    local _, _, cols, len = self.area.world:check(self, self.x, self.y)
-- 
    for i = 1, len do
        local other = cols[i].other
        
        if other.type == 'ammo' then
            other:die()
            self.ammo = math.min(self.maxAmmo, self.ammo + other.ammoSize)
        end
    end

end

function Player:boostOrBrake(multiplier, dt)
    self.boosting = true
    self.maxSpeed = multiplier * self.baseMaxSpeed
    self.boost = self.boost - self.boostConsumtionPerSecond * dt

    if self.boost <= 0 then
        self.boosting = false
        self.canBoost = false
        self.boostTimer = 0
    end
end

function Player:draw()

    pushRotate(self.x, self.y, self.angle)

    love.graphics.setColor(default_color)

    for _, polygon in ipairs(self.polygons) do
        local points = {}
        for index, value in ipairs(polygon) do
            if index % 2 == 1 then
                points[index] = self.x + value
            else
                points[index] = self.y + value
            end
        end
        love.graphics.polygon('line', points)
    end

    love.graphics.pop()
end

function Player:shoot()
    if self.ammo == 0 then return end
    local distance = 1.2 * self.w
    self.area:addGameObject('ShootEffect',
                            self.x + distance * math.cos(self.angle),
                            self.y + distance * math.sin(self.angle),
                            {player = self, distance = distance})

    self.area:addGameObject('Projectile',
                            self.x + distance * math.cos(self.angle),
                            self.y + distance * math.sin(self.angle),
                            {angle = self.angle + (math.random(10) - 5) / 50})

    self.ammo = math.max(0, self.ammo - 1)
end

function Player:destroy() Player.super.destroy(self) end

function Player:die()
    self.dead = true
    slow(0.15, 1)
    for i = 1, love.math.random(8, 12) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y)
    end

end

function Player:tick()
    self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end

function Player:spawnFire()
    if self.ship == 'Fighter' then
        local trailX = self.x - self.w * math.cos(self.angle + math.pi / 15)
        local trailY = self.y - self.w * math.sin(self.angle + math.pi / 15)

        local trailX2 = self.x - self.w * math.cos(self.angle - math.pi / 15)
        local trailY2 = self.y - self.w * math.sin(self.angle - math.pi / 15)

        self.area:addGameObject('TrailParticle', trailX, trailY,
                                {color = self.boostColor})

        self.area:addGameObject('TrailParticle', trailX2, trailY2,
                                {color = self.boostColor})

    end

    if self.ship == 'Arrow' then
        local trailX = self.x - self.w * math.cos(self.angle)
        local trailY = self.y - self.w * math.sin(self.angle)

        self.area:addGameObject('TrailParticle', trailX, trailY, {
            color = self.boostColor,
            size = math.random(2, 3.5)
        })

    end
end
