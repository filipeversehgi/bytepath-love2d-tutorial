TrailParticle = GameObject:extend()

function TrailParticle:new(area, x, y, opts)
    TrailParticle.super.new(self, area, x, y, opts)

    self.size = opts.size or math.random(1, 2.5)
    self.duration = 0.25
    self.color = opts.color or trail_color
    
    self.timer:tween(self.duration, self, { size = 0 }, 'in-out-cubic', function ()
        self.dead = true
    end)
end

function TrailParticle:update(dt)
    TrailParticle.super.update(self, dt)
end

function TrailParticle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.size)
    love.graphics.setColor(default_color)
end

function TrailParticle:destroy() TrailParticle.super.destroy(self) end

