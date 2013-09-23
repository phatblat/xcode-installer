#
# XcodeInstaller::Download (Command Class)
#
#

module XcodeInstaller
  class Download

    def action(args, options)
      if options.release
        xcode_version = options.release
      else
        if options.pre_release
          xcode_version = XcodeInstaller::XcodeVersions::LATEST_DP
        else
          xcode_version = XcodeInstaller::XcodeVersions::LATEST_GA
        end
      end

      mgr = XcodeInstaller::ReleaseManager.new
      release = mgr.get_release(xcode_version, options.pre_release, 'gui')

      if release
        xcode_url = release['download_url']
      else
        puts "No Xcode release with number #{xcode_version}. Use the 'list' command to see a list of known releases."
        exit
      end

      puts "Downloading Xcode #{xcode_version}"
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
