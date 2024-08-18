# Uncomment the next line to define a global platform for your project
  platform :ios, '13.0'

target 'RendimentoComFIIs' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RendimentoComFIIs
   pod 'SwiftSoup'
   pod 'SpreadsheetView'
   pod 'GoogleSignIn'
   pod 'Charts'
   pod 'TinyConstraints'
   pod 'Google-Mobile-Ads-SDK'
   pod 'lottie-ios'


      post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
         config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end

      installer.generated_projects.each do |project|
         project.targets.each do |target|
            target.build_configurations.each do |config|
               config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
            end
         end
      end
   end

end