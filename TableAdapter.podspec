Pod::Spec.new do |spec|

  spec.name         = "TableAdapter"
  spec.version      = "1.1.0"
  spec.summary      = "A data-driven library for building complex table views easily"
  spec.description  = "A data-driven library for building complex table views. Easy updating table view items with animations using automatic diffing algorithm under the hood. Our goal is to think in terms of data but not in terms of index paths while building tables. High-level yet flexible api allows to setup sectioned lists in a few lines of code and take more control over the table where it needed. And configuring reusable views in a type-safe manner helps to keep code clean and stable"
  spec.homepage     = "https://github.com/MobileUpLLC/TableAdapter"

  spec.license      = "MIT"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "Nikolai Timonin, MobileUp" => "nt@mobileup.ru" }

  spec.platform     = :ios, "9.0"
  spec.ios.frameworks = 'UIKit'
  spec.swift_version = ['4.2', '5']
  
  spec.source = { :git => 'https://github.com/MobileUpLLC/TableAdapter.git', :tag => spec.version.to_s }
  spec.source_files  = "Source/", "Source/**/*.{swift}"
end
