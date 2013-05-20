command :'download' do |c|
  c.syntax = 'xcodedl download [options]'
  c.option '--dry-run', 'Enables a HEAD request instead of downloading the file'
  c.summary = 'Initiates the download'
  c.description = ''

  c.action do |args, options|
    xcode_version = XcodeDownload::XcodeVersions::LATEST
    xcode_url = XcodeDownload::XcodeVersions::GUI[xcode_version]

    puts "Downloading Xcode #{xcode_version}"

    agent.verbose = options.verbose
    agent.dry_run = options.dry_run
    try {
      filename = agent.download(xcode_url)
      puts "File saved to: #{Dir.pwd}/#{filename}"
    }
  end
end
