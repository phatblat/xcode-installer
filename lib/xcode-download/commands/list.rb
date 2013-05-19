command :'list' do |c|
  c.syntax = 'xcodedl list'
  c.summary = 'Lists the versions of Xcode available for downloading'
  c.description = ''

  c.action do |args, options|
    latest = XcodeDownload::XcodeVersions::LATEST
    gui_versions = XcodeDownload::XcodeVersions::GUI
    cli_versions = XcodeDownload::XcodeVersions::CLI

    title = 'Xcode GUI'
    table = Terminal::Table.new :title => title do |t|
      # t << ["Version"]
      gui_versions.keys.each do |version|
        # t << :separator

        row = [version]
        t << row
      end
    end

    puts table
  end
end
