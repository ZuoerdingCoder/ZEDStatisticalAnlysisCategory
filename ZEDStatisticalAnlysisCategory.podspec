

Pod::Spec.new do |s|

  s.name         = "ZEDStatisticalAnlysisCategory"
  s.version      = "0.0.1"
  s.summary      = "一个使用AOP实现IOS应用内响应事件相关数据统计的分类"

  s.homepage     = "https://github.com/lichao1992/ZEDStatisticalAnlysisCategory"
  s.license      = "MIT"
  s.author             = { "李超" => "964139523@qq.com" }

  s.source       = { :git => "https://github.com/lichao1992/ZEDStatisticalAnlysisCategory.git", :tag => s.version }
  s.source_files  = "Category/**/*.{h,m}"
  s.requires_arc = true
  s.frameworks = 'UIKit','Foundation'
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'


end
