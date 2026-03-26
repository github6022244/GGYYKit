Pod::Spec.new do |s|
  s.name             = 'GGYYKit'
  s.version          = '0.1.1'
  s.summary          = '修复 YYKit 兼容等问题'
  s.description      = <<-DESC
    YYKit 已经很久不维护，自己封装个 Pod，修复 YYKit 兼容等问题
                       DESC
  s.homepage         = 'https://github.com/github6022244/GGYYKit.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Developer' => '1563084860@gg.com' }
  s.source           = { :git => 'https://github.com/github6022244/GGYYKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'

  # 完全复制 YYKit 的写法
  s.requires_arc = true
  s.source_files = 'GGYYKit/Classes/**/*'
  
  non_arc_files = [
    'GGYYKit/Classes/Base/Foundation/NSObject+YYAddForARC.{h,m}',
    'GGYYKit/Classes/Base/Foundation/NSThread+YYAdd.{h,m}'
  ]
  
  # 使用 s.ios.exclude_files（与 YYKit 一致）
  s.ios.exclude_files = non_arc_files
  
  # 创建 no-arc subspec
  s.subspec 'no-arc' do |sna|
    sna.requires_arc = false
    sna.source_files = non_arc_files
  end
  
  s.libraries = 'z', 'sqlite3'
  s.frameworks = 'UIKit', 'CoreFoundation', 'CoreText', 'CoreGraphics', 'CoreImage', 'QuartzCore', 'ImageIO', 'Accelerate', 'MobileCoreServices', 'SystemConfiguration'
  s.ios.vendored_frameworks = 'Vendor/WebP.framework'
end
