command :'list' do |c|
  c.syntax = 'xcode-installer list'
  c.summary = 'Lists the versions of Xcode available for downloading'
  c.description = 'Shows only the Xcode GUI versions by default. Specify "all" or "cli" to show command-line tools'

  c.action do |args, options|
    # puts "args: #{args}"

    show_all = args.include? 'all'
    show_gui = args.include? 'gui'
    show_cli = args.include? 'cli'
    # Show GUI when no args given
    show_gui = true if !show_all && !show_gui && !show_cli

    # latest = XcodeInstaller::XcodeVersions::LATEST
    mgr = XcodeInstaller::XcodeVersions::ReleaseManager.new

    gui_versions = mgr.get_all('gui')
    cli_versions = mgr.get_all('cli')
    puts cli_versions

    if show_all || show_gui
      title = 'Xcode GUI'
      table = Terminal::Table.new :title => title do |t|
        t << ['Version', 'Download URL']
        gui_versions.each do |release|
          t << :separator

          row = [release['version'], release['download_url']]
          t << row
        end
      end
      puts table
    end

    # Extra line between tables
    puts if show_all

    if show_all || show_cli
      title = 'Xcode Command-Line'
      table = Terminal::Table.new :title => title do |t|
        t << ['Version', 'Download URL']
        cli_versions.each do |release|
          t << :separator

          row = [release['version'], release['download_url']]
          t << row
        end
      end
      puts table
    end

  end
end
