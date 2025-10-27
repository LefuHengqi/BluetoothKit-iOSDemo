
Pod::Spec.new do |spec|

  spec.name         = 'abyonCalculate'
  spec.version      = '1.0'
  spec.summary      = 'abyonCalculate is a SDK for Bluetooth.'
  spec.description  = <<-DESC   
  abyonCalculate is a SDK for Bluetooth.
                       DESC
  spec.homepage     = 'https://www.lefu.cc/'
  spec.source       = { :git => '' }
  spec.author       = 'Peng'
  spec.platform     = :ios, '9.0'
  spec.ios.vendored_frameworks = 'abyonCalculate.xcframework'



end
