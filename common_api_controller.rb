class CommonAPIController < ApplicationController

  before_filter :check_https
  before_filter :check_post_json, :if => lambda{|c| request.post?}
  before_filter :check_api_key

  def check_https
    bad_request unless request.ssl?
  end

  def check_post_json
    bad_request if request.content_type != "application/json"
  end

  def check_api_key
    provided = params[:api_key]
    needed = API_KEY
    bad_request unless provided.is_a?(String)
    forbidden if provided != needed
  end

  def bad_request
    send_data "400 Bad Request", :status => 400
  end

  def forbidden
    send_data "403 Forbidden", :status => 403
  end

  def not_found
    send_data "404 Not Found", :status => 404
  end

  def index
    # make routes to /api/<blank or invalid method> go here
    # as defined in the common api spec, this causes a 404
    not_found
  end

end
