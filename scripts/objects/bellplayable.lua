---@class Event.bellplayable : Event
local BellPlayable, super = Class(Event, "BellPlayable")

function BellPlayable:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
	self.mypitch = properties["pitch"] or 1
    self.script = properties["script"]
    self.climb_obstacle = properties["climb"] or false
	self.bellcordlength = properties["length"] or 50
	self.bellcordfadelength = properties["fadewidth"] or 2
	self.sndtoplay = properties["sound"] or "playablebell"
    self:setSprite("world/events/bell_small")
	self.sprite:setOriginExact(9, 2)
	self.sprite.x = 20
	self.fill_tex = Assets.getTexture("bubbles/fill")
	self.gradient_tex = Assets.getTexture("backgrounds/gradient40")
	self.con = 0
	self.timer = 0
	self.rung = 0
	self.canring = properties["interactable"] ~= false
	self:setHitbox(0, 0, 40, 40)
	self.dont_draw_on_tower = true
	if self.climb_obstacle and Game.world.map.cyltower then
		self.visible = false
		self.bellcordlength = properties["length"] or 150
	end
end

function BellPlayable:update()
    super.update(self)
	local collider = Hitbox(self, 0, 0, 40, 40)
	if self.con == 0 then
		self.sprite.rotation = 0
		if Game.world.player:meetsCollider(collider) and Game.world.player:isClimbing() then
			if self.con == 0 then
				self.con = 1
			end
		end
		Object.endCache()
	end
	if self.con == 1 then
		self.rung = self.rung + 1
		Assets.playSound(self.sndtoplay, 1, self.mypitch)
        if self.script then
            Registry.getEventScript(self.script)(self)
        end
		self.con = 2
		self.timer = 0
	end
	if self.con == 2 then
		self.timer = self.timer + DTMULT
		self.sprite.rotation = self.sprite.rotation - math.rad((math.sin(self.timer) * 8) * DTMULT)
		
		if self.timer >= 10 then
			self.con = 0
		end
	end
end

function BellPlayable:onInteract(player)
	if self.con == 0 and self.canring then
		self.con = 1
		return true
	end
	return false
end

function BellPlayable:draw()
	Draw.setColor(ColorUtils.hexToRGB("#B4D6CA"))
    Draw.draw(self.fill_tex, 20, 0, 0, 2, -self.bellcordlength)
    Draw.draw(self.gradient_tex, 20, -self.bellcordlength - (40 * self.bellcordfadelength), 0, 0.05, self.bellcordfadelength)
	Draw.setColor(COLORS.white)
    super.draw(self)
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

function BellPlayable:drawTowerBelow(tower, cull_top, cull_bottom)
    if tower then
		local adjustment = -260
		if tower.appearance == 1 then
			adjustment = -520
		end
		local bell_angle_pos =  MathUtils.lerp(360, 0, (self.x + adjustment) / tower.tower_circumference)
		local bell_angle = bell_angle_pos + tower.tower_angle
		if bell_angle > 360 then
			bell_angle = bell_angle - 360
		elseif bell_angle < 0 then
			bell_angle = bell_angle + 360
		end
		if not (bell_angle > 350 or bell_angle <= 170) then
			local xscale = 2
			local dist_from_tower = 15
			if tower.appearance == 2 then
				dist_from_tower = 45
			end
			local xx = tower.tower_x + MathUtils.lengthDirX(tower.tower_radius + dist_from_tower, -math.rad(bell_angle))
			local factor = math.sin(math.rad(bell_angle))
			Draw.setColor(ColorUtils.mergeColor(ColorUtils.hexToRGB("#B4D6CA"), COLORS.black, MathUtils.clamp(1 - factor, 0, 1)))
			Draw.draw(self.fill_tex, xx, self.y, 0, xscale, -self.bellcordlength)
			Draw.draw(self.gradient_tex, xx, self.y - self.bellcordlength - (40 * self.bellcordfadelength), 0, xscale / 40, self.bellcordfadelength)
			Draw.setColor(ColorUtils.mergeColor(COLORS.white, COLORS.black, MathUtils.clamp(1 - factor, 0, 1)))
			Draw.draw(self.sprite.texture, xx, self.y, self.sprite.rotation, xscale, 2, 9, 2)
		end
    end
end

function BellPlayable:drawTowerAbove(tower, cull_top, cull_bottom)
    if tower then
		local adjustment = -260
		if tower.appearance == 1 then
			adjustment = -520
		end
		local bell_angle_pos =  MathUtils.lerp(360, 0, (self.x + adjustment) / tower.tower_circumference)
		local bell_angle = bell_angle_pos + tower.tower_angle
		if bell_angle > 360 then
			bell_angle = bell_angle - 360
		elseif bell_angle < 0 then
			bell_angle = bell_angle + 360
		end
		if (bell_angle > 350 or bell_angle <= 170) then
			local xscale = 2
			local dist_from_tower = 15
			if tower.appearance == 2 then
				dist_from_tower = 45
			end
			local xx = tower.tower_x + MathUtils.lengthDirX(tower.tower_radius + dist_from_tower, -math.rad(bell_angle))
			local factor = math.sin(math.rad(bell_angle))
			Draw.setColor(ColorUtils.mergeColor(ColorUtils.hexToRGB("#B4D6CA"), COLORS.black, MathUtils.clamp(1 - factor, 0, 1)))
			Draw.draw(self.fill_tex, xx, self.y, 0, xscale, -self.bellcordlength)
			Draw.draw(self.gradient_tex, xx, self.y - self.bellcordlength - (40 * self.bellcordfadelength), 0, xscale / 40, self.bellcordfadelength)
			Draw.setColor(ColorUtils.mergeColor(COLORS.white, COLORS.black, MathUtils.clamp(1 - factor, 0, 1)))
			Draw.draw(self.sprite.texture, xx, self.y, self.sprite.rotation, xscale, 2, 9, 2)
		end
    end
end

return BellPlayable