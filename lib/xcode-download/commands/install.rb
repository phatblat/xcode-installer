command :'install' do |c|
  c.syntax = 'xcodedl install [options]'
  c.option '--no-trash', 'Prevents trashing .dmg after install'
  c.summary = 'Installs xcode from a previous download'
  c.description = ''

  c.action do |args, options|
    files = Dir.glob('*.dmg')
    if files.length == 0
      puts 'No .dmg files found in current directory. Run the download command first.'
      return
    elsif files.length > 1
      puts 'Multiple .dmg files found in the current directory. Currently no support for specifying file.'
      return
    end
    dmg_file = files[0]

    mountpoint = '/Volumes/Xcode'
    system "hdid '#{dmg_file}' -mountpoint #{mountpoint}"
  end
end
