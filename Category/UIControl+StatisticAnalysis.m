//
//  UIControl+StatisticAnalysis.m
//  ZEDStatisticalAnlysisCategoryDEMO
//
//  Created by 李超 on 2017/11/28.
//  Copyright © 2017年 ZED. All rights reserved.
//

#import "UIControl+StatisticAnalysis.h"
#import "ZEDStatisticalAnlysisCategoryConst.h"
#import <objc/runtime.h>

@implementation UIControl (StatisticAnalysis)

+ (void)load
{
    //交换实现UIControl的sendAction:to:forEvent:方法
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(sendAction:to:forEvent:)), class_getInstanceMethod(self, @selector(statisticAnalysis_sendAction:to:forEvent:)));
}

#pragma mark - Method Swizzling
- (void)statisticAnalysis_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    //先执行原方法
    [self statisticAnalysis_sendAction:action to:target forEvent:event];
    
    NSLog(@"Statistic UIControl: \n ClassName:%@ \n MethodName:%@",NSStringFromClass([target class]),NSStringFromSelector(action));
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZEDStatisticAnalysisNotificationName object:[self p_paramWithTarget:target action:action event:event]];
}


#pragma mark - Private
- (NSMutableDictionary *)p_paramWithTarget:(id)target action:(SEL)action event:(UIEvent *)event {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:NSStringFromClass([target class]) forKey:kClassNameKey];
    NSString *actionName = NSStringFromSelector(action);
    if ([actionName hasPrefix:@"nbs_"]) {
        actionName = [actionName substringFromIndex:4];
    }
    [dict setObject:actionName forKey:kMethodNameKey];
    [dict setObject:@(ZEDStaticTypeReponseControlAction) forKey:kStatisticTypeKey];

    return dict;
}

@end
