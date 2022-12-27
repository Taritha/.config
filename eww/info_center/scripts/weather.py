import requests
import argparse
import moon
import os
import math
from datetime import datetime
import json


def get_moon_phase():
    icon = moon.main()
    return icon

# Converts wind direction (in deg) to N-E-S-W paradigm
def wind_to_direction(deg):
    if deg == None or deg == '':
        return "N/A"

    directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"]
    return directions[math.floor((deg % 360) / 22.5) + 1]

# Returns icon from iconmap
def map_icon(icon):
    icon_map = {"01d" : "", "02d": "", "03d": "",
        "04d": "", "09d": "", "10d": "",
        "11d": "", "13d": "", "50d": "",
        "01n": "", "02n": "", "03n": "",
        "04n": "", "09n": "", "10n": "",
        "11n": "", "13n": "", "50n": ""}

    if icon == "01n":
        icon = get_moon_phase()
    else:
        icon = icon_map[icon]
    
    return icon

# Creates list of days of the week for daily forecast
def map_day_num(day_num):
    daymap = {
        0: 'Sun',
        1: 'Mon',
        2: 'Tue',
        3: 'Wed',
        4: 'Thu',
        5: 'Fri',
        6: 'Sat'
    }

    return daymap[day_num]

# Makes request on the API. Don't use this during development or you'll run out of free uses
def web_request(zip, api_key, unit):
    res = requests.get("http://api.openweathermap.org/data/2.5/forecast?zip={}&appid={}&units={}".format(zip, api_key, unit))
    forecast_data = res.json()

    # Extracts latitude and longitude based on 
    lat = forecast_data['city']['coord']['lat']
    lon = forecast_data['city']['coord']['lon']

    # Onecall gets hourly forecast and other useful things
    res = requests.get("http://api.openweathermap.org/data/2.5/onecall?&lat={}&lon={}&appid={}&exclude=minutely&units={}".format(lat, lon, api_key, unit))
    onecall_data = res.json()
    return onecall_data

# Loads from json, useful for development to prevent API call overload
def load_from_json(filepath='secrets/onecall.json'):
    with open(filepath, 'r') as jf:
        return json.load(jf)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Display the local weather, including moon phase and temperature')
    parser.add_argument('-z', '--zip', type=str, required=False, help='zip code to collect weather information from')
    parser.add_argument('-u', '--units', type=str, required=False, default='Metric', help='units to display the weather in ()')
    parser.add_argument('-f', '--forecast', required=False, action='store_true', help='use to display the 5-day forecast')
    parser.add_argument('-c', '--choice', type=str, required=False, help="type of information to output. Choices are: 'hourly_temps', 'hourly_times', 'daily_avgs', 'daily_names', 'daily_descs', 'daily_icons', 'curr_temp', 'curr_vibes', 'curr_presssure', 'curr_hum', 'curr_uvi', 'curr_ws', 'curr_wd', 'curr_icon'")
    parser.add_argument('-d', '--dev', required=False, action='store_true', help="enable for development to prevent overuse of API calls")
    args = parser.parse_args()

    # Reads zip from file if it's not provided
    if args.zip != None:
        ZIP = args.zip
    else:
        with open('secrets/zip', 'r') as z_read:
            ZIP = z_read.read().rstrip()

    if args.units != None:
        UNITS = args.units
    else:
        with open('secrets/unit', 'r') as u_read:
            UNITS = u_read.read().rstrip()
    
    if UNITS not in ['Imperial', 'Metric']:
        raise ValueError('units must be either "Imperial" or "Metric"')

    # or you can use city name
    # CITY = ""
    with open('secrets/api_key', 'r') as api_read:
        API_KEY = api_read.read().rstrip()

    # Shows detailed weather data depening on argument provided
    if args.forecast:
        output_jarrs = {
            'hourly_temps': '[',
            'hourly_times': '[',
            'daily_avgs': '[',
            'daily_names': '[',
            'daily_descs': '[',
            'daily_icons': '['
        }

        now = datetime.now()
        current_hour = now.strftime('%H')
        current_day = now.strftime('%u')

        if args.dev:
            onecall_data = load_from_json()
        else:
            onecall_data = web_request(ZIP, API_KEY, UNITS)

        # Gets hourly forecast for nect 48hrs into eww-compatible array
        for n, hour_cast in enumerate(onecall_data['hourly']):
            temp = int(round(hour_cast['temp'], 0))
            output_jarrs['hourly_temps'] += f'{temp}, '

            # Creates hour stimestamp to match the temperature
            matched_hour = int(current_hour) + n + 1
            if matched_hour >= 24:
                matched_hour -= 24 * math.floor(matched_hour / 24)
            output_jarrs['hourly_times'] += f'{matched_hour}, '

        # Gets daily weaither info for next 5 days
        for n, daily_cast in enumerate(onecall_data['daily']):
            d_temp = int(round(daily_cast['temp']['day'], 0))
            d_icon = map_icon(daily_cast['weather'][0]['icon'])
            d_desc = daily_cast['weather'][0]['description']
            output_jarrs['daily_avgs'] += f'{d_temp}, '
            output_jarrs['daily_icons'] += f'"{d_icon}", '
            output_jarrs['daily_descs'] += f'"{d_desc}", '

            matched_day = int(current_day) + n + 1
            if matched_day >= 7:
                matched_day -= 7 * math.floor(matched_day / 7)
            output_jarrs['daily_names'] += f'"{map_day_num(matched_day)}", '

        output_jarrs['curr_temp'] = onecall_data['current']['temp']
        output_jarrs['curr_vibes'] = int(round(onecall_data['current']['feels_like'], 0))
        output_jarrs['curr_pressure'] = onecall_data['current']['pressure']
        output_jarrs['curr_hum'] = onecall_data['current']['humidity']
        output_jarrs['curr_uvi'] = onecall_data['current']['uvi']
        output_jarrs['curr_ws'] = onecall_data['current']['wind_speed']
        output_jarrs['curr_wd'] = wind_to_direction(onecall_data['current']['wind_deg'])
        output_jarrs['curr_icon']= map_icon(onecall_data['current']['weather'][0]['icon'])

        # Fixes arr formatting
        for key, astr in output_jarrs.items():
            if isinstance(astr, str) and '[' in astr:
                output_jarrs[key] = f'{astr[:-2]}]'
        
        if args.choice not in list(output_jarrs.keys()):
            raise ValueError(f'{args.choice} must be in {list(output_jarrs.keys())}')

        print(output_jarrs[args.choice])

    # Shows short, one-line description of weather
    else:
        res = requests.get("http://api.openweathermap.org/data/2.5/weather?zip={}&appid={}&units={}".format(ZIP, API_KEY, UNITS))
        weather_data = res.json()

        if weather_data["cod"] == 200:
            temp = int(weather_data["main"]["temp"])
            icon = map_icon(weather_data["weather"][0]["icon"])
            desc = weather_data["weather"][0]["description"]

            print("{}°C {} {} ".format(temp, desc, icon))