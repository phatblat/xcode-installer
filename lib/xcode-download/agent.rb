require 'mechanize'
require 'security'

module XcodeDownload
  class Agent < ::Mechanize
    attr_accessor :username, :password, :team

    HOST = "developer.apple.com"

    def initialize
      super
      self.user_agent_alias = 'Mac Safari'

      pw = Security::InternetPassword.find(:server => HOST)
      @username, @password = pw.attributes['acct'], pw.password if pw
    end

    def download
      puts 'Made it into the download method!'

      adc_login_url = 'https://daw.apple.com/cgi-bin/WebObjects/DSAuthWeb.woa/wa/login?appIdKey=d4f7d769c2abecc664d0dadfed6a67f943442b5e9c87524d4587a95773750cea&path=%2F%2Fdownloads%2Findex.action'
      downloads_url = 'https://developer.apple.com/downloads/index.action'
      xcode_url = XcodeDownload::XcodeVersions::GUI[XcodeDownload::XcodeVersions::LATEST]

      begin
        # Request login response
        puts "\n>>> Login response >>>"
        response = get(adc_login_url)
        puts "status code: #{response.code}\n"
        pp response
        puts cookie_jar.jar

        # Submit login form
        puts "\n>>> Submit Login Form >>>"
        form = response.form_with(:name => 'appleConnectForm')
        form.theAccountName = username
        form.theAccountPW = password
        response = form.submit
        puts "status code: #{response.code}\n"
        pp response
        puts cookie_jar.jar

        # Request downloads response
        puts "\n>>> Downloads >>>"
        response = get(downloads_url)
        puts "status code: #{response.code}\n"
        pp response
        puts cookie_jar.jar

        # Download
        puts "\n>>> Xcode >>>"

        # HEAD request for testing
        response = head(xcode_url)
        puts "status code: #{response.code}\n"
        pp response

        # GET request for actual download
        # pluggable_parser.default = Mechanize::Download
        # file = get(xcode_url)
        # file.save
        # puts file.filename

      rescue Mechanize::ResponseCodeError => exception
        if exception.response_code == '403'
          response = exception.page
          puts "status code: #{response.code}\n"
          pp response
          puts cookie_jar.jar
        else
          raise # Some other error, re-raise
        end
      end
    end

  end
end
