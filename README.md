# Weather Report App

Weather Report App is a web application that fetches and displays weather forecasts based on zip codes using the WeatherAPI.

# Scope
1. Use Ruby On Rails.
2. Accept an address as input.
3. Retrieve forecast data for the given address. This should include, at minimum, the current temperature. Bonus points: retrieve high/low and/or extended forecast.
4. Display the requested forecast details to the user.
5. Cache the forecast details for 30 minutes for all subsequent requests by zip codes. Display indicator in result is pulled from cache.
# Stack
1. Ruby Version - Ruby 3.0
2. Rails Version - Rails 7.2
3. Redis for caching
4. RSpec for Specs
5. Weather API for Getting Weather(https://www.weatherapi.com/)
## Table of Contents

- [Weather Report App](#weather-report-app)
  - [Table of Contents](#table-of-contents)
  - [About](#about)
  - [Features](#features)
  - [Installation](#installation)

## About

Weather Report App allows users to retrieve current weather information and extended forecasts for a specific zip code. It integrates with the WeatherAPI to provide accurate weather data.

## Features

- Display current temperature, high and low temperatures
- Show extended forecasts for the next few days
- Cache forecast data for faster retrieval
- Simple and intuitive user interface

## Installation

To run Weather Report App locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/weather-report.git
   cd weather-report/
2. Ruby/Rails Versions
   ```bash
   Ruby Version - ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [arm64-darwin22]
   Rails Version - Rails 7.1.3.4
3. Install dependencies:
   ```bash
   bundle install
4. SetUp Env Varible for Weather Report 
   
   Right Now I have put in the model - But we have to store in the env file. You have to register below link for API Key
   ```bash
   http://api.weatherapi.com/v1/forecast.json
5. 
