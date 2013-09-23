require 'xcode-installer/install'

command :'install' do |c|
  c.syntax = 'xcode-installer install [options]'
  c.option '--no-trash', 'Prevents trashing .dmg after install'
  c.summary = 'Installs xcode from a previous download'
  c.description = 'NEEDS SOME WORK - Use download and mount .dmg manually for now'

  c.action XcodeInstaller::Install, :action
end
