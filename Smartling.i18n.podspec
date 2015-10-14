Pod::Spec.new do |s|
  s.name         = 'Smartling.i18n'
  s.version      = '1.0.11'
  s.summary      = 'iOS Plurals Localization Library'
  s.homepage     = 'https://github.com/Smartling/ios-i18n'
  s.license      = { :type => 'APACHE', :file => 'LICENSE' }
  s.author       = 'Pavel Ivashkov'

  s.ios.platform = :ios, '3.2'
  s.ios.deployment_target = '3.2'

  s.osx.platform = :osx, '10.4'
  s.osx.deployment_target = '10.6'

  s.source       = { :git => 'https://github.com/Smartling/ios-i18n.git', :tag => "v#{s.version}" }
  s.source_files = 'Smartling.i18n/*.{h,m,c}'
end
