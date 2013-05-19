require 'mechanize'
require 'security'

module XcodeDownload
  class Agent < ::Mechanize
    attr_accessor :username, :password, :team

    HOST = "developer.apple.com"
    adc_login_url = 'https://daw.apple.com/cgi-bin/WebObjects/DSAuthWeb.woa/wa/login?appIdKey=d4f7d769c2abecc664d0dadfed6a67f943442b5e9c87524d4587a95773750cea&path=%2F%2Fdownloads%2Findex.action'
    downloads_url = 'https://developer.apple.com/downloads/index.action'

    def initialize
      super
      self.user_agent_alias = 'Mac Safari'

      pw = Security::InternetPassword.find(:server => HOST)
      @username, @password = pw.attributes['acct'], pw.password if pw
    end

    def download
      puts 'Made it into the download method!'
    end

  end
end
