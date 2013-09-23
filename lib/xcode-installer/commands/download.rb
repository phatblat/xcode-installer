require 'xcode-installer/download'

command :'download' do |c|
  c.syntax = 'xcode-installer download [options]'
  c.option '--dry-run', 'Enables a HEAD request instead of downloading the file'
  c.option '--release STRING', 'Used to specify an old or pre-release version of Xcode. Otherwise, latest GA release of Xcode is downloaded.'
  c.option '--pre-release', 'Specifies to download the latest pre-release version of Xcode.'
  c.summary = 'Initiates the download'
  c.description = ''

  c.action XcodeInstaller::Download, :action
end
