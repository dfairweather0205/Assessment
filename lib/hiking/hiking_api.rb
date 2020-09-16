module Hiking
  class HikingApi
    class_attribute :api_url, :api_key
    
    # TODO move to env
    self.api_url = "https://www.hikingproject.com/data/get-trails?"
    self.api_key = "200913458-2e2f611e420387eb825cfc800ab0e691"

    include Singleton
    def get_by_lat_lon(lat, lon, max_distance=20)
      url = "#{api_url}lat=#{lat}&lon=#{lon}&maxDistance=#{max_distance}&key=#{api_key}"
      return request(method: :get, path: url)
    end

    private
    def request(method:, path:, timeout: 15, open_timeout: 5, user_agent: nil)
      begin
        
        r = RestClient::Request.execute(
            method:       method,
            url:          path,
            headers:      {:user_agent => user_agent}.compact,
            # payload:      URI.encode_www_form(payload),
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

  API = HikingApi.instance
end
