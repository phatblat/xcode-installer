command :login do |c|
  c.syntax = 'xcodedl login'
  c.summary = 'Save account credentials'
  c.description = ''

  c.action do |args, options|
    say_warning "You are already authenticated" if Security::InternetPassword.find(:server => XcodeDownload::AppleDeveloperCenter::HOST)

    user = ask "Username:"
    pass = password "Password:"

    Security::InternetPassword.add(XcodeDownload::AppleDeveloperCenter::HOST, user, pass)

    say_ok "Account credentials saved"
  end
end
