#
# Be sure to run `pod lib lint Spartan.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Spartan'
  s.version          = '1.1.0'
  s.summary          = 'An Elegant Spotify Web API Library Written in Swift for iOS and macOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Spartan is a lightweight, elegant, and easy to use Spotify Web API wrapper library for iOS written in Swift 3. Under the hood, Spartan makes request to the Spotify Web API. Those requests are then turned into clean, friendly, and easy to use objects.'
  s.homepage         = 'https://github.com/daltron/Spartan'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dhint4' => 'daltonhint4@gmail.com' }
  s.source           = { :git => 'https://github.com/daltron/Spartan.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'

  s.source_files = 'Spartan/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Spartan' => ['Spartan/Assets/*.png']
  # }

  s.dependency 'AlamoRecord', '~> 1.1.1'
end
