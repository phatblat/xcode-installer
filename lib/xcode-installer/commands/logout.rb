command :logout do |c|
  c.syntax = 'xcode-installer logout'
  c.summary = 'Remove account credentials'
  c.description = ''

  c.action do |args, options|
    say_error "You are not authenticated" and abort unless Security::InternetPassword.find(:server => XcodeInstaller::AppleDeveloperCenter::HOST)

    Security::InternetPassword.delete(:server => XcodeInstaller::AppleDeveloperCenter::HOST)

    say_ok "Account credentials removed"
  end
end
