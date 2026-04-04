platform:ios, '14.0'

target 'OPherame' do
  #使用frameworks
  use_frameworks!
  #去掉由pod引入的第三方库的警告，需要更新命令才生效
  inhibit_all_warnings!

  pod 'SHToast'
  pod 'IQKeyboardManager'
  pod 'AFNetworking'
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
      # 保持与 Podfile 顶部的 platform 一致，避免 Xcode 提示 deployment target 不在支持范围内
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'

      # Xcode 对 system 私有头（如 netinet6/in6.h）的 module-hygiene 检查比较严格，
      # AFNetworking 的旧代码会触发 "Use of private header..."，这里对 AFNetworking 目标放行并降级为不报错。
      if target.name == 'AFNetworking' || target.name.start_with?('AFNetworking')
        config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'

        other_cflags = config.build_settings['OTHER_CFLAGS']
        other_cflags = [other_cflags] if other_cflags.is_a?(String)
        other_cflags ||= ['$(inherited)']

        unless other_cflags.include?('-Wno-private-header')
          other_cflags << '-Wno-private-header'
        end
        unless other_cflags.include?('-Wno-error=private-header')
          other_cflags << '-Wno-error=private-header'
        end

        config.build_settings['OTHER_CFLAGS'] = other_cflags
      end
    end
  end
end
