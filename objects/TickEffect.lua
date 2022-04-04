TickEffect = GameObject:extend()

function TickEffect:new(area, x, y, opts)
    TickEffect.super.new(self, area, x, y, opts)

    self.depth = 75
    self.w, self.h = 48, 32
    self.timer:tween(0.13, self, {h = 0}, 'in-out-cubic',
                     function() self.dead = true end)
    
    self.yOffset = self.h / 2
end

function TickEffect:update(dt)
    TickEffect.super.update(self, dt)

    if self.parent then self.x, self.y = self.parent.x, self.parent.y end
end

function TickEffect:draw()
    love.graphics.rectangle('fill', self.x - self.w / 2, self.y - self.yOffset, self.w, self.h)
end

function TickEffect:destroy() TickEffect.super.destroy(self) end

