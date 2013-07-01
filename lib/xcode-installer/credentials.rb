require 'security'

module XcodeInstaller
  class Credentials
    attr_accessor :username, :password, :hostname

    def initialize
      super
      @hostname = XcodeInstaller::AppleDeveloperCenter::HOST
    end

    def load
      pw = Security::InternetPassword.find(:server => @hostname)
      @username, @password = pw.attributes['acct'], pw.password if pw
    end

    def ask
          #def username
          #  @username ||= ask "Username:"
          #end
          #def password
          #  @password ||= pw "Password:"
          #end
      @username = ask "Username:"
      @password = pw "Password:"
      ask "Save these credentials in your keychain?"
    end

    def save
      #say_warning "You are already authenticated" if Security::InternetPassword.find(:server => @hostname)

      Security::InternetPassword.add(@hostname, @username, @password)

      say_ok "Account credentials saved"
    end

  end
end
