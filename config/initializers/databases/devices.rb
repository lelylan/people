path   = File.expand_path('../../../databases', __FILE__) + '/' + 'devices.yml'
file   = File.open path
result = YAML.load(file)

# configurations to access devices database
DEVICES_CONNECTION = result[Rails.env]
