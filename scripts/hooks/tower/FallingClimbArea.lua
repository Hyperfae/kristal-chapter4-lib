---@class FallingClimbArea : FallingClimbArea
local FallingClimbArea, super = HookSystem.hookScript(FallingClimbArea)

function FallingClimbArea:init(x, y, settings)
    super.init(self, x, y, settings)
	if Game.world.map.tower then
		self.visible = false
	end
end

function FallingClimbArea:draw()
    if Game.world.map.cyltower then
        local tower = Game.world.map.cyltower

        love.graphics.push()
        love.graphics.origin()
        love.graphics.translate(-(Game.world.camera.x - SCREEN_WIDTH/2), -(Game.world.camera.y - SCREEN_HEIGHT/2))

        local tilex = math.floor(self.x / tower.tile_width_fine) + 1
        if tilex >= tower.horizontaltilecount then
            tilex = tilex - tower.horizontaltilecount
        end
        if tilex <= 0 then
            tilex = tilex + tower.horizontaltilecount
        end
        local tile = tower.tile_data[tower.tm_tileset[1]][tilex]
        if tile.vis == 1 then
            Draw.setColor(tile.color)
			if self.tile then
				local tile_width, tile_height = self.tileset:getTileSize(self.tileset:getDrawTile(self.tile))
				local sx = self.width / tile_width * (self.tile_flip_x and -1 or 1)
				local sy = self.height / tile_height * (self.tile_flip_y and -1 or 1)
				if self.tileset.preserve_aspect_fit then
					sx = MathUtils.absMin(sx, sy)
					sy = sx
				end
				self.tile.tileset:drawTile(self.tile.tile, tower.tower_x + tile.x + self.width/2, self.y + (tower.tile_height_fine / 4) + self.height/2, 0, ((tile.xscale * 2) / tower.tile_width_fine), 2, tile_width/2, tile_height/2)
			elseif self.sprite then
				Draw.draw(self.sprite:getTexture(), tower.tower_x + tile.x, self.y + (tower.tile_height_fine / 4), 0, ((tile.xscale * 2) / tower.tile_width_fine), 2, 2, 2)
			end
        end

        love.graphics.pop()
    else
        super.draw(self)
    end
end

return FallingClimbArea