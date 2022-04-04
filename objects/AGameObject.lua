GameObject = Object:extend()

function GameObject:new(area, x, y, opts)

  local opts = opts or {}
  if opts then for k, v in pairs(opts) do self[k] = v end end
  
  self.area = area
  self.x, self.y = x, y
  self.id = UUID()
  self.dead = false
  self.timer = Timer.new()
  self.handleCollision = false
  self.depth = 50
  self.type = ''

  globalObjectOrder = globalObjectOrder + 1 
  self.creationTime = globalObjectOrder
end

function GameObject:update(dt)
  if self.timer then self.timer:update(dt) end
  
  if self.handleCollision then
    self.area.world:update(self, self.x, self.y)
  end
end

function GameObject:draw()
end

function GameObject:handleCollision()
  self.area.world:add(self, self.x, self.y, self.w, self.h)
  self.handleCollision = true
end

function GameObject:destroy()
  Timer.cancel(self.timer)

  if self.handleCollision == true then 
    self.area.world:remove(self)
  end
end
