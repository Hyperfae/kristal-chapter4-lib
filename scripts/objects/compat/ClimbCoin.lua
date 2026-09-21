---@class ClimbCoin : CoinBowl
local ClimbCoin, super = Class(CoinBowl)

---@param x number?
---@param y number?
---@param settings CoinBowlSettings?
function ClimbCoin:init(x, y, settings)
    super.init(self, x, y, settings)
    Ch4Lib.logger:warnNotify("Replace ClimbCoin with CoinBowl!")
end

return ClimbCoin
