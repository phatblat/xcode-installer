require 'xcode-installer/install'

command :'install' do |c|
  c.syntax = 'xcode-installer install [options]'
  c.option '--no-trash', 'Prevents trashing .dmg after install'
  c.option '--release STRING', 'Used to specify an old or pre-release version of Xcode. Otherwise, latest GA release of Xcode is downloaded.'
  c.option '--pre-release', 'Specifies to download the latest pre-release version of Xcode.'
  c.summary = 'Installs xcode from a .dmg file, downloading it if not already present'
  c.description = 'NEEDS SOME WORK - Use download and mount .dmg manually for now'

  c.action XcodeInstaller::Install, :action
end
