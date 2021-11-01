source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.3'
use_frameworks!

target 'AudioFetch-SDK-Sample' do
    pod 'AFNetworking', '~> 4.0'
    pod 'MBProgressHUD', '~> 1.1.0'
end


# Needed for ios simulator on m1 apple silicon
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
