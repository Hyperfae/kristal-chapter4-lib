---@class FallingClimbArea : FallingClimbArea
local ClimbMover, super = HookSystem.hookScript(ClimbMover)

function ClimbMover:init(x, y, shape, settings)
    super.init(self, x, y, shape, settings)
	if Game.world.map.cyltower then
		self.visible = false
	end
end

function ClimbMover:drawTower(tower, cull_top, cull_bottom)
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
			Draw.setColor(tile_color)
			Draw.draw(self.sprite.texture, tower.tower_x + self.graphics.shake_x + tile_x, self.y + self.graphics.shake_y - 20, 0, tile_xscale, tile_yscale, ox, oy)
		end
    end
end

return FallingClimbArea