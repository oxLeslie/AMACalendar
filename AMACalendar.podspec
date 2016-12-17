Pod::Spec.new do |s|

  s.name         = ‘AMACalendar'
  s.version      = ‘0.0.1’
  s.license      = 'MIT'
  s.summary      = 'A Chinese calendar.'
  s.homepage     = 'https://github.com/Ama4Q/AMACalendar'
  s.author       = { 'Ama.Qiu' => '77095260@qq.com' }
  s.source       = { :git => 'https://github.com/Ama4Q/AMACalendar.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '3.0',
  }

  s.requires_arc = 'true'

  s.source_files  = 'Sources/CLib/*.swift'
  s.resources = 'Sources/images/*.png'
end
