#
# XcodeInstaller::Login
#

module XcodeInstaller
  class Login

    def action(args, options)
      say_warning "You are already authenticated" if Security::InternetPassword.find(:server => XcodeInstaller::AppleDeveloperCenter::HOST)

      user = ask "Username:"
      pass = password "Password:"

      Security::InternetPassword.add(XcodeInstaller::AppleDeveloperCenter::HOST, user, pass)

      say_ok "Account credentials saved"
    end

  end
end
