require "bundler"
Bundler.setup

gemspec = eval(File.read("xcode-download.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["xcode-download.gemspec"] do
  system "gem build xcode-download.gemspec"
end

task :install => ["#{gemspec.full_name}.gem"] do |t|
  system "gem install ./#{gemspec.full_name}.gem"
end
