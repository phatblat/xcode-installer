#
# XcodeInstaller::Logout
#

module XcodeInstaller
  class Logout

    def action(args, options)
      say_error "You are not authenticated" and abort unless Security::InternetPassword.find(:server => XcodeInstaller::AppleDeveloperCenter::HOST)

      Security::InternetPassword.delete(:server => XcodeInstaller::AppleDeveloperCenter::HOST)

      say_ok "Account credentials removed"
    end

  end
end
