Pod::Spec.new do |s|
  s.name         = "MWePOSBuilder"
  s.version      = "0.0.2"
  s.summary      = "A library for interacting with the ePOS API."
  s.homepage     = "https://github.com/mediweb/MWePOSBuilder"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Matthew Gillingham" => "gillygize@gmail.com" }
  s.source       = { :git => "https://github.com/mediweb/MWePOSBuilder.git", :tag => "0.0.2" }
  s.source_files = 'MWePOSBuilder/src/*.{h,m}'
  s.requires_arc = true
  s.dependency 'GData/XMLNode', '~> 1.9.1'
  s.dependency 'Base64', '~> 1.0.1'
end
