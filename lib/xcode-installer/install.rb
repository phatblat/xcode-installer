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
    attr_accessor :release, :version_suffix

    def action(args, options)
      mgr = XcodeInstaller::ReleaseManager.new
      @release = mgr.get_release(options.release, options.pre_release)
      @version_suffix = "-#{@release['version']}"

      files = Dir.glob(dmg_file_name)
      if files.length == 0
        puts '#{dmg_file_name} file not found in current directory. Run the download command first.'
        return
      elsif files.length > 1
        puts 'Multiple #{dmg_file_name} files found in the current directory. Is this partition formatted with a case-insensitive disk format?'
        return
      end
      dmg_file = files[0]
      puts dmg_file

      # Mount disk image
      mountpoint = '/Volumes/Xcode'
      # system "hdid '#{dmg_file}' -mountpoint #{mountpoint}"
      system "hdiutil attach -quiet #{dmg_file}"

      # Trash existing install (so command is rerunnable)
      destination = "/Applications/Xcode#{version_suffix}.app"
      Trash.new.throw_out(destination)

      # TODO: Dynamically determine .app file name (DP releases have the version embedded)
      # Copy into /Applications
      puts 'Copying Xcode.app into Applications directory (this can take a little while)'
      system "cp -R #{mountpoint}/Xcode.app #{destination}"

      system "hdiutil detach -quiet #{mountpoint}"
    end

    def dmg_file_name
      return File.basename(@release['download_url'])
    end

  end
end
