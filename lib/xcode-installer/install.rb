#
# XcodeInstaller::Install (Command Class)
#
# First, this command will look for the expected version of the Xcode installation .dmg file in the download (current) dir.
# If not found, the download will be initiated, afterwards the expected file will be verified.
# Installation will continue once the expected .dmg file is found. The .dmg will be mounted and the .app file copied out.
# By default, the version number will be inserted into the Xcode.app name. This will prevent collision with the Mac App Store
# installed version. An option may allow for this utility to overwrite the Xcode.app so that there is only a single copy installed.
# It would be nice to also set the newly installed Xcode to be the default on the command line using 'xcode-select --switch'.
#

require 'xcode-installer/download'
require 'ruby-progressbar'

module XcodeInstaller
  class Install
    attr_accessor :release, :version_suffix, :copied_kb, :copied_file_count, :progress_bar

    def initialize
      @copied_kb = 0
    end

    def action(args, options)
      mgr = XcodeInstaller::ReleaseManager.new
      @release = mgr.get_release(options.release, options.pre_release)
      @version_suffix = "-#{@release['version']}"

      files = Dir.glob(dmg_file_name)
      if files.length == 0
        puts '#{dmg_file_name} file not found in current directory. Run the download command first.'
        return
      elsif files.length > 1
        puts 'Multiple #{dmg_file_name} files found in the current directory. Is this partition formatted with a case-insensitive disk format?'
        return
      end
      dmg_file = files[0]
      # TODO: if verbose...
      # puts dmg_file

      # Mount disk image
      mountpoint = '/Volumes/Xcode'
      # system "hdid '#{dmg_file}' -mountpoint #{mountpoint}"
      system "hdiutil attach -quiet #{dmg_file}"

      # Trash existing install (so command is rerunnable)
      destination = "/Applications/Xcode#{version_suffix}.app"
      Trash.new.throw_out(destination)

      # TODO: Dynamically determine .app file name (DP releases have the version embedded)
      copy("#{mountpoint}/Xcode.app", destination)

      # system "hdiutil detach -quiet #{mountpoint}"
    end

    def dmg_file_name
      return File.basename(@release['download_url'])
    end

    def copy(source_path, destination_path)
      # Copy into /Applications
      # puts 'Copying Xcode.app into Applications directory (this can take a little while)'
      # TODO: wrap debug output with verbose checks
      puts "#{source_path} -> #{destination_path}"
      # system "cp -R #{source_path} #{destination_path}"

      total_kb = dir_size(source_path)
      # puts total_kb

      # puts File.stat(source_path).size

      @progress_bar = ProgressBar.create(:title => "Copying", :starting_at => 0, :total => @release['app_size_extracted'])
      @copied_file_count = 0
      cp_r(source_path, destination_path, {})
      @progress_bar.finish

      # block_size = File.stat(source_path).blksize
      # puts @copied_kb

      # in_name     = "src_file.txt"
      # out_name    = "dest_file.txt"

      # in_file     = File.new(in_name, "r")
      # out_file    = File.new(out_name, "w")

      # in_size     = File.size(in_name)
      # batch_bytes = ( in_size / 100 ).ceil
      # total       = 0
      # p_bar       = ProgressBar.new('Copying', 100)

      # buffer      = in_file.sysread(batch_bytes)
      # while total < in_size do
      #  out_file.syswrite(buffer)
      #  p_bar.inc
      #  total += batch_bytes
      #  if (in_size - total) < batch_bytes
      #    batch_bytes = (in_size - total)
      #  end
      #  buffer = in_file.sysread(batch_bytes)
      # end
      # p_bar.finish
    end

    # Exmaple output of the du command:
    # 2359828 /Volumes/Xcode/Xcode.app/
    def dir_size(path)
      output = `du -sk '#{path}' 2> /dev/null`
      return output.split(" ").first.to_i * 1024
    end

    def accumulate_kbytes(path)
      # @progress_bar.log path
      # @progress_bar.increment
      # @copied_kb += File.stat(path).size if File.exists?(path)
      @copied_file_count++
      if @copied_file_count.modulo(10000) == 0
        @progress_bar.progress = dir_size("/Applications/Xcode-5.app")
      end
    end

    ##########################################################################
    #                                                                        #
    # The following code was copied out of fileutils.rb from ruby 1.9.3-p392 #
    #                                                                        #
    ##########################################################################

    def cp_r(src, dest, options = {})
      # fu_check_options options, OPT_TABLE['cp_r']
      # fu_output_message "cp -r#{options[:preserve] ? 'p' : ''}#{options[:remove_destination] ? ' --remove-destination' : ''} #{[src,dest].flatten.join ' '}" if options[:verbose]
      return if options[:noop]
      options = options.dup
      options[:dereference_root] = true unless options.key?(:dereference_root)
      fu_each_src_dest(src, dest) do |s, d|
        copy_entry s, d, options[:preserve], options[:dereference_root], options[:remove_destination]
      end
    end

    def copy_entry(src, dest, preserve = false, dereference_root = false, remove_destination = false)
      Entry_.new(src, nil, dereference_root).traverse do |ent|
        destent = Entry_.new(dest, ent.rel, false)

        # puts "#{dir_size(ent.path)} #{ent.path}"
        accumulate_kbytes(ent.path)

        File.unlink destent.path if remove_destination && File.file?(destent.path)
        ent.copy destent.path
        ent.copy_metadata destent.path if preserve
      end
    end

    def fu_each_src_dest(src, dest)
      fu_each_src_dest0(src, dest) do |s, d|
        raise ArgumentError, "same file: #{s} and #{d}" if File.identical?(s, d)
        yield s, d, File.stat(s)
      end
    end

    def fu_each_src_dest0(src, dest)
      if tmp = Array.try_convert(src)
        tmp.each do |s|
          s = File.path(s)
          yield s, File.join(dest, File.basename(s))
        end
      else
        src = File.path(src)
        if File.directory?(dest)
          yield src, File.join(dest, File.basename(src))
        else
          yield src, File.path(dest)
        end
      end
    end

  end   # class Install

  private

  module StreamUtils_
    private

    def fu_windows?
      /mswin|mingw|bccwin|emx/ =~ RUBY_PLATFORM
    end

    def fu_copy_stream0(src, dest, blksize = nil)   #:nodoc:
      IO.copy_stream(src, dest)
    end

    def fu_stream_blksize(*streams)
      streams.each do |s|
        next unless s.respond_to?(:stat)
        size = fu_blksize(s.stat)
        return size if size
      end
      fu_default_blksize()
    end

    def fu_blksize(st)
      s = st.blksize
      return nil unless s
      return nil if s == 0
      s
    end

    def fu_default_blksize
      1024
    end
  end

  include StreamUtils_
  extend StreamUtils_

  class Entry_   #:nodoc: internal use only
    include StreamUtils_

    def initialize(a, b = nil, deref = false)
      @prefix = @rel = @path = nil
      if b
        @prefix = a
        @rel = b
      else
        @path = a
      end
      @deref = deref
      @stat = nil
      @lstat = nil
    end

    def inspect
      "\#<#{self.class} #{path()}>"
    end

    def path
      if @path
        File.path(@path)
      else
        join(@prefix, @rel)
      end
    end

    def prefix
      @prefix || @path
    end

    def rel
      @rel
    end

    def dereference?
      @deref
    end

    def exist?
      lstat! ? true : false
    end

    def file?
      s = lstat!
      s and s.file?
    end

    def directory?
      s = lstat!
      s and s.directory?
    end

    def symlink?
      s = lstat!
      s and s.symlink?
    end

    def chardev?
      s = lstat!
      s and s.chardev?
    end

    def blockdev?
      s = lstat!
      s and s.blockdev?
    end

    def socket?
      s = lstat!
      s and s.socket?
    end

    def pipe?
      s = lstat!
      s and s.pipe?
    end

    S_IF_DOOR = 0xD000

    def door?
      s = lstat!
      s and (s.mode & 0xF000 == S_IF_DOOR)
    end

    def entries
      opts = {}
      opts[:encoding] = ::Encoding::UTF_8 if fu_windows?
      Dir.entries(path(), opts)\
          .reject {|n| n == '.' or n == '..' }\
          .map {|n| Entry_.new(prefix(), join(rel(), n.untaint)) }
    end

    def stat
      return @stat if @stat
      if lstat() and lstat().symlink?
        @stat = File.stat(path())
      else
        @stat = lstat()
      end
      @stat
    end

    def stat!
      return @stat if @stat
      if lstat! and lstat!.symlink?
        @stat = File.stat(path())
      else
        @stat = lstat!
      end
      @stat
    rescue SystemCallError
      nil
    end

    def lstat
      if dereference?
        @lstat ||= File.stat(path())
      else
        @lstat ||= File.lstat(path())
      end
    end

    def lstat!
      lstat()
    rescue SystemCallError
      nil
    end

    def chmod(mode)
      if symlink?
        File.lchmod mode, path() if have_lchmod?
      else
        File.chmod mode, path()
      end
    end

    def chown(uid, gid)
      if symlink?
        File.lchown uid, gid, path() if have_lchown?
      else
        File.chown uid, gid, path()
      end
    end

    def copy(dest)
      case
      when file?
        copy_file dest
      when directory?
        if !File.exist?(dest) and descendant_diretory?(dest, path)
          raise ArgumentError, "cannot copy directory %s to itself %s" % [path, dest]
        end
        begin
          Dir.mkdir dest
        rescue
          raise unless File.directory?(dest)
        end
      when symlink?
        File.symlink File.readlink(path()), dest
      when chardev?
        raise "cannot handle device file" unless File.respond_to?(:mknod)
        mknod dest, ?c, 0666, lstat().rdev
      when blockdev?
        raise "cannot handle device file" unless File.respond_to?(:mknod)
        mknod dest, ?b, 0666, lstat().rdev
      when socket?
        raise "cannot handle socket" unless File.respond_to?(:mknod)
        mknod dest, nil, lstat().mode, 0
      when pipe?
        raise "cannot handle FIFO" unless File.respond_to?(:mkfifo)
        mkfifo dest, 0666
      when door?
        raise "cannot handle door: #{path()}"
      else
        raise "unknown file type: #{path()}"
      end
    end

    def copy_file(dest)
      File.open(path()) do |s|
        File.open(dest, 'wb', s.stat.mode) do |f|
          IO.copy_stream(s, f)
        end
      end
    end

    def copy_metadata(path)
      st = lstat()
      File.utime st.atime, st.mtime, path
      begin
        File.chown st.uid, st.gid, path
      rescue Errno::EPERM
        # clear setuid/setgid
        File.chmod st.mode & 01777, path
      else
        File.chmod st.mode, path
      end
    end

    def remove
      if directory?
        remove_dir1
      else
        remove_file
      end
    end

    def remove_dir1
      platform_support {
        Dir.rmdir path().chomp(?/)
      }
    end

    def remove_file
      platform_support {
        File.unlink path
      }
    end

    def platform_support
      return yield unless fu_windows?
      first_time_p = true
      begin
        yield
      rescue Errno::ENOENT
        raise
      rescue => err
        if first_time_p
          first_time_p = false
          begin
            File.chmod 0700, path()   # Windows does not have symlink
            retry
          rescue SystemCallError
          end
        end
        raise err
      end
    end

    def preorder_traverse
      stack = [self]
      while ent = stack.pop
        yield ent
        stack.concat ent.entries.reverse if ent.directory?
      end
    end

    alias traverse preorder_traverse

    def postorder_traverse
      if directory?
        entries().each do |ent|
          ent.postorder_traverse do |e|
            yield e
          end
        end
      end
      yield self
    end

    private

    $fileutils_rb_have_lchmod = nil

    def have_lchmod?
      # This is not MT-safe, but it does not matter.
      if $fileutils_rb_have_lchmod == nil
        $fileutils_rb_have_lchmod = check_have_lchmod?
      end
      $fileutils_rb_have_lchmod
    end

    def check_have_lchmod?
      return false unless File.respond_to?(:lchmod)
      File.lchmod 0
      return true
    rescue NotImplementedError
      return false
    end

    $fileutils_rb_have_lchown = nil

    def have_lchown?
      # This is not MT-safe, but it does not matter.
      if $fileutils_rb_have_lchown == nil
        $fileutils_rb_have_lchown = check_have_lchown?
      end
      $fileutils_rb_have_lchown
    end

    def check_have_lchown?
      return false unless File.respond_to?(:lchown)
      File.lchown nil, nil
      return true
    rescue NotImplementedError
      return false
    end

    def join(dir, base)
      return File.path(dir) if not base or base == '.'
      return File.path(base) if not dir or dir == '.'
      File.join(dir, base)
    end

    if File::ALT_SEPARATOR
      DIRECTORY_TERM = "(?=[/#{Regexp.quote(File::ALT_SEPARATOR)}]|\\z)".freeze
    else
      DIRECTORY_TERM = "(?=/|\\z)".freeze
    end
    SYSCASE = File::FNM_SYSCASE.nonzero? ? "-i" : ""

    def descendant_diretory?(descendant, ascendant)
      /\A(?#{SYSCASE}:#{Regexp.quote(ascendant)})#{DIRECTORY_TERM}/ =~ File.dirname(descendant)
    end
  end   # class Entry_

end
