#
# XcodeInstaller::Download (Command Class)
#
# Determines the requested Xcode release (with the help of the ReleaseManager class) and handles the download, showing a progress bar with ETA.
#

module XcodeInstaller
  class Download
    attr_accessor :release

    def action(args, options)
      download_type = (args.include? 'cli') ? 'cli' : 'gui'

      mgr = XcodeInstaller::ReleaseManager.new
      @release = mgr.get_release(options.release, options.pre_release, download_type)

      if @release
        xcode_url = @release['download_url']
      else
        puts "No Xcode release with number #{options.release}. Use the 'list' command to see a list of known releases."
        exit
      end

      puts "Downloading Xcode #{@release['version']}"
      puts xcode_url

      agent.verbose = options.verbose
      agent.dry_run = options.dry_run
      agent.show_progress = options.show_progress
      try {
        filename = agent.download(xcode_url)
        puts "File saved to: #{Dir.pwd}/#{filename}" if filename
      }
    end

  end
end
