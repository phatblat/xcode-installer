command :'list' do |c|
  c.syntax = 'xcodedl list'
  c.summary = 'Lists the versions of Xcode available for downloading'
  c.description = ''

  c.action do |args, options|
    puts "args: #{args}"
    latest = XcodeDownload::XcodeVersions::LATEST
    gui_versions = XcodeDownload::XcodeVersions::GUI
    cli_versions = XcodeDownload::XcodeVersions::CLI

    title = 'Xcode GUI'
    table = Terminal::Table.new :title => title do |t|
      t << ['Version', 'Download URL']
      gui_versions.keys.each do |version|
        t << :separator

        row = [version, gui_versions[version]]
        t << row
      end
    end
    puts table

    title = 'Xcode Command-Line'
    table = Terminal::Table.new :title => title do |t|
      t << ['Version', 'Download URL']
      cli_versions.keys.each do |version|
        t << :separator

        row = [version, cli_versions[version]]
        t << row
      end
    end
    puts
    puts table

  end
end
