# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'IronSource_iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

 pod 'DIOSDK', '4.8.1'
 pod 'IronSourceSDK','9.6.1.0'
 #pod 'IronSourceAdQualitySDK','7.18.1'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
