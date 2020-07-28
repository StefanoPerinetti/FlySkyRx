local WGTNAME = "FlySkyRx" -- max 9 characters

--[[
HISTORY
=======
Author Stefano Perinetti http://www.slweb.it
2020-07-20  v0.0.1 	First release


DESCRIPTION
===========
Displays basic telemetry info of FlySky Rx.

REQUIREMENTS
============
Transmitter with colour screen (X10, X12, T16 etc.)
OpenTX v 2.2 or later

INSTRUCTIONS
============
ToDo


DISCLAIMER
==========
PLEASE USE AT YOUR OWN RISK! TEST BEFORE FLY
--]]


-- ========= LOCAL VARIABLES =============

-- options table
local defaultOptions = {
    {"textColor", COLOR, DARKGREY},
	}

local colorFlags
local bg_image

-- fonts
local fontSize = {[SMLSIZE]=12, [MIDSIZE]=14, [0]=18}

-- ========= S T A R T   O F   F U N C T I O N S =============


--[[
==================================================
FUNCTION: create
Called by OpenTX to create the widget
==================================================
--]]

local function create(zone, options)

	 -- colors
  lcd.setColor (CUSTOM_COLOR, options.textColor)
  lcd.setColor (TEXT_COLOR, options.textColor)
  
 
  if zone.w >= 400 then
    bg_image = Bitmap.open('/WIDGETS/FlySkyRx/bg_460.png')
  else
    bg_image = Bitmap.open('/WIDGETS/FlySkyRx/bg_390.png')
  end
  
	return {zone=zone, options=options, bg_image=bg_image}
end


--[[
==================================================
FUNCTION: update
Called by OpenTX on registration and at
change of settings
==================================================
--]]
local function update(wgt, newOptions)
    wgt.options = newOptions
end

--[[
==================================================
FUNCTION: background
Periodically called by OpenTX
==================================================
--]]
local function background(wgt)
  --work when widget is hiden, do nothing
end

--[[
FUNCTION: drawBackground
Draw the bacground image on the screen
bg_image is a pointer of image open with Bitmap.open function
x ad y are the top left position for start draw
--]]
local function drawBackground (bg_image, x,y)
  lcd.drawBitmap(bg_image, x, y)
end

--[[
FUNCTION: drawTDataRxBattery
collect data battery from reciver telemetry and display them on screen
Min      Current    Max
0.00V    0.00 V     0.00V

x -> start x position
y -> start y position
xOffset ->  x offeset from two value
font -> fontSize
--]]
local function drawTDataRxBattery (x,y,xOffset,font)
  --Rx battery
	local valcurrent
  local valMax
  local valMin
  --Get values
	valCurrent = getValue('Rx-V')
  valMax = getValue('Rx-V+')
  valMin = getValue('Rx-V-')
  --Draw values
  lcd.drawText (x , y, (valMin and valMin >0)  and string.format ("%.2f", valMin) .. ' V' or '0.00 V', font  + colorFlags)
  lcd.drawText (x + xOffset , y, (valCurrent and valCurrent >0)  and string.format ("%.2f", valCurrent) .. ' V'  or '0.00 V', font  + colorFlags)
  lcd.drawText (x + xOffset + xOffset , y, (valMax and valMax >0)  and string.format ("%.2f", valMax) .. ' V'  or '0.00 V', font  + colorFlags)
	
end

--[[
FUNCTION: drawTDataRSSI
collect RSSI data from reciver telemetry and display them on screen
Reciver Signal Stright Index
Min      Current    Max
-00 Db   -00 Db    -00 Db

x -> start x position
y -> start y position
xOffset ->  x offeset from two value
font -> fontSize
--]]
local function drawTDataRSSI(x,y,xOffset,font)
  --Rx battery
	local valcurrent
  local valMax
  local valMin
  --Get values
	valCurrent = getValue('RSSI')
  valMax = getValue('RSSI+')
  valMin = getValue('RSSI-')
  --Draw values
  lcd.drawText (x , y, (valMin and valMin~=0)  and valMin .. ' Db' or '-00 Db', font  + colorFlags)
  lcd.drawText (x + xOffset , y, (valCurrent and valCurrent ~=0)  and  valCurrent .. ' Db'  or '-00 Db', font  + colorFlags)
  lcd.drawText (x + xOffset + xOffset , y, (valMax and valMax ~=0)  and valMax .. ' Db'  or '-00 Db', font  + colorFlags)
	
end
--[[
FUNCTION: drawTDataRQly
collect RSSI data from reciver telemetry and display them on screen
Reciver Signal Stright Index
Min      Current    Max
-00 Db   -00 Db    -00 Db

x -> start x position
y -> start y position
xOffset ->  x offeset from two value
font -> fontSize
--]]
local function drawTDataRQly(x,y,xOffset,font)
  --Rx battery
	local valcurrent
  local valMax
  local valMin
  --Get values
	valCurrent = getValue('RQly')
  valMax = getValue('RQly+')
  valMin = getValue('RQly-')
  --Draw values
  lcd.drawText (x , y, (valMin and valMin >0)  and string.format ("%.d", valMin) .. ' %' or '000 %', font  + colorFlags)
  lcd.drawText (x + xOffset , y, (valCurrent and valCurrent >0)  and string.format ("%.d", valCurrent) .. ' %'  or '000 %', font  + colorFlags)
  lcd.drawText (x + xOffset + xOffset , y, (valMax and valMax >0)  and string.format ("%.d", valMax) .. ' %'  or '000 %', font  + colorFlags)
	
end
--[[
FUNCTION: drawTDataRSNR
collect RSSI data from reciver telemetry and display them on screen
Reciver Signal Stright Index
Min      Current    Max
-00 Db   -00 Db    -00 Db

x -> start x position
y -> start y position
xOffset ->  x offeset from two value
font -> fontSize
--]]
local function drawTDataRSNR(x,y,xOffset,font)
  --Rx battery
	local valcurrent
  local valMax
  local valMin
  --Get values
	valCurrent = getValue('RSNR')
  valMax = getValue('RSNR+')
  valMin = getValue('RSNR-')
  --Draw values
  lcd.drawText (x , y, (valMin and valMin >0)  and  valMin .. ' Db' or '000 Db', font  + colorFlags)
  lcd.drawText (x + xOffset , y, (valCurrent and valCurrent >0)  and valCurrent .. ' Db'  or '000 Db', font  + colorFlags)
  lcd.drawText (x + xOffset + xOffset , y, (valMax and valMax >0)  and  valMax .. ' Db'  or '000 Db', font  + colorFlags)
	
end
--[[
==================================================
FUNCTION: refresh
Called by OpenTX when the Widget is being displayed
==================================================
--]]
local function refresh(wgt)
	colorFlags = TEXT_COLOR
  -- render

	if wgt.zone.w >= 400 and wgt.zone.h >= 200  then
    --Draw result for zone full width without bottom bar, sliders and trims 460x207
    drawBackground (bg_image, wgt.zone.x, wgt.zone.y)
    drawTDataRxBattery (wgt.zone.x + 20, wgt.zone.y + 90, 75, 0)
    drawTDataRSSI(wgt.zone.x + 245, wgt.zone.y + 90, 72, 0)
    drawTDataRQly (wgt.zone.x + 20, wgt.zone.y + 168, 75, 0)
    drawTDataRSNR(wgt.zone.x + 245, wgt.zone.y + 168, 72, 0)
	elseif wgt.zone.w >= 390 and wgt.zone.h >= 172  then
    -- Draw result for zone full with bottom bar, sliders and trims
		drawBackground (bg_image, wgt.zone.x, wgt.zone.y)
    drawTDataRxBattery (wgt.zone.x + 15, wgt.zone.y + 80, 62, SMLSIZE)
    drawTDataRSSI(wgt.zone.x + 205, wgt.zone.y + 80, 60, SMLSIZE)
    drawTDataRQly (wgt.zone.x + 15, wgt.zone.y + 145, 63, SMLSIZE)
    drawTDataRSNR(wgt.zone.x + 205, wgt.zone.y + 145, 60, SMLSIZE)
  else
    --to do, next zone is 1/2 screen
	end
end

return { name=WGTNAME, options=defaultOptions, create=create, update=update, refresh=refresh, background=background }
