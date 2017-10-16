#!/usr/bin/env ruby
require 'net/http'
require 'json'

API_ROOT_URL = 'http://api.openweathermap.org/data/2.5'

abort "WEATHER_APP_ID environment variable is not set" unless ENV['WEATHER_APP_ID']

def forecast_uri_for(query)
  params = { 
    units: 'metric', 
    appid: ENV['WEATHER_APP_ID'], 
    q: query 
  }
  uri = URI(API_ROOT_URL + '/forecast')
  uri.query = URI.encode_www_form(params)
  uri
end

if ARGV[0]
  response = Net::HTTP.get_response(forecast_uri_for(ARGV[0]))
  if response.code == '200'
    data = JSON.parse(response.body, symbolize_names: true)
    puts "DATE\tTEMP(min)\tTEMP(max)\tDESCRIPTION"
    data[:list].map do |sample|
      { 
        date: Time.at(sample[:dt]).strftime('%Y-%m-%d %H:%M'),
        temp_min: sample[:main][:temp_min],
        temp_max: sample[:main][:temp_max],
        description: sample[:weather].first[:description]
      }
    end.each do |sample|
      puts "%{date}\t%{temp_min}\t%{temp_max}\t%{description}" % sample
    end
  else
    abort response.body
  end
else
  abort "Provide a city as argument"
end

