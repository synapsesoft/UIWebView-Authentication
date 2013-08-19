Pod::Spec.new do |s|
  s.name         = 'UIWebViewAuthentication'
  s.version      = '1.0.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary      = 'Basic and Digest Access Authentication support for iOS UIWebView.'
  s.author       = { 'Synapsesoft, Inc.' =>'kusatsugu@synapsesoft.co.jp' }
  s.source       = { :git => '~/workspace/UIWebViewAuthentication', :tag => "v#{s.version}", :submodules => true }
  s.platform     = :ios, '5.0'
  s.source_files = 'UIWebViewAuthentication/**/*.{h,m}'
  s.frameworks   = 'Foundation', 'Security', 'QuartzCore'
  s.requires_arc = true
end
