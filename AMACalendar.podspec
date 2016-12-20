#
#  Be sure to run `pod spec lint AMACalendar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "AMACalendar"
  s.version      = "0.0.2"
  s.summary      = "This is a Chinese calendar."

  s.homepage     = "https://github.com/Ama4Q/AMACalendar"
  s.license      = "MIT"
  s.author       = { "Ama.Qiu" => "77095260@qq.com" } 
  s.source       = { :git => "https://github.com/Ama4Q/AMACalendar.git", :tag => s.version.to_s }

  s.ios.deployment_target = "9.0"

  s.pod_target_xcconfig = {
    "SWIFT_VERSION" => "3.0"
  }

  s.source_files  = "Sources/CLib/*.swift"
  s.resources = "Sources/CLib/AMACalendar.bundle"

  s.requires_arc = true

end
