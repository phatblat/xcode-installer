require 'xcode-installer/login'

command :login do |c|
  c.syntax = 'xcode-installer login'
  c.summary = 'Save account credentials'
  c.description = ''

  c.action XcodeInstaller::Login, :action
end
