ProjectileDeathEffect = GameObject:extend()

function ProjectileDeathEffect:new(area, x, y, opts)
  ProjectileDeathEffect.super.new(self, area, x, y, opts)
  self.timer:tween(0.2, self, { w = 0 }, 'in-out-cubic', function() self.dead = true end)
end

function ProjectileDeathEffect:update(dt)
  ProjectileDeathEffect.super.update(self, dt)
end

function ProjectileDeathEffect:draw()
  pushRotate(self.x, self.y, self.angle)
  love.graphics.setColor(hp_color)
  love.graphics.circle('fill', self.x, self.y, self.w)
  love.graphics.pop()
end


function ProjectileDeathEffect:destroy()
  ProjectileDeathEffect.super.destroy(self)
end

