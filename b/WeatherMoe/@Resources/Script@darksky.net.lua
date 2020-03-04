--20200303
function Initialize()
	-- global variable
	-- 11644473600(seconds) = 1970-01-01T00:00:00(UNIX Time) - 1601-01-01T00:00:00(Windows Filetime)
	time_delta = 11644473600 + get_timezone()

	local ln = SKIN:GetVariable('LOCALE_NAME', '')
	if(''==ln) then SKIN:Bang('!EnableMeasure', 'msRegLocaleName') end
	local ll = SKIN:GetVariable('LOCALE_LANG', '')
	if(''==ll) then SKIN:Bang('!EnableMeasure', 'msRegLocaleLang') end
	local lu = SKIN:GetVariable('LOCALE_UNITS', '')
	if(''==lu) then SKIN:Bang('!EnableMeasure', 'msRegLocaleUnits') end
	
	if(''~=ln and ''~=ll and ''~=lu and
		''~=SKIN:GetVariable('DARKSKY_APIKEY', '') and ''~=SKIN:GetVariable('GEO_COORDINATES', '')) then
		SKIN:Bang('!EnableMeasure', 'msWebParser')
	else
		-- 1st time to load the skin.
		if(''==ln) then SKIN:Bang('!EditSkin') end
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

function Select_Daily_Index(th)
	-- th: THRESHOLD_HOURS
	th = tonumber(th)
	th = (nil~=th) and clamp_num(th, 0, 23) or 18
	if(th>tonumber(os.date('%H', os.time()))) then
		SKIN:Bang('!SetVariable', 'IX', 0)
	else
		SKIN:Bang('!SetVariable', 'IX', 1)
	end
end

function Select_Hourly_Index(tm)
	-- tm: THRESHOLD_MINUTES
	tm = tonumber(tm)
	tm = (nil~=tm) and clamp_num(tm, 0, 59) or 30
	if(tm>tonumber(os.date('%M', os.time()))) then
		SKIN:Bang('!SetVariable', 'IX', 1)
	else
		SKIN:Bang('!SetVariable', 'IX', 2)
	end
end

function Update_Daily_Data()
	local rd = SKIN:GetMeasure('msWebParser'):GetStringValue()
	if(string.find(string.lower(string.sub(rd, 1, 16)), 'latitude')) then
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
		SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipText', '#CRLF#JSON data "latitude" not found.')
		SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipTitle', 'JSON')
		SKIN:Bang('!DisableMeasure', 'msWebParser')
	end
	rd = ''
	SKIN:Bang('!SetOptionGroup', 'grContents', 'DynamicVariables', 1)
	SKIN:Bang('!UpdateMeterGroup', 'grContents')
	SKIN:Bang('!Redraw')	
end

function Update_Hourly_Data()
	local rd = SKIN:GetMeasure('msWebParser'):GetStringValue()
	if(string.find(string.lower(string.sub(rd, 1, 16)), 'latitude')) then
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
		SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipText', '#CRLF#JSON data "latitude" not found.')
		SKIN:Bang('!SetOption', 'mtIcon0', 'ToolTipTitle', 'JSON')
		SKIN:Bang('!DisableMeasure', 'msWebParser')
	end
	rd = ''
	SKIN:Bang('!SetOptionGroup', 'grContents', 'DynamicVariables', 1)
	SKIN:Bang('!UpdateMeterGroup', 'grContents')
	SKIN:Bang('!Redraw')	
end

function Setup_Daily_Tooltip()
	local tx = '[msDI_ctxt]'
	if('0'~=SKIN:GetVariable('SHOW_TEMPERATURE','0')) then tx = tx..'#1DAY_FORECAST_DATA_TEMPERATURE#' end
	if('0'~=SKIN:GetVariable('SHOW_DETAILS','1')) then tx = tx..'#1DAY_FORECAST_DATA_DETAILS#' end
	if('0'~=SKIN:GetVariable('SHOW_SUN','0')) then tx = tx..'#1DAY_FORECAST_DATA_SUN#' end
	if('0'~=SKIN:GetVariable('SHOW_LOCATION','1')) then tx = tx..'#LOCATION_DATA#' end
	tx = tx..'#CRLF##CRLF##1DAY_FORECAST##CRLF##1DAY_FORECAST_DATE#'
	SKIN:Bang('!SetVariable', 'TOOLTIP_TEXT', tx)
end

function Setup_Hourly_Tooltip()
	local tx = '[msHH_ctxt]'
	if('0'~=SKIN:GetVariable('SHOW_TEMPERATURE','0')) then tx = tx..'#1HOUR_COP_DATA_TEMPERATURE#' end
	if('0'~=SKIN:GetVariable('SHOW_DETAILS','1')) then tx = tx..'#1HOUR_COP_DATA_DETAILS#' end
	if('0'~=SKIN:GetVariable('SHOW_SUN','0')) then tx = tx..'#1HOUR_COP_DATA_SUN#' end
	if('0'~=SKIN:GetVariable('SHOW_LOCATION','1')) then tx = tx..'#LOCATION_DATA#' end
	tx = tx..'#CRLF##CRLF##1HOUR_COP##CRLF##1HOUR_COP_DATE#'
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
