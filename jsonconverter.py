import json

class City:
    def __init__(self, name, lat, lng, country):
        # Check for the presence of "'" in the city name and replace it with an empty string
        self.name = name.replace("'", "") if "'" in name else name
        self.lat = float(lat)
        self.lng = float(lng)
        self.country = country

# Read JSON data from file
with open('cities.json') as json_file:
    cities_data = json.load(json_file)

# Convert JSON data to a list of City objects
cities = [City(city['name'], city['lat'], city['lng'], city['country']) for city in cities_data]

# Sort cities by longitude in descending order (furthest east to furthest west)
cities.sort(key=lambda city: city.lng, reverse=True)

filteredCities = []

for i in range(len(cities)-1):
    if (round(cities[i].lng, 1) != round(cities[i+1].lng, 1)) & (round(cities[i].lat, 1) != round(cities[i+1].lat, 1)): 
        filteredCities.append(cities[i])

# Create a text file and write city information in the desired format
with open('cities_output.txt', 'w') as txt_file:
    for city in filteredCities:
        line = f"'{city.name} {city.country}': LatLng({city.lat}, {city.lng}),"
        txt_file.write(line + '\n')

print('Text file created successfully.')
