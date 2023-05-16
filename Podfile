# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'PokeGuide' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for PokeGuide
  pod 'SnapKit'
  pod 'SDWebImage'
  pod 'RealmSwift'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Moya/RxSwift'
  pod 'XLPagerTabStrip'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['GCC_SYMBOLS_PRIVATE_EXTERN'] = 'NO'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end
