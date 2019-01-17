Pod::Spec.new do |s|
s.name         = "BeerKit"
s.version      = "1.0.0"
s.summary      = "The framework which is for MultipeerConnectivity."
s.description  = <<-DESC
- The framework which is for MultipeerConnectivity inspired by PeerKit.
DESC

s.homepage     = "https://github.com/kboy-silvergym/BeerKit"
s.license      = "MIT"
s.author             =   "Kei Fujikawa"
s.social_media_url   = "http://twitter.com/kboy_silvergym"
s.platform     = :ios, "10.0"
s.source       = { :git => "https://github.com/kboy-silvergym/BeerKit", :tag => s.version }
s.source_files  = "BeerKit/**/*.swift"
s.swift_version = '4.2'
end
