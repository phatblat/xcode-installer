command :'download' do |c|
  c.syntax = 'xcodedl download'
  c.summary = 'Initiates the download'
  c.description = ''

  c.action do |args, options|
    xcode_version = XcodeDownload::XcodeVersions::LATEST
    xcode_url = XcodeDownload::XcodeVersions::GUI[xcode_version]

    puts "Downloading Xcode #{xcode_version}"

    try{agent.download(xcode_url)}
  end
end
