import csv

class City:
    def __init__(self, name, country, latitude, longitude, population):
        self.name = name.replace("'", "") if "'" in name else name
        self.country = country.replace("'", "") if "'" in country else country
        self.latitude = float(latitude)
        self.longitude = float(longitude)
        self.population = float(population)

# Read data from worldcities.csv and create City objects
cities = []
with open('worldcities.csv', mode='r', encoding='utf-8') as file:
    reader = csv.reader(file)
    next(reader)  # Skip header
    for row in reader:
        if row[9] == "":
          city = City(row[0], row[4], row[2], row[3], 1)
        else:
          city = City(row[0], row[4], row[2], row[3], row[9])
        cities.append(city)

def filter_top_cities(city_objects, percentage, max_cities_per_country=100):
    # Create a dictionary to store cities by country
    cities_by_country = {}
    
    # Populate the dictionary
    for city in city_objects:
        if city.country not in cities_by_country:
            cities_by_country[city.country] = []
        cities_by_country[city.country].append(city)

    # Create a list to store the top cities from each country
    top_cities = []

    # Iterate through each country's cities and select the top percentage
    for country, cities in cities_by_country.items():
        # Sort cities in the country by population in descending order
        cities.sort(key=lambda city: city.population, reverse=True)

        # Calculate the index to select the top percentage of cities
        top_index = min(int(len(cities) * percentage), max_cities_per_country)

        # Add the top cities to the final list
        top_cities.extend(cities[:top_index])

    return top_cities

cities = filter_top_cities(cities, 0.35, 120)


def sort_cities(cities):
    # Sort cities by integer longitude (from 180 to -180)
    cities.sort(key=lambda city: -int(city.longitude))

    # Create a dictionary to group cities by longitude
    cities_by_longitude = {}
    for city in cities:
        lon_key = int(city.longitude)
        if lon_key not in cities_by_longitude:
            cities_by_longitude[lon_key] = []
        cities_by_longitude[lon_key].append(city)

    # Sort each subset of cities with equal longitude by latitude
    for lon_key, subset in cities_by_longitude.items():
        subset.sort(key=lambda city: (city.latitude, -city.latitude) if lon_key % 2 == 0 else (-city.latitude, city.latitude))

    # Flatten the sorted subsets into the final sorted list
    sorted_cities = [city for subset in cities_by_longitude.values() for city in subset]

    return sorted_cities

cities = sort_cities(cities)

# Write sorted cities to a .txt file
with open('sorted_cities.txt', mode='w', encoding='utf-8') as output_file:
    for city in cities:
        output_file.write(f"'{city.name}, {city.country}': LatLng({city.latitude}, {city.longitude}),\n")

print("Done! The sorted cities are saved in 'sorted_cities.txt'.")
