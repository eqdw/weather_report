# README

Welcome to my simple Rails weather forecasting app. This app comes with a soundtrack, please put on [Birdland](https://www.youtube.com/watch?v=_Fm10whccto) while checking the weather in this app

## Get Started

1. Clone this repository: `git clone git@github.com:eqdw/weather_report.git`
2. Sign up for [OpenWeatherMap](https://openweathermap.org) and get an API key. Once you sign up, an API key should be automatically generated and available at https://home.openweathermap.org/api_keys
3. Create a new `.env` file and add the API key from (2) into your environment variables: `echo "WEATHER_API_KEY=[THE KEY FROM (2)]" >> .env`
4. `bundle install`
5. `bin/rails db:migrate`
6. `bin/rails s`

You should now be able to access the app and use it locally at the URL output in your console window. 
