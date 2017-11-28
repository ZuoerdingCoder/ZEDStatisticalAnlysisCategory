//
//  UIViewController+StatisticAnalysis.m
//  ZEDStatisticalAnlysisCategoryDEMO
//
//  Created by 李超 on 2017/11/28.
//  Copyright © 2017年 ZED. All rights reserved.
//

#import "UIViewController+StatisticAnalysis.h"
#import "ZEDStatisticalAnlysisCategoryConst.h"
#import <objc/runtime.h>

@implementation UIViewController (StatisticAnalysis)

+ (void)load {
    
    // 交换实现UIViewController的viewWillAppear方法
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillAppear:)),class_getInstanceMethod(self, @selector(statisticAnalysis_viewWillAppear:)));
    
    //交换实现UIViewController的viewWillDisappear方法
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillDisappear:)), class_getInstanceMethod(self, @selector(statisticAnalysis_viewWillDisappear:)));
}

#pragma mark - Method Swizzling
- (void)statisticAnalysis_viewWillAppear:(BOOL)animated {
    
    //先执行UIViewController的viewWillAppear方法
    [self statisticAnalysis_viewWillAppear:animated];
    
    //统计数据缓存
    NSLog(@"Statistic Controller: \n  ClassName:%@ ViewWillAppear",NSStringFromClass([self class]));
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZEDStatisticAnalysisNotificationName object:[self p_paramWithMethodName:@"viewWillAppear:"]];
}

- (void)statisticAnalysis_viewWillDisappear:(BOOL)animated {
    
    [self statisticAnalysis_viewWillDisappear:animated];
    
    //统计数据缓存
    NSLog(@"Statistic Controller: \n  ClassName:%@ viewWillDisappear",NSStringFromClass([self class]));
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZEDStatisticAnalysisNotificationName object:[self p_paramWithMethodName:@"viewWillDisappear:"]];
}

-(NSMutableDictionary *)p_paramWithMethodName:(NSString *)methodName {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:NSStringFromClass([self class]) forKey:kClassNameKey];
    [dict setObject:methodName forKey:kMethodNameKey];
    [dict setObject:@(ZEDStaticTypeSwitchViewController) forKey:kStatisticTypeKey];
    return dict;
}

@end
