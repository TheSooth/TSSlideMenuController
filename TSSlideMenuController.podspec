Pod::Spec.new do |s|
  s.name         = "TSSlideMenuController"
  s.version      = "0.0.1"
  s.summary      = "Slide-out menu controller."
  s.homepage     = "https://github.com/TheSooth/TSSlideMenuController"

  s.license      = { :type => 'Apache License 2.0', :file => 'LICENSE' }

  s.author       = { "TheSooth" => "thesooth@aol.com" }

  s.source       = { :git => "https://github.com/TheSooth/TSSlideMenuController.git", :tag => "#{s.version}" }
  s.platform     = :ios, '5.0'
  s.source_files = 'TSSlideMenuController/Code', 'TSSlideMenuController/Code/**/*.{h,m}'
  s.framework  = 'UIKit'
  s.requires_arc = true
end
