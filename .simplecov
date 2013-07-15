SimpleCov.start do
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Libraries', 'app/lib'

  add_filter 'config'
  add_filter 'spec'
  add_filter 'app.rb'
end