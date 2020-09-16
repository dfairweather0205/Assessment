class HealthCheckController < ApplicationController
  def index
    render :json => {message: 'hello winter'}
  end
end
