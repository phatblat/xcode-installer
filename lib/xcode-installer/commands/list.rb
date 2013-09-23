require 'xcode-installer/list'

command :'list' do |c|
  c.syntax = 'xcode-installer list [all|gui|cli]'
  c.summary = 'Lists the versions of Xcode available for downloading'
  c.description = 'Shows only the Xcode GUI versions by default. Specify "all" or "cli" to show command-line tools'

  c.action XcodeInstaller::List, :action
end
