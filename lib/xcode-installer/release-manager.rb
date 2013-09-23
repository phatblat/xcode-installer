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

    def get_release(version, include_beta)
      version ||= 'latest'
      include_beta ||= false
      interface_type ||= 'gui'

      list = data[interface_type]
      if version == 'latest' && include_beta
        version = LATEST_DP
      elsif version == 'latest'
        version = LATEST_GA
      end
      list.each { |release|
        if release['version'] == version
          return release
        end
      }
    end
  end

end
