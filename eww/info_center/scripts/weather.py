import requests
import argparse
import moon


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Display the local weather, including moon phase and temperature')
    parser.add_argument('-z', '--zip', type=str, required=True, help='zip code to collect weather information from')
    parser.add_argument('-u', '--units', type=str, required=False, default='Metric', help='units to use (lol imagine using imperial)')
    args = parser.parse_args()

    ZIP = args.zip
    # or you can use city name
    # CITY = ""
    API_KEY = "7b62c26fbb45c04583562bfd25ffc62c"
    UNITS = args.units

    if UNITS not in ['Imperial', 'Metric']:
        raise ValueError('units must be either "Imperial" or "Metric"')

    def get_moon_phase():
        icon = moon.main()
        return icon

    res = requests.get("http://api.openweathermap.org/data/2.5/weather?zip={}&appid={}&units={}".format(ZIP, API_KEY, UNITS))
    weather_data = res.json()
    icon_map = {"01d" : "", "02d": "", "03d": "",
                "04d": "", "09d": "", "10d": "",
                "11d": "", "13d": "", "50d": "",
                "01n": "", "02n": "", "03n": "",
                "04n": "", "09n": "", "10n": "",
                "11n": "", "13n": "", "50n": ""}


    if weather_data["cod"] == 200:
        temp = int(weather_data["main"]["temp"])
        icon = weather_data["weather"][0]["icon"]
        if icon == "01n":
            icon = get_moon_phase()
        else:
            icon = icon_map[icon]
        desc = weather_data["weather"][0]["description"]

        print("{}°C {} {} ".format(temp, desc, icon))