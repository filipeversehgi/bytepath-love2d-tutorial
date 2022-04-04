ExplodeParticle = GameObject:extend()

function ExplodeParticle:new(area, x, y, opts) 
  ExplodeParticle.super.new(self, area, x, y, opts)

  self.depth = 100
  self.color = opts.color or default_color
  self.angle = math.random(0, 2 * math.pi)
  self.size = 0
  self.lineWidth = 2
  self.distance = 0
  self.length = math.random(10, 25)
  self.duration = opts.duration or math.random(0.25, 0.5)
  self.timer:tween(self.duration, self, { size = self.length, lineWidth = 0 }, 'out-quad')
  self.timer:tween(self.duration, self, { distance = self.length }, 'linear', function() self.dead = true end)
end

function ExplodeParticle:update(dt)
  ExplodeParticle.super.update(self, dt)
end

function ExplodeParticle:draw()
  pushRotate(self.x, self.y, self.angle)
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.setColor(self.color)
  love.graphics.line(self.x + self.distance, self.y, self.x + self.size, self.y)
  love.graphics.setColor(default_color)
  love.graphics.setLineWidth(1)
  love.graphics.pop()
end

function ExplodeParticle:destroy()
  ExplodeParticle.super.destroy(self)
end

