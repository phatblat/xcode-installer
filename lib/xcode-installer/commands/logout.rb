require 'xcode-installer/logout'

command :logout do |c|
  c.syntax = 'xcode-installer logout'
  c.summary = 'Remove account credentials'
  c.description = ''

  c.action XcodeInstaller::Logout, :action
end
