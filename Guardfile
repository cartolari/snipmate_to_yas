notification :file, path: '.guard_result'

guard :minitest do
  watch(%r{^test/(.*)\/?test\.rb$}) { 'test' }
  watch(%r{^lib/(.*)\.rb$}) { 'test' }
  watch(%r{^test/test_helper\.rb$}) { 'test' }
end
