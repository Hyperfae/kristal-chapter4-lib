---@class FallingClimbArea : FallingClimbArea
local FallingClimbArea, super = HookSystem.hookScript(FallingClimbArea)

function FallingClimbArea:init(x, y, settings)
    super.init(self, x, y, settings)
	self.tile = nil
end

function FallingClimbArea:applyTileObject(data, map)
    local tile = map:createTileObject(data, 0, 0, self.width, self.height)
    tile.debug_select = false

    local ox, oy = tile:getOrigin()
    self:setOrigin(ox, oy)

    tile:setPosition(ox * self.width, oy * self.height)

    if Game.world.map.cyltower then
		tile.visible = false
	end
	self.tile = tile
    self:addChild(tile)
end

function FallingClimbArea:drawTower(tower, cull_top, cull_bottom)
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
			if self.tile then
				local tile_width, tile_height = self.tile.tileset:getTileSize(self.tile.tileset:getDrawTile(self.tile.tile))
				local sx = self.tile.width / tile_width * (self.tile.tile_flip_x and -1 or 1)
				local sy = self.tile.height / tile_height * (self.tile.tile_flip_y and -1 or 1)
				if self.tile.tileset.preserve_aspect_fit then
					sx = MathUtils.absMin(sx, sy)
					sy = sx
				end
				self.tile.tileset:drawTile(self.tile.tile, tower.tower_x + tile_x + self.tile.width/2, self.y + 10 + self.tile.height/2, 0, tile_xscale * 2, tile_yscale * 2, tile_width/2, tile_height/2)
			elseif self.sprite then
				Draw.draw(self.sprite:getTexture(), tower.tower_x + tile.x, self.y + 10, 0, tile_xscale * 2, tile_yscale * 2, 2, 2)
			end
		end
    end
end

return FallingClimbArea