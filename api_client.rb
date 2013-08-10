module APIClient

  class Incomplete < StandardError; end

  def self.api_key_filename
    raise Incomplete, 'no api key filename';
  end

  def self.service_hostname
    raise Incomplete, 'no service hostname';
  end

  def self.endpoint method
    "#{service_hostname}/api/#{method}"
  end

  def self.api_key
    if @api_key
      @api_key
    else
      filename = api_key_filename
      File.open("#{Rails.root}/config/#{filename}").read.chomp
    end
  end

  def self.get method, params
    HTTPClient.get(
      endpoint(method),
      params.merge({:api_key => api_key})
    )
  end

  def self.post method, params
    HTTPClient.post!(
      endpoint(method),
      JSON.generate(params.merge({:api_key => api_key})),
      {'Content-Type', 'application/json'}
    )
  end

end
