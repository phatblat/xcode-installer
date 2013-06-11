command :'install' do |c|
  c.syntax = 'xcode-installer install [options]'
  c.option '--no-trash', 'Prevents trashing .dmg after install'
  c.summary = 'Installs xcode from a previous download'
  c.description = 'NEEDS SOME WORK - Use download and mount .dmg manually for now'

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

    # Mount disk image
    mountpoint = '/Volumes/Xcode'
    # system "hdid '#{dmg_file}' -mountpoint #{mountpoint}"
    system 'hdiutil attach -quiet xcode4620419895a.dmg'

    # Trash existing install (so command is rerunnable)
    destination = '/Applications/Xcode.app'
    Trash.new.throw_out(destination)

    # Copy into /Applications
    puts 'Copying Xcode.app into Applications directory (this can take a little while)'
    system "cp -R #{mountpoint}/Xcode.app #{destination}"

    system 'hdiutil detach -quiet #{mountpoint}'
  end
end
