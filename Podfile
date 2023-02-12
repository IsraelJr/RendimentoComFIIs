# Uncomment the next line to define a global platform for your project
  platform :ios, '13.0'

target 'RendimentoComFIIs' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RendimentoComFIIs
   pod 'Firebase/Analytics'
   pod 'Firebase/Core'
   pod 'Firebase/Database'
   pod 'Firebase/Auth'
   pod 'Firebase/Firestore'
   pod 'FirebaseFirestoreSwift'
   pod 'SwiftSoup'
   pod 'SpreadsheetView'
   pod 'FirebaseAuth'
   pod 'GoogleSignIn'
   pod 'Charts'
   pod 'TinyConstraints'
   pod 'Google-Mobile-Ads-SDK'
   pod 'lottie-ios'



   post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
     config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
   end

end
