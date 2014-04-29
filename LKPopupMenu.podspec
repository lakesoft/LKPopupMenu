Pod::Spec.new do |s|
  s.name         = "LKPopupMenu"
  s.version      = "1.0.0"
  s.summary      = "Popup menu library"
  s.description  = <<-DESC
Popup menu library
                   DESC
  s.homepage     = "https://github.com/lakesoft/LKPopupMenu"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Hiroshi Hashiguchi" => "xcatsan@mac.com" }
  s.source       = { :git => "https://github.com/lakesoft/LKPopupMenu.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Classes/*'

end
