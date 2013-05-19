require 'mechanize'
require 'security'

module XcodeDownload
  class Agent < ::Mechanize
    attr_accessor :username, :password, :verbose, :dry_run

    HOST = "developer.apple.com"

    def initialize
      super
      self.user_agent_alias = 'Mac Safari'

      pw = Security::InternetPassword.find(:server => HOST)
      @username, @password = pw.attributes['acct'], pw.password if pw
    end

    def download(xcode_url)
      adc_login_url = 'https://daw.apple.com/cgi-bin/WebObjects/DSAuthWeb.woa/wa/login?appIdKey=d4f7d769c2abecc664d0dadfed6a67f943442b5e9c87524d4587a95773750cea&path=%2F%2Fdownloads%2Findex.action'
      downloads_url = 'https://developer.apple.com/downloads/index.action'

      begin
        # Request login response
        puts "\n>>> Login response >>>" if @verbose
        response = get(adc_login_url)
        if @verbose
          puts "status code: #{response.code}\n"
          pp response
          puts cookie_jar.jar
        end

        # Submit login form
        puts "\n>>> Submit Login Form >>>" if @verbose
        form = response.form_with(:name => 'appleConnectForm')
        form.theAccountName = username
        form.theAccountPW = password
        response = form.submit
        if @verbose
          puts "status code: #{response.code}\n"
          pp response
          puts cookie_jar.jar
        end

        # Request downloads response
        puts "\n>>> Downloads >>>" if @verbose
        response = get(downloads_url)
        if @verbose
          puts "status code: #{response.code}\n"
          pp response
          puts cookie_jar.jar
        end

        # Download
        puts "\n>>> Xcode >>>" if @verbose

        if @dry_run
          # HEAD request for testing
          response = head(xcode_url)
          if @verbose
            puts "status code: #{response.code}\n"
            pp response
          else
            puts "filename: #{response.filename}"
            puts "size: #{response.header['content-length']}"
            puts "last-modified: #{response.header['last-modified']}"
          end
        else
          # GET request for actual download
          pluggable_parser.default = Mechanize::Download
          file = get(xcode_url)
          file.save
          puts file.filename
        end

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
