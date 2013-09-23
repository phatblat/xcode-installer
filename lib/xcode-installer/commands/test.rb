require 'xcode-installer/command-test'

command :test do |c|
  c.syntax = 'xcode-installer test'
  c.summary = 'Testing creation of a command using a class'
  c.description = ''

  c.action  XcodeInstaller::CommandTest, :action
end
