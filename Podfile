platform:ios, '14.0'

target 'OPherame' do
  #使用frameworks
  use_frameworks!
  #去掉由pod引入的第三方库的警告，需要更新命令才生效
  inhibit_all_warnings!

  pod 'SHToast'
  pod 'IQKeyboardManager'
  pod 'AFNetworking', :git => 'https://github.com/crasowas/AFNetworking.git'
  pod 'YYModel'
  pod 'MBProgressHUD',:git => 'https://github.com/jdg/MBProgressHUD.git', :commit => '18c442d57398cee5ef57f852df10fc5ff65f0763'
  pod 'SDWebImage'
  pod 'FBSDKCoreKit'
end

post_install do |installer|
  # 1. 遍历项目中所有target
  installer.pods_project.targets.each do |target|
     # 2. 遍历build_configurationss
    target.build_configurations.each do |config|
      # 3. 修改build_settings
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end
