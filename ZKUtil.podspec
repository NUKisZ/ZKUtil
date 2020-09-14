#
# Be sure to run `pod lib lint ZKUtil.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZKUtil'
  # 版本要和git的tag版本一致
  s.version          = '0.0.3'
  # 描述
  s.summary          = '个人使用 ZKUtil 工具.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        私有Pods测试
                        * Markdown 格式
                        DESC
#TODO: Add long description of the pod here.
#                       DESC
# 主页信息网址
  s.homepage         = 'https://blog.uilucky.com'
  # 截图地址
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # 证书 一般用下面的格式 如果用了其他的格式 需要相应的修改
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  # 作者信息及邮箱
  s.author           = { 'NUKisZ' => '738355248@qq.com' }
  # spec配置文件的位置
  # s.source           = { :git =>'/Users/zhangkun/Desktop/final', :tag => '0.0.1' }
  s.source           = { :git => 'https://github.com/NUKisZ/ZKUtil.git', :tag => s.version.to_s }
  # 媒体文件
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  # 工程依赖系统版本
  s.ios.deployment_target = '8.0'
  # 源文件 包含 h,m
  s.source_files = 'Sources/ZKUtil/**/*'

  # 资源文件 .png/.bundle等(多个)
  # s.resource_bundles = {
  #   'ZKUtil' => ['ZKUtil/Assets/*.png']
  # }

  # 公开头文件 打包只公开特定的头文件
  # s.public_header_files = 'SOCRLib/Classes/head/SOCR.h'
  # 调试公开所有的头文件 这个地方下面的头文件 如果是在Example中调试 就公开全部，需要打包就只公开特定的h文件
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # 私有头文件
  # subcfiles.private_header_files = "MyLibrary/cfiles/**/*.h"
  # 是否是静态库 这个地方很重要 假如不写这句打出来的包 就是动态库 不能使用 一运行会报错 image not found
  s.static_framework  =  true
  # 载入第三方.a (如paynuc.a这种)
  #s.vendored_libraries = 'SOCRLib/Classes/openssl/include/*.{a}'
  # 载入第三方.a头文件
  #s.xcconfig = { 'USER_HEADER_SEARCH_PATHS' => 'SOCRLib/Classes/openssl/include/openssl/*.{h}' }
  # 链接设置 重要
  # s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'}
  # 系统动态库(多个)
  # s.frameworks = 'UIKit', 'MapKit'
  # 第三方开源框架(多个)
  # s.dependency 'AFNetworking', '~> 2.3'
  s.swift_version = '5.2'
  # 系统类库(多个) 注意:系统类库不需要写全名 去掉开头的lib
  # s.libraries = 'stdc++'
end
# 编写SDK相关逻辑代码均在Classes下面，路径千万不要放错，不然pod install的时候会不见，图片放入Assets下面。
# cd 到含有ZKUtil.podspec 文件下，然后执行

# pod lib lint ZKUtil.podspec --allow-warnings --use-libraries

# 然后cd到Example，执行

# pod update --verbose --no-repo-update (或 进入Example文件夹，执行pod install)

# 回到上层目录，cd .. 开始提交，给当前版本打tag

# git add .

# git commit -a -m'v请换成版本号'

# git tag -a 版本号 -m'v版本号'

# 上传到github
# git push origin master

# 最后一步，打包，大功告成

# pod package ZKUtil.podspec --library --force    打包成.a文件。--force是指强制覆盖

# pod package ZKUtil.podspec --force              打包成.framework文件
