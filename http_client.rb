require 'net/http'

module HTTPClient

  class NotFound < StandardError; end
  class BadRequest < StandardError; end
  class Forbidden < StandardError; end
  class Unauthorized < StandardError; end
  class ServiceUnavailable < StandardError; end
  class InternalServerError < StandardError; end
  class BadGateway < StandardError; end

  def self.get uri, params=nil
    uri_object = URI.parse uri
    http = Net::HTTP.new(uri_object.host, uri_object.port)
    http.use_ssl = (uri_object.scheme == "https")
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    full_uri = params ? "#{uri}?#{params.to_query}" : uri
    response = http.get uri

    check_for_error response.code, response.message, uri

    response.body
  end

  def self.post! uri, data, headers={}
    uri_object = URI.parse uri
    http = Net::HTTP.new(uri_object.host, uri_object.port)
    http.use_ssl = (uri_object.scheme == "https")
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.post(uri, data, headers)

    check_for_error response.code, response.message, uri

    response.body
  end

  def self.check_for_error code, message, uri
    eclass = case code
      when /^2\d\d$/ then :none
      when '400' then BadRequest
      when '401' then Unauthorized
      when '403' then Forbidden
      when '404' then NotFound
      when '500' then InternalServerError
      when '502' then BadGateway
      when '503' then ServiceUnavailable
    end

    return if eclass == :none
    raise eclass, uri if eclass
    raise IOError, "#{code} #{message} (#{uri})"
  end
end
