class CommonAPIController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :check_https
  before_filter :check_post_json, :if => lambda{|c| request.post?}
  before_filter :check_api_key

  def check_https
    if Rails.env.production? && !request.ssl?
      bad_request
    end
  end

  def check_post_json
    bad_request if request.content_type != "application/json"
  end

  def check_api_key
    provided = params[:api_key]
    needed = API_KEY
    if !provided.is_a?(String)
      bad_request
    elsif provided != needed
      forbidden
    else
      # OK
    end
  end

  def bad_request
    send_data "400 Bad Request\n", :status => 400
  end

  def forbidden
    send_data "403 Forbidden\n", :status => 403
  end

  def not_found
    send_data "404 Not Found\n", :status => 404
  end

end
