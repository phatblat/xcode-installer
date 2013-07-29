require 'yaml'

module XcodeInstaller
  module XcodeVersions

    # General availability
    LATEST_GA = '4.6.3'
    # Developer preview
    LATEST_DP = '5-DP4'

    class ReleaseManager
      attr_accessor :data

      def initialize
        super
        # cnf = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'config.yml'))
        @data = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'xcode-versions.yml'))
        # puts data
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
        list.each { |release|
          if release['version'] == version
            return release
          end
        }
      end
    end

  end
end
