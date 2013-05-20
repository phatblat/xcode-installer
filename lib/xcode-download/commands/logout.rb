command :logout do |c|
  c.syntax = 'xcodedl logout'
  c.summary = 'Remove account credentials'
  c.description = ''

  c.action do |args, options|
    say_error "You are not authenticated" and abort unless Security::InternetPassword.find(:server => XcodeDownload::AppleDeveloperCenter::HOST)

    Security::InternetPassword.delete(:server => XcodeDownload::AppleDeveloperCenter::HOST)

    say_ok "Account credentials removed"
  end
end
