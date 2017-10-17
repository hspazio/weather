module Weather
  Sample = Struct.new(:date, :temp_min, :temp_max, :humidity, :description)

  class Gateway
    ROOT_URL = 'http://api.openweathermap.org/data/2.5'

    def initialize(app_id)
      @app_id = app_id
    end

    def forecast(query)
      uri = forecast_uri_for(query)
      response = Net::HTTP.get_response(uri)

      if response.code == '200'
        sample_list_from_response(response)
      else
        raise response.body
      end
    end

    private 

    def sample_list_from_response(response)
      data = JSON.parse(response.body, symbolize_names: true)

      data[:list].map do |sample|
        sample_from_json(sample)
      end
    end

    def sample_from_json(json)
      Sample.new(
        Time.at(json[:dt]).strftime('%Y-%m-%d %H:%M'),
        json[:main][:temp_min],
        json[:main][:temp_max],
        json[:main][:humidity],
        json[:weather].first[:description]
      )
    end

    def forecast_uri_for(query)
      params = { 
        units: 'metric', 
        appid: @app_id,
        q: query 
      }
      uri = URI(ROOT_URL + '/forecast')
      uri.query = URI.encode_www_form(params)
      uri
    end
  end
end
