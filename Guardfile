guard 'spork', rspec_env: { 'PADRINO_ENV' => 'test' } do
  watch(%r{^config/(.+)\.rb})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

guard 'rspec', all_after_pass: false, cli: '--drb' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                  { |m| "spec/app/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)\.rb$})      { |m| "spec/app/controllers/#{m[1]}_controller_spec.rb"}
  watch(%r{^spec/support/(.+)\.rb$})         { 'spec' }
  watch('spec/spec_helper.rb')               { 'spec' }
end