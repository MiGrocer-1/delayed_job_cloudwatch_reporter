Gem::Specification.new do |s|
  s.name        = "delayed_job_cloudwatch_reporter"
  s.version     = "0.1.0"
  s.summary     = "Reports delayed job queue time metrics to cloudwatch"
  s.description = "Reports delayed job queue time metrics to cloudwatch"
  s.authors     = ["Rushi bhargav"]
  s.email       = "rushi@migrocer.in"
  s.files       = Dir['lib/**/*.rb']
  s.add_dependency 'aws-sdk', '~> 2.3'
  s.license       = "MIT"
end