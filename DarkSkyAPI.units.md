### [API will be shutdown at 2021-12-31 (December 31, 2021)](https://blog.darksky.net/dark-sky-has-a-new-home/)

### Units of Measure
`https://api.darksky.net/forecast/[key]/[latitude],[longitude]?exclude=[blocks]&lang=[language]&units=[units]`

Dark Sky API response  
|units|si|ca|uk2|us|auto|
|:----------:|:----------:|:----------:|:----------:|:----------:|:----------:|
|Temperature|**°C**  (Degrees Celsius)|**°C**  (Degrees Celsius)|**°C**  (Degrees Celsius)|**°F**  (Degrees Fahrenheit)|-|
|Wind Speed|**m/s**  (Meteres per second)|**km/h**  (Kilometers per hour)|**mph**  (Miles per hour)|**mph**  (Miles per hour)|-|
|Distance|**km**  (Kilometers)|**km**  (Kilometers)|**mi**  (Miles)|**mi**  (Miles)|-|
|Precip Intensity|**mm/h**  (Millimeters per hour)|**mm/h**  (Millimeters per hour)|**mm/h**  (Millimeters per hour)|**in/h**  (Inches per hour)|-|
|Precip Accumulation|**cm**  (Centimeters)|**cm**  (Centimeters)|**cm**  (Centimeters)|**in**  (Inches)|-|
|Pressure|**hPa**  (Hectopascals)|***hPa**  (Hectopascals)|***hPa**  (Hectopascals)|***mbar**  (Millibar)|-|

**Temperature**  
~~`apparentTemperatureHigh`~~, ~~`apparentTemperatureLow`~~, `apparentTemperatureMax`, `apparentTemperatureMin`, `dewPoint`, `Temperature`, ~~`temperatureHigh`~~, ~~`temperatureLow`~~, `temperatureMax`, `temperatureMin`  

**Wind Speed**  
`windGust`, `windSpeed`

**Distance**  
`nearest-station`, `nearestStormDistance`, `visibility`

**Precip Intensity** (rain)  
`precipIntensity`, `precipIntensityMax`

**Precip Accumulation** (snow)  
`precipAccumulation`

**Pressure**  
`pressure`  

uk2(en-GB): **hPa** (Hectopascals), but **mb(mbar)** (Millibar) by BBC in U.K.  
`mbar = hPa`  
us(en-US): **mbar** (Millibar), but **in** (inHg - Inches of Mercury)  
`in(inHg) = hPa / 33.8639`  
ca(en-CA,	fr-CA): **hPa**  (Hectopascals), but **kPa** by CBC in Canada  
`kPa = hPa / 10`  

### Common
**% (Percent)**  
`cloudCover`, `humidity`, `precipProbability`

**° (Degrees)**  
`nearestStormBearing`, `windBearing`

**DU ([Dobson units](https://en.wikipedia.org/wiki/Dobson_unit))**  
`ozone`

>### Time Periods
darksky.net Summaries and icons on daily data [Dark Sky API Notes](https://darksky.net/dev/docs#response-notes)
|Period|Local Standard Time|
|:------:|:------:|
|1Day|04:00-04:00|

>### Links
[Dark Sky API Request Parameters](https://darksky.net/dev/docs#forecast-request)  
