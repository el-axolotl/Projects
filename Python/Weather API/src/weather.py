# Imports
import json, os, requests

# Set secrets
WEATHER_API_KEY = os.getenv("WEATHER_API_KEY") 

# Inputs
lat = input("Enter your latitude: ")
lon = input("Enter you longitude: ")
# TODO make input validation

# API calls
response = requests.get(f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={WEATHER_API_KEY}").json()

# Outputs
if response["cod"] == 200:
    print(response)

else:
    print("Something went wrong")