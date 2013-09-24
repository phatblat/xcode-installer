#
# XcodeInstaller::Install (Command Class)
#
# First, this command will look for the expected version of the Xcode installation .dmg file in the download (current) dir.
# If not found, the download will be initiated, afterwards the expected file will be verified.
# Installation will continue once the expected .dmg file is found. The .dmg will be mounted and the .app file copied out.
# By default, the version number will be inserted into the Xcode.app name. This will prevent collision with the Mac App Store
# installed version. An option may allow for this utility to overwrite the Xcode.app so that there is only a single copy installed.
# It would be nice to also set the newly installed Xcode to be the default on the command line using 'xcode-select --switch'.
#

require 'xcode-installer/download'

module XcodeInstaller
  class Install
    attr_accessor :release

    def action(args, options)
      mgr = XcodeInstaller::ReleaseManager.new
      @release = mgr.get_release(options.release, options.pre_release)

      files = Dir.glob('*.dmg')
      if files.length == 0
        puts 'No .dmg files found in current directory. Run the download command first.'
        return
      elsif files.length > 1
        puts 'Multiple .dmg files found in the current directory. Currently no support for specifying file.'
        return
      end
      dmg_file = files[0]

      # Mount disk image
      mountpoint = '/Volumes/Xcode'
      # system "hdid '#{dmg_file}' -mountpoint #{mountpoint}"
      system 'hdiutil attach -quiet xcode4620419895a.dmg'

      # Trash existing install (so command is rerunnable)
      destination = '/Applications/Xcode.app'
      Trash.new.throw_out(destination)

      # Copy into /Applications
      puts 'Copying Xcode.app into Applications directory (this can take a little while)'
      system "cp -R #{mountpoint}/Xcode.app #{destination}"

      system 'hdiutil detach -quiet #{mountpoint}'
    end

  end
end
