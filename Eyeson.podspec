Pod::Spec.new do |s|

  s.name         = "Eyeson"
  s.version      = "1.0.0"
  s.summary      = "eyeson iOS SDK"
  s.homepage     = "https://www.eyeson.com"
  s.license      = { :type => 'Copyright', :text => "Copyright 2021 Eyeson GmbH"}
  s.author       = { "Eyeson GmbH" => "support@eyeson.com" }
  s.platform     = :ios
  s.ios.deployment_target = '15.0'
  s.swift_version = '5'
  s.info_plist = {
    'CFBundleIdentifier' => 'com.eyeson.sdk'
  }
  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.eyeson.sdk',
    'ENABLE_BITCODE': 'NO',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]': 'x86_64'
  }
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]': 'x86_64'
  }
  s.source = { :git => "git@github.com:eyeson-team/ios-sdk.git", :tag => s.version }
  s.public_header_files = "EyesonSdk.framework/Headers/*.h"
  s.source_files = "EyesonSdk.framework/Headers/*.h"
  s.vendored_frameworks = "EyesonSdk.framework"
  
  s.dependency 'Starscream', '3.1.0'
  s.dependency 'SwiftyJSON'
  s.dependency 'GoogleWebRTC'

end
