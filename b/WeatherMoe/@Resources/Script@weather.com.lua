--20200229
function Initialize()
	-- global variable
	-- 11644473600(seconds) = 1970-01-01T00:00:00(UNIX Time) - 1601-01-01T00:00:00(Windows Filetime)
	time_delta = 11644473600 + get_timezone()

	local ln = SKIN:GetVariable('LOCALE_NAME', '')
	if(''==ln) then SKIN:Bang('!EnableMeasure', 'msRegLocaleName') end

	if(''~=ln) then
		if(''==SKIN:GetVariable('GEO_COORDINATES', ''))then
			SKIN:Bang('!SetOption', 'msWebParser', 'URL', 'https://weather.com/#LOCALE_NAME#/weather/today/')
		end
		SKIN:Bang('!EnableMeasure', 'msWebParser')
	else
		-- 1st time to load the skin.
		SKIN:Bang('!EditSkin')
	end

	Lock_Icon(tonumber(SKIN:GetVariable('LOCK_ICON',0)))
end

function Update_Tooltip(ico, ttl, txt)
	SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipIcon', ico)
	SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipText', txt)
	SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipTitle', ttl)
	SKIN:Bang('!UpdateMeter', 'mtIcon0')
	SKIN:Bang('!Redraw')
end

function Update_Current_Data()
	local rd = SKIN:GetMeasure('msWebParser'):GetStringValue()
	if(string.find(string.lower(string.sub(rd, 1, 16)), 'page')) then
		SKIN:Bang('!SetOption', 'msIconName', 'SubStitute', '#SS_ICON_NAME#')
		SKIN:Bang('!SetOption', 'msIconName', 'RegExpSubstitute', 1)
		SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipIcon', 'Info')
		SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipText', '[#TOOLTIP_TEXT]')
		SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipTitle', '[#TOOLTIP_TITLE]')
		SKIN:Bang('!SetOptionGroup', 'grResults', 'DynamicVariables', 1)
		SKIN:Bang('!EnableMeasureGroup', 'grResults')
		SKIN:Bang('!UpdateMeasureGroup', 'grResults')
	else
		SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipIcon', 'Error')
		SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipText', '#CRLF#JSON data "page" not found.')
		SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipTitle', 'JSON')
		SKIN:Bang('!DisableMeasure', 'msWebParser')
	end
	SKIN:Bang('!SetOptionGroup', 'grContents', 'DynamicVariables', 1)
	SKIN:Bang('!UpdateMeterGroup', 'grContents')
	SKIN:Bang('!Redraw')	
end

function Setup_Current_Tooltip()
	local tx = '[msCR_ctxt]'
	if('0'~=SKIN:GetVariable('SHOW_TEMPERATURE','1')) then tx = tx..'[#CURRENT_CONDITIONS_DATA_TEMPERATURE]' end
	if('0'~=SKIN:GetVariable('SHOW_RAIN','1')) then tx = tx..'[#CURRENT_CONDITIONS_DATA_RAIN]' end
	if('0'~=SKIN:GetVariable('SHOW_DETAILS','1')) then tx = tx..'[#CURRENT_CONDITIONS_DATA_DETAILS]' end
	if('0'~=SKIN:GetVariable('SHOW_SUN','0')) then tx = tx..'[#CURRENT_CONDITIONS_DATA_SUN]' end
	if('0'~=SKIN:GetVariable('SHOW_MOON','0')) then tx = tx..'[#DAILY_FORECAST_DATA_MOON]' end
	if('0'~=SKIN:GetVariable('SHOW_AIRQUALITY','0')) then tx = tx..'[#AIRQUALITY_DATA]' end
	if('0'~=SKIN:GetVariable('SHOW_POLLEN','0')) then tx = tx..'[#POLLEN_DATA]' end
	if('0'~=SKIN:GetVariable('SHOW_SICKW','0')) then tx = tx..'[#SICKW_DATA]' end
	if('0'~=SKIN:GetVariable('SHOW_LOCATION','1')) then tx = tx..'[#LOCATION_DATA]' end
	tx = tx..'#CRLF##CRLF#[#CURRENT_CONDITIONS]#CRLF#[#CURRENT_CONDITIONS_DATE]'
	SKIN:Bang('!SetVariable', 'TOOLTIP_TEXT', tx)
end

function Lock_Icon(i)
	if(1==i) then
		SKIN:Bang('!DisableMouseAction', 'mtIcon0', 'MouseScrollDownAction|MouseScrollUpAction')
		SKIN:Bang('!Draggable', 0)
	else
		SKIN:Bang('!EnableMouseAction', 'mtIcon0', 'MouseScrollDownAction|MouseScrollUpAction')
		SKIN:Bang('!Draggable', 1)
	end
end

function Local_Time_Num(n)
	n = tonumber(n)
	return (nil~=n) and (n + time_delta) or 0
end

function H24_Time(n)
	n = tonumber(n)
	return (nil~=n) and os.date('%H:%M', (n)) or '00:00'
end

function Percent_Num(n)
	n = tonumber(n)
	return (nil~=n and 0<=n and n<=1) and n*100 or 0
end

-- km/h to m/s in Phrase, not strict
function Phrase_k2m(s)
	return string.gsub(s,'%d+',function(a)return Math_Round(tonumber(a)*5/18, 0) end)
end

-- http://xn--pckzexbx21r8q9b.net/lua_tips/?Lua+implements_func_math
function Math_Round(num, idp)
    if idp and idp>0 then
        local mult = 10^idp
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

-- http://lua-users.org/wiki/TimeZone
-- Compute the difference in seconds between local time and UTC.
function get_timezone()
  local now = os.time()
  return os.difftime(now, os.time(os.date("!*t", now)))
end

-- https://docs.rainmeter.net/snippets/clamp/
function clamp_num(num, lower, upper)
	return math.max(lower, math.min(upper, num))
end

-- returns distance in km or mi | https://rosettacode.org/wiki/Haversine_formula#Lua
-- x1: latitude1, y1: longitude1, x2: latitude2, y2: longitude2
function distance(x1, y1, x2, y2, unit)
	if('number'~=type(x1) or 'number'~=type(y1) or 'number'~=type(x2) or 'number'~=type(y2)) then return 0 end
	if(0==x1 or 0==y1) then return 0 end
	local r=0.017453292519943295769236907684886127;
	x1=x1*r; x2=x2*r; y1=y1*r; y2=y2*r;
	local dy,dx,a;
	local e=('mi'==unit) and 3959.0 or 6372.8;
	dy=y2-y1; dx=x2-x1;
	a = math.pow(math.sin(dx/2),2) + math.cos(x1) * math.cos(x2) * math.pow(math.sin(dy/2),2);
	return 2 * math.asin(math.sqrt(a)) * e;
end
