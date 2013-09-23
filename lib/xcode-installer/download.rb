#
# XcodeInstaller::Download (Command Class)
#
#

module XcodeInstaller
  class Download

    def action(args, options)
      mgr = XcodeInstaller::ReleaseManager.new
      release = mgr.get_release(nil, options.pre_release)

      if release
        xcode_url = release['download_url']
      else
        puts "No Xcode release with number #{options.release}. Use the 'list' command to see a list of known releases."
        exit
      end

      puts "Downloading Xcode #{release['version']}"
      puts xcode_url

      agent.verbose = options.verbose
      agent.dry_run = options.dry_run
      try {
        filename = agent.download(xcode_url)
        puts "File saved to: #{Dir.pwd}/#{filename}" if filename
      }
    end

  end
end
