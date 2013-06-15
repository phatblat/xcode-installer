module XcodeInstaller
  module XcodeVersions

    # General availability
    LATEST_GA = '4.6.3'
    # Developer preview
    LATEST_DP = '5-DP'

    GUI = {
      '5-DP' => 'https://developer.apple.com/devcenter/download.action?path=/wwdc_2013/xcode_5_developer_preview/xcode_5_developer_preview.dmg', # 2013-06-10
      '4.6.3' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/xcode_4.6.3/xcode4630916281a.dmg', # 2013-06-13
      '4.6.2' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/xcode_4.6.2/xcode4620419895a.dmg', # 2013-04-15
      '4.6.1' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/xcode_4.6.1/xcode4610419628a.dmg', # 2013-03-14
      '4.6'   => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/xcode_4.6/xcode460417218a.dmg'     # 2013-02-20
    }

    # Assuming Mountain Lion for now
    CLI = {
      '5-DP' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/command_line_tools_os_x_mountain_lion_for_xcode_5__june_2013/command_line_tools_mountain_lion_for_xcode_5_june_2013.dmg', # 2013-06-10
      '4.6.3' => 'https://developer.apple.com/downloads/download.action?path=wwdc_2013/command_line_tools_os_x_v10.9_for_xcode_5__june_2013/command_line_tools_os_x_v10.9_for_xcode_5_developer_preview.dmg', # 2013-06-14
      '4.6.2' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/command_line_tools_os_x_mountain_lion_for_xcode__april_2013/xcode462_cltools_10_86938259a.dmg', # 2013-04-15
      '4.6.1' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/command_line_tools_os_x_mountain_lion_for_xcode__march_2013/xcode461_cltools_10_86938245a.dmg', # 2013-03-14
      '4.6' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/command_line_tools_os_x_mountain_lion_for_xcode__january_2013/xcode46cltools_10_86938131a.dmg'    # 2013-02-19
    }

  # Lion => {
  # '4.6.2' => 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/command_line_tools_os_x_lion_for_xcode__april_2013/xcode462_cltools_10_76938260a.dmg'
  # }

  end
end
