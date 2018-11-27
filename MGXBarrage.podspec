#
# Be sure to run `pod lib lint MGXBarrage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MGXBarrage'
  s.version          = '0.5.0'
  s.summary          = 'iOS弹幕库.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  针对以下需求开发:
  1. 弹幕由屏幕右侧匀速运动至屏幕左侧, 直至完全消失
  2. 支持多条弹道, 每条弹道可以展示不同样式的弹幕
  3. 弹幕速度固定,同一弹道内的弹幕要有最小间隔
  4. 同一弹道内的弹幕不会重叠
  5. 弹幕可以点击
                       DESC

  s.homepage         = 'https://github.com/changjianfeishui/MGXBarrage'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mongox' => '329735967@qq.com' }
  s.source           = { :git => 'https://github.com/changjianfeishui/MGXBarrage.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'MGXBarrage/Classes/**/*'
  
  
  # s.resource_bundles = {
  #   'MGXBarrage' => ['MGXBarrage/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
