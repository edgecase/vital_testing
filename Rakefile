require 'rake/clean'

CLOBBER.include("*.zip")

task :default => :zip

desc "Create Zip File"
task :zip do
  rm "vital_testing.zip"
  sh "zip -r vital_testing.zip vital_testing"
end
