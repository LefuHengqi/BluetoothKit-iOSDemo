#
#  Be sure to run `pod spec lint PPBluetoothKitDemo.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = 'bluetooth-kit-iosdemo'
  spec.version      = '1.1.4'
  spec.summary      = 'bluetooth-kit-iosdemo is a demo program for PPBluetoothKit.'
  spec.description  = <<-DESC
  bluetooth-kit-iosdemo is a demo program for PPBluetoothKit.
                       DESC
  spec.homepage     = 'https://github.com/LefuHengqi/BluetoothKit-iOSDemo'
  spec.license      = "MIT"
  spec.author       = 'Peng'
  spec.requires_arc = true
  spec.platform     = :ios, '12.0'

  spec.source       = { :git => "https://github.com/LefuHengqi/BluetoothKit-iOSDemo.git", :tag => "#{spec.version}" }
  spec.source_files = 'PPBluetoothKitDemo/Classes/**/*'

  spec.swift_versions = ['5.0']

  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => '' }

  spec.dependency 'PPBluetoothKit'
  spec.dependency 'PPCalculateKit'

end
