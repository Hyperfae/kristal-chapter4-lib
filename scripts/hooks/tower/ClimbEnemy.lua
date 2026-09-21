---@class FallingClimbArea : FallingClimbArea
local ClimbEnemy, super = HookSystem.hookScript(ClimbEnemy)

function ClimbEnemy:init(x, y, texture)
    super.init(self, x, y, texture)
	if Game.world.map.cyltower then
		self.visible = false
	end
end

function ClimbEnemy:drawTower(tower, cull_top, cull_bottom)
    if tower then
		local adjustment = -260
		if tower.appearance == 1 then
			adjustment = -520
		end
		local tile_angle = MathUtils.lerp(360, 0, (self.x + adjustment) / tower.tower_circumference)
		local tile_angle1 = tile_angle + tower.tower_angle
		while tile_angle1 > 360 do
			tile_angle1 = tile_angle1 - 360
		end
		if tile_angle1 < 0 then
			tile_angle1 = tile_angle1 + 360
		end
		if not (tile_angle1 > 350 or tile_angle1 <= 170) then
			-- end here
		else
			local tile_x = MathUtils.lengthDirX(tower.tower_radius, -math.rad(tile_angle1))
			local tile_angle2 = tile_angle1 + tower.tile_angle_difference
			if tile_angle2 > 360 then
				tile_angle2 = tile_angle2 - 360
			elseif tile_angle2 < 0 then
				tile_angle2 = tile_angle2 + 360
			end
			local tile_xscale = MathUtils.lengthDirX(tower.tower_radius, -math.rad(tile_angle2)) - tile_x
			local tile_yscale = tower.tile_height_fine
			tile_xscale = tile_xscale / tower.tile_width_fine
			tile_yscale = tile_yscale / tower.tile_height_fine
			local tile_color = ColorUtils.mergeColor(COLORS.white, COLORS.gray, math.abs(tile_x + (tile_xscale / 2)) / 190)
			local self_canvas = Draw.pushCanvas(self.sprite.width, self.sprite.height)
			Draw.setColor(1,1,1,self.alpha)
			Draw.draw(self.sprite.texture, self.sprite.width/2, self.sprite.height/2, -self.sprite.rotation, 1, 1, self.sprite.width/2, self.sprite.height/2)
			Draw.popCanvas()
			Draw.setColor(tile_color)
			Draw.drawCanvas(self_canvas, tower.tower_x + self.graphics.shake_x + tile_x, self.y + self.graphics.shake_y - 20, 0, tile_xscale, tile_yscale, ox, oy)
		end
    end
end

return ClimbEnemy