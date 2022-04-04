Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
  Projectile.super.new(self, area, x, y, opts)
  
  self.depth = 60
  self.w = 10
  self.h = 2
  self.speed = 200
  
  Projectile.super.handleCollision(self)
end

function Projectile:update(dt)
  Projectile.super.update(self, dt)
  
  local goalX = self.x + self.speed * math.cos(self.angle) * dt
  local goalY = self.y + self.speed * math.sin(self.angle) * dt
  
  self.x = math.max(math.min(gw, goalX), 0)
  self.y = math.max(math.min(gh, goalY), 0)
  
  if goalX< 0 then self:die() end
  if goalX > gw then self:die() end
  if goalY < 0 then self:die() end
  if goalY > gh then self:die() end
end

function Projectile:draw()
  pushRotate(self.x, self.y, self.angle)
  love.graphics.setColor(default_color)
  love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.h/2, self.w, self.h)
  love.graphics.pop()
end

function Projectile:destroy()
  Projectile.super.destroy(self)
end

function Projectile:die()
  self.dead = true
  self.area:addGameObject(
    'ProjectileDeathEffect',
    self.x,
    self.y,
    { w = self.w *0.5}
  )
end