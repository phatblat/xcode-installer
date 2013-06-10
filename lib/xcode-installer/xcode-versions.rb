module XcodeInstaller
  module XcodeVersions

    LATEST = '4.6.2'

    GUI = {
      '4.6.2' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/xcode_4.6.2/xcode4620419895a.dmg', # 2013-04-15
      '4.6.1' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/xcode_4.6.1/xcode4610419628a.dmg', # 2013-03-14
      '4.6'   => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/xcode_4.6/xcode460417218a.dmg'     # 2013-02-20
    }

    # Assuming Mountain Lion for now
    CLI = {
      '4.6.2' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/command_line_tools_os_x_mountain_lion_for_xcode__april_2013/xcode462_cltools_10_86938259a.dmg', # 2013-04-15
      '4.6.1' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/command_line_tools_os_x_mountain_lion_for_xcode__march_2013/xcode461_cltools_10_86938245a.dmg', # 2013-03-14
      '4.6' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/command_line_tools_os_x_mountain_lion_for_xcode__january_2013/xcode46cltools_10_86938131a.dmg'    # 2013-02-19
    }

  # Lion => {
  # '4.6.2' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/command_line_tools_os_x_lion_for_xcode__april_2013/xcode462_cltools_10_76938260a.dmg'
  # }

  end
end
