#
# XcodeInstaller::List
#

module XcodeInstaller
  class List

    def action(args, options)

      show_all = args.include? 'all'
      show_gui = args.include? 'gui'
      show_cli = args.include? 'cli'
      # Show GUI when no args given
      show_gui = true if !show_all && !show_gui && !show_cli

      mgr = XcodeInstaller::ReleaseManager.new

      gui_versions = mgr.get_all('gui')
      cli_versions = mgr.get_all('cli')

      if show_all || show_gui
        title = 'Xcode GUI'
        table = Terminal::Table.new :title => title do |t|
          t << ['Version', 'Release Date', 'Download URL']
          gui_versions.each do |release|
            t << :separator

            row = [release['version'], release['release_date'], release['download_url']]
            t << row
          end
        end
        puts table
      end

      # Extra line between tables
      puts if show_all

      os_version = `sw_vers -productVersion`
      # Drop the patch number
      os_version = os_version.match(/\d+\.\d+/)[0]

      if show_all || show_cli
        title = 'Xcode Command-Line'
        table = Terminal::Table.new :title => title do |t|
          t << ['Version', 'Release Date', 'Download URL']
          cli_versions.each do |release|
            # Skip releases for a different OS version
            next unless release['os_version'].to_s == os_version

            t << :separator
            row = [release['version'], release['release_date'], release['download_url']]
            t << row
          end
        end
        puts table
      end
    end

  end
end
