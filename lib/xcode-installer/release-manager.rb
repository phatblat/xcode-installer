require 'yaml'

module XcodeInstaller
  class ReleaseManager
    attr_accessor :data

    def initialize
      super
      @data = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'xcode-versions.yml'))
    end

    def get_all(interface_type)
      interface_type ||= 'gui'
      list = data[interface_type]
      return list
    end

    def get_release(version, include_beta, interface_type)
      version ||= 'latest'
      include_beta ||= false
      interface_type ||= 'gui'

      list = data[interface_type]
      if version == 'latest' && include_beta
        version = LATEST_DP
      elsif version == 'latest'
        version = LATEST_GA
      end

      os_version = `sw_vers -productVersion`
      # Drop the patch number
      os_version = os_version.match(/\d+\.\d+/)[0]

      list.each { |release|
        if release['version'].to_s == version
          if release['interface_type'] == 'gui'
            # gui releases aren't limited by OS
            return release
          elsif release['interface_type'] == 'cli' && release['os_version'].to_s == os_version
            return release
          else
            puts "Unknown interface type #{release['interface_type']}"
          end
        end
      }
    end
  end

end
