Pod::Spec.new do |s|
  s.name             = 'GGYYKit'
  s.version          = '0.1.1'
  s.summary          = '修复YYKit兼容等问题'

  s.description      = <<-DESC
    YYKit已经很久不维护，自己封装个Pod，修复YYKit兼容等问题
                       DESC

  s.homepage         = 'https://github.com/github6022244/GGYYKit.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Developer' => '1563084860@gg.com' }
  s.source           = { :git => 'https://github.com/github6022244/GGYYKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  # 将主 spec 拆分为 Core subspec
  s.subspec 'Core' do |core|
    core.source_files = 'GGYYKit/Classes/**/*'
    core.exclude_files = [
      'GGYYKit/Classes/Base/Foundation/NSObject+YYAddForARC.{h,m}',
      'GGYYKit/Classes/Base/Foundation/NSThread+YYAdd.{h,m}'
    ]
    # 如果 Core 中的文件需要使用 NoARC 的头文件，则取消注释下面这行
    core.dependency 'GGYYKit/NoARC'
  end

  # NoARC 子模块：独占管理非 ARC 文件
  s.subspec 'NoARC' do |na|
    na.source_files = [
      'GGYYKit/Classes/Base/Foundation/NSObject+YYAddForARC.{h,m}',
      'GGYYKit/Classes/Base/Foundation/NSThread+YYAdd.{h,m}'
    ]
    na.requires_arc = false
  end

  # 默认包含 Core + NoARC，确保 pod 'GGYYKit' 时加载全部功能
  s.default_subspecs = 'Core', 'NoARC'

  s.pod_target_xcconfig = {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'APPLICATION_EXTENSION_API_ONLY' => 'NO'
  }
end
