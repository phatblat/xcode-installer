require "bundler"
Bundler.setup

gemspec = eval(File.read("xcode-installer.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["xcode-installer.gemspec"] do
  system "gem build xcode-installer.gemspec"
end

task :install => ["#{gemspec.full_name}.gem"] do |t|
  system "gem install ./#{gemspec.full_name}.gem"
end
