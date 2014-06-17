require 'mechanize'
require 'security'

module XcodeInstaller
  class Agent < ::Mechanize
    attr_accessor :username, :password, :verbose, :dry_run, :show_progress

    def initialize
      super
      self.user_agent_alias = 'Mac Safari'

      pw = Security::InternetPassword.find(:server => XcodeInstaller::AppleDeveloperCenter::HOST)
      @username, @password = pw.attributes['acct'], pw.password if pw
    end

    def download(xcode_url)
      adc_login_url = XcodeInstaller::AppleDeveloperCenter::LOGIN_URL
      downloads_url = XcodeInstaller::AppleDeveloperCenter::DOWNLOADS_URL

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
        # Shouldn't get the login form if login was successful
        form = response.form_with(:name => 'appleConnectForm')
        raise UnsuccessfulAuthenticationError if form

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
            return response.filename
          end
        else
          # GET request for actual download
          pluggable_parser.default = Mechanize::Download
          if @show_progress
            require 'mechanize-progrezzbar'
            self.progressbar{ file = get(xcode_url) }
          end
          file = get(xcode_url)
          file.save
          return file.filename
        end

      rescue Mechanize::ResponseCodeError => exception
        if exception.response_code == '403'
          response = exception.page
          puts "The file doesn't exist at that location or access denied (status code: #{response.code})\n"
          puts "\n>>> Unexpected response >>>" if @verbose
          pp response if @verbose
        else
          raise # Some other error, re-raise
        end
      end
    end

  end
end
