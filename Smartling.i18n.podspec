Pod::Spec.new do |s|
  s.name         = 'Smartling.i18n'
  s.version      = '1.0.14'
  s.summary      = 'iOS Plurals Localization Library'
  s.homepage     = 'https://github.com/Smartling/ios-i18n'
  s.license      = { :type => 'APACHE', :file => 'LICENSE' }
  s.author       = 'Pavel Ivashkov'

  s.ios.deployment_target = '3.2'
  s.osx.deployment_target = '10.6'
  s.watchos.deployment_target = '2.0'

  s.source       = { :git => 'https://github.com/Smartling/ios-i18n.git', :tag => "v#{s.version}" }
  s.source_files = 'Smartling.i18n/*.{h,m,c}'
end
