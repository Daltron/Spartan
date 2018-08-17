
Pod::Spec.new do |s|
  s.name             = 'Spartan'
  s.version          = '1.2.0'
  s.summary          = 'An Elegant Spotify Web API Library Written in Swift for iOS and macOS'

  s.description      = 'Spartan is a lightweight, elegant, and easy to use Spotify Web API wrapper library for iOS written in Swift 3. Under the hood, Spartan makes request to the Spotify Web API. Those requests are then turned into clean, friendly, and easy to use objects.'
  s.homepage         = 'https://github.com/daltron/Spartan'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dhint4' => 'daltonhint4@gmail.com' }
  s.source           = { :git => 'https://github.com/daltron/Spartan.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'

  s.source_files = 'Spartan/Classes/**/*'
  
  s.dependency 'AlamoRecord', '~> 1.2.0'
end
