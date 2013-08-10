module Example

  include APIClient

  def self.api_key_filename
    "example_key"
  end

  def self.service_hostname
    "service.foobar.com"
  end

  def peek x
    JSON.parse(get 'peek', :at => x)
  end

  def poke x, y
    post! 'poke', :at => x, :value => y
  end

end
