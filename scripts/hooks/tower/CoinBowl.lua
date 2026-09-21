---@class CoinBowl : CoinBowl
local CoinBowl, super = HookSystem.hookScript(CoinBowl)

function CoinBowl:postLoad()
	if Game.world.map.cyltower then
		self.visible = false
	end
end

function CoinBowl:spawnCoinText()
    local world_x, world_y = self:getRelativePos(20, 20, Game.world)

    local text = Game.world:addChild(Text(string.format("+%s", self.value), world_x, world_y, {
        font = "goldnumbers",
        auto_size = true
    }))

    text:setOrigin(0.5)
    text:setPhysics({
        speed_y = -4,
        friction = 0.25
    })

	if Game.world.map.cyltower then
		text.x_offset = font:getWidth(string.format("+%s", self.value))/2
		text.visible = false
		text.onrotatingtower = true
	end
	
    if Game.world.player ~= nil then
        text:setLayer(Game.world.player.layer + 1)
    end

    self.timer:after(1, function()
        text:remove()
    end)
end

function CoinBowl:drawTowerBelow(tower, cull_top, cull_bottom)
    if tower then
		local adjustment = -260
		if tower.appearance == 1 then
			adjustment = -520
		end
		local coin_angle_pos =  MathUtils.lerp(360, 0, (self.x + adjustment) / tower.tower_circumference)
		local coin_angle = coin_angle_pos + tower.tower_angle
		if coin_angle > 360 then
			coin_angle = coin_angle - 360
		elseif coin_angle < 0 then
			coin_angle = coin_angle + 360
		end
		if not (coin_angle > 350 or coin_angle <= 170) then
			local dist_from_tower = 15
			if tower.appearance == 2 then
				dist_from_tower = 45
			end
			local sprite

			if self.value > 5 then
				sprite = Assets.getFramesOrTexture("world/events/coinbowl/gold_coin")
			else
				sprite = Assets.getFramesOrTexture("world/events/coinbowl/silver_coin")
			end

			local texture = sprite[math.floor((self.siner / 4) % #sprite) + 1]

			local texture_x = tower.tower_x + MathUtils.lengthDirX(tower.tower_radius + dist_from_tower, -math.rad(coin_angle)) + 20 - (math.floor(texture:getWidth() / 2) * 2)
			local texture_y = self.y + 30 - (math.floor(texture:getHeight() / 2) * 2) + math.sin(self.siner / 20) * 4
			local factor = math.sin(math.rad(coin_angle))
			Draw.setColor(ColorUtils.mergeColor(COLORS.white, COLORS.black, MathUtils.clamp(1 - factor, 0, 1)))
			if self.state == "IDLE" then
				Draw.draw(texture, texture_x, texture_y, 0, 2)
			end
		end
    end
end

function CoinBowl:drawTower(tower, cull_top, cull_bottom)
    if tower then
		local adjustment = -260
		if self.appearance == 1 then
			adjustment = -520
		end
		local tile_angle = MathUtils.lerp(360, 0, (event.x + 20 + adjustment) / self.tower_circumference)
		local tile_angle1 = tile_angle + self.tower_angle
		while tile_angle1 > 360 do
			tile_angle1 = tile_angle1 - 360
		end
		if tile_angle1 < 0 then
			tile_angle1 = tile_angle1 + 360
		end
		if not (tile_angle1 > 350 or tile_angle1 <= 170) then
			-- end here
		else
			local tile_x = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle1))
			local tile_angle2 = tile_angle1 + self.tile_angle_difference
			if tile_angle2 > 360 then
				tile_angle2 = tile_angle2 - 360
			elseif tile_angle2 < 0 then
				tile_angle2 = tile_angle2 + 360
			end
			local tile_xscale = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle2)) - tile_x
			local tile_yscale = self.tile_height_fine
			tile_xscale = tile_xscale / self.tile_width_fine
			tile_yscale = tile_yscale / self.tile_height_fine
			local brightcol = ColorUtils.mergeColor(COLORS.white, COLORS.gray, math.abs(tile_x + (tile_xscale / 2)) / 190)
			local darkcol = ColorUtils.mergeColor(COLORS.gray, COLORS.dkgray, math.abs(tile_x + (tile_xscale / 2)) / 190)
			local tile_color = ColorUtils.mergeColor(brightcol, darkcol, self.bowl_frame / 15)
			local sinamt = math.sin(self.siner / 20) * 6 * MathUtils.clamp(1 - (self.bowl_frame / 7), 0, 1)
			local sprite = Assets.getFramesOrTexture("world/events/coinbowl/bowl")
			local texture = sprite[math.floor(self.bowl_frame % #sprite) + 1]
			Draw.setColor(tile_color)
			Draw.draw(texture, self.tower_x + event.graphics.shake_x + tile_x, event.y + 10 + event.graphics.shake_y - sinamt, 0, tile_xscale * 2, tile_yscale * 2)
			love.graphics.setColor(COLORS.white)
		end
    end
end

function CoinBowl:drawTowerAbove(tower, cull_top, cull_bottom)
    if tower then
		local adjustment = -260
		if self.appearance == 1 then
			adjustment = -520
		end
		local coin_angle_pos =  MathUtils.lerp(360, 0, (event.x + adjustment) / self.tower_circumference)
		local coin_angle = coin_angle_pos + self.tower_angle
		if coin_angle > 360 then
			coin_angle = coin_angle - 360
		elseif coin_angle < 0 then
			coin_angle = coin_angle + 360
		end
		if (coin_angle > 350 or coin_angle <= 170) then
			local dist_from_tower = 15
			if tower.appearance == 2 then
				dist_from_tower = 45
			end
			local sprite

			if self.value > 5 then
				sprite = Assets.getFramesOrTexture("world/events/coinbowl/gold_coin")
			else
				sprite = Assets.getFramesOrTexture("world/events/coinbowl/silver_coin")
			end

			local texture = sprite[math.floor((self.siner / 4) % #sprite) + 1]

			local texture_x = tower.tower_x + MathUtils.lengthDirX(tower.tower_radius + dist_from_tower, -math.rad(angle)) + 20 - (math.floor(texture:getWidth() / 2) * 2)
			local texture_y = self.y + 30 - (math.floor(texture:getHeight() / 2) * 2) + math.sin(self.siner / 20) * 4
			local factor = math.sin(math.rad(angle))
			Draw.setColor(ColorUtils.mergeColor(COLORS.white, COLORS.black, MathUtils.clamp(1 - factor, 0, 1)))
			if self.state == "IDLE" then
				Draw.draw(texture, texture_x, texture_y, 0, 2)
			end
		end
    end
end

return CoinBowl