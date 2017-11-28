//
//  UITableView+StatisticAnalysis.m
//  ZEDStatisticalAnlysisCategoryDEMO
//
//  Created by 李超 on 2017/11/28.
//  Copyright © 2017年 ZED. All rights reserved.
//

#import "UITableView+StatisticAnalysis.h"
#import "ZEDStatisticalAnlysisCategoryConst.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString *const SwizzledDelegateMethod = @"statisticAnalysis_didSelectRowAtIndexPath";

@implementation UITableView (StatisticAnalysis)

+ (void)load {
    
    //交换实现UITableView的setDelegate方法,用于获取TableView的代理类
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setDelegate:)), class_getInstanceMethod(self, @selector(statisticAnalysis_setDelegate:)));
}

#pragma mark - Method Swizzling
- (void)statisticAnalysis_setDelegate:(id<UITableViewDelegate>)delegate {
    
    //先执行设置TableView代理的方法
    [self statisticAnalysis_setDelegate:delegate];
    
    //获取到TableView的代理类,然后交换代理类中,点击cell的方法
    Class class = [delegate class];
    if (class_addMethod(class, NSSelectorFromString(SwizzledDelegateMethod), (IMP)statisticAnalysis_didSelectRowAtIndexPath, "v@:@@")) {
        Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(SwizzledDelegateMethod));
        Method swizzledMethod = class_getInstanceMethod(class, @selector(tableView:didSelectRowAtIndexPath:));
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

void statisticAnalysis_didSelectRowAtIndexPath(id target, SEL _cmd, id tableView, id indexpath)
{
    //先执行原代理方法
    SEL selector = NSSelectorFromString(SwizzledDelegateMethod);
    ((void(*)(id, SEL,id, id))objc_msgSend)(target, selector, tableView, indexpath);
    
    //统计数据缓存
    NSLog(@"Statistic TableView: \n ClassName:%@ \n MethodName:%@ \n tableView:%@ \n section:%ld row:%ld",NSStringFromClass([target class]),NSStringFromSelector(_cmd),tableView,(long)((NSIndexPath *)indexpath).section,(long)((NSIndexPath *)indexpath).row);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZEDStatisticAnalysisNotificationName object:[tableView p_paramWithTargetClassName:NSStringFromClass([target class]) selectorName:NSStringFromSelector(_cmd) indexPath:indexpath]];
}

- (NSMutableDictionary *)p_paramWithTargetClassName:(NSString *)targetClassName selectorName:(NSString *)selectorName indexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:targetClassName forKey:kClassNameKey];
    [dict setObject:selectorName forKey:kMethodNameKey];
    [dict setObject:@(ZEDStaticTypeSelectTableView) forKey:kStatisticTypeKey];
    return dict;
}

@end
