Pod::Spec.new do |s|
  s.name             = 'GGYYKit'
  s.version          = '0.1.0'
  s.summary          = '修复YYKit兼容等问题'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    YYKit已经很久不维护，自己封装个Pod，修复YYKit兼容等问题
                       DESC

  s.homepage         = 'https://github.com/github6022244/GGYYKit.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Developer' => '1563084860@gg.com' }
  s.source           = { :git => 'https://github.com/github6022244/GGYYKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.default_subspecs = 'NoARC'

  s.source_files = 'GGYYKit/Classes/**/*'
  
  # 排除非 ARC 文件，避免被主 spec 重复包含
  s.exclude_files = [
    'GGYYKit/Classes/Base/Foundation/NSObject+YYAddForARC.m',
    'GGYYKit/Classes/Base/Foundation/NSThread+YYAdd.m'
  ]

  # 非 ARC 子模块
  s.subspec 'NoARC' do |na|
    na.source_files = [
      'GGYYKit/Classes/Base/Foundation/NSObject+YYAddForARC.m',
      'GGYYKit/Classes/Base/Foundation/NSThread+YYAdd.m'
    ]
    na.compiler_flags = '-fno-objc-arc'
    # 确保头文件也能被正确引用
    na.header_dir = 'GGYYKit'
  end
  
  # 针对过期API的警告忽略设置
  s.pod_target_xcconfig = {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'APPLICATION_EXTENSION_API_ONLY' => 'NO'
  }
  
  # s.resource_bundles = {
  #   'GGYYKit' => ['GGYYKit/Assets/*.png']
  # }

  # s.public_header_files = 'GGYYKit/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
