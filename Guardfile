guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch(%r{^config/locales/.+\.yml$})
  watch(%r{^config/settings/.+\.yml$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb')
end

guard 'rspec', cli: '--drb --format Fuubar --color', all_on_start: false, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})      { |m| "spec/lib/#{m[1]}_spec.rb" }

  watch(%r{^app/models/(.+)\.rb$})                    { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)\.rb})                { |m| "spec/requests/#{m[1]}_spec.rb" }
  watch(%r{^app/decorators/(.+)_decorator\.rb$})      { |m| "spec/requests/#{m[1]}_controller_spec.rb" }
  watch('app/controllers/application_controller.rb')  { "spec/requests" }
  watch(%r{^app/views/(.+)/(.+)$})                    { |m| "spec/requests/#{m[1]}_controller_spec.rb" }
  watch(%r{^spec/requests/support/views/(.+)_view\.rb$}) { |m| "spec/requests/#{m[1]}_controller_spec.rb" }

  # run tests if concern or shared example concern is changed
  watch(%r{^(.+)/models/concerns/ownable\.rb})    { "spec/models/doorkeeper/applications_spec.rb"}
  watch(%r{^(.+)/models/concerns/accessible\.rb}) { "spec/models/doorkeeper/access_token_spec.rb"}
  watch(%r{^(.+)/models/concerns/expirable\.rb})  { "spec/models/doorkeeper/access_token_spec.rb"}
end
