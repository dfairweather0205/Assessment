module Weather
  class WeatherApi
    class_attribute :api_url, :api_key
    
    # # api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={your api key}
    # TODO move to env
    self.api_url = "https://api.openweathermap.org/data/2.5/weather"
    self.api_key = "960973d2e50d096945f3ad55df2aa291"

    include Singleton

    def get_by_lat_lon(lat, lon)
      url = "#{api_url}?lat=#{lat}&lon=#{lon}&appid=#{api_key}"
      print(url)
      request(method: :get, path: url)
    end

    private
    def request(method:, path:, timeout: 15, open_timeout: 5, user_agent: nil)
      begin
        r = RestClient::Request.execute(
            method:       method,
            url:          path,
            headers:      {:user_agent => user_agent}.compact,
            timeout:      timeout,
            open_timeout: open_timeout
        )
        JSON.parse(r)
      rescue RestClient::Exception => bad_request
        { code: bad_request.http_code, status: 'failure', body: bad_request.response }
      end
    rescue => e
      { code: 500, status: 'failure', body: e.message }
    end

  end

  API = WeatherApi.instance
end


    # def zipcode(zipcode, country="USA")
    #   url = "#{self.api_url}?zipcode=#{zipcode}&country=#{country}&appid=#{self.api_key}"
    #   return self.request(:get, url)
    # end

    # def get_weather_by_city_state(city, state, country="USA")
    #   url = "#{self.api_url}?city=#{city}&state=#{state}&country=#{country}&appid=#{self.api_key}"
    #   return self.request(:get, url)
    # end
    