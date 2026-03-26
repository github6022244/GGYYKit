Pod::Spec.new do |s|
  s.name             = 'GGYYKit'
  s.version          = '0.1.0'
  s.summary          = '修复YYKit兼容等问题'

  s.description      = <<-DESC
    YYKit已经很久不维护，自己封装个Pod，修复YYKit兼容等问题
                       DESC

  s.homepage         = 'https://github.com/github6022244/GGYYKit.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Developer' => '1563084860@gg.com' }
  #s.source           = { :git => 'https://github.com/github6022244/GGYYKit.git', :tag => s.version.to_s }
  s.source = { :git => 'git@github.com:github6022244/GGYYKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.default_subspecs = 'NoARC'

  # 主要源文件（排除非ARC相关的.m文件）
  s.source_files = 'GGYYKit/Classes/**/*'
  s.exclude_files = [
    'GGYYKit/Classes/Base/Foundation/NSObject+YYAddForARC.m',
    'GGYYKit/Classes/Base/Foundation/NSThread+YYAdd.m'
  ]

  # 非 ARC 子模块 - 包含头文件和实现文件
  s.subspec 'NoARC' do |na|
    na.source_files = [
      'GGYYKit/Classes/Base/Foundation/NSObject+YYAddForARC.{h,m}',
      'GGYYKit/Classes/Base/Foundation/NSThread+YYAdd.{h,m}'
    ]
    na.compiler_flags = '-fno-objc-arc'
    na.requires_arc = false
  end
  
  # 针对过期API的警告忽略设置
  s.pod_target_xcconfig = {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'APPLICATION_EXTENSION_API_ONLY' => 'NO'
  }
end
