module People
  class Application
    path   = File.expand_path('../../../databases', __FILE__) + '/' + 'locations.yml'
    file   = File.open path
    result = YAML.load(file)

    # configurations to access locations database
    config.locations_connection = result[Rails.env]
  end
end
