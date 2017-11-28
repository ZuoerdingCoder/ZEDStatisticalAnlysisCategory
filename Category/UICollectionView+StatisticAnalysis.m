//
//  UICollectionView+StatisticAnalysis.m
//  ZEDStatisticalAnlysisCategoryDEMO
//
//  Created by 李超 on 2017/11/28.
//  Copyright © 2017年 ZED. All rights reserved.
//

#import "UICollectionView+StatisticAnalysis.h"
#import "ZEDStatisticalAnlysisCategoryConst.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString *const SwizzledDelegateMethod = @"statisticAnalysis_didSelectItemAtIndexPath";

@implementation UICollectionView (StatisticAnalysis)

+ (void)load {
    
    //交换实现UICollectionView的setDelegate方法,用于获取CollectionView的代理类
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setDelegate:)), class_getInstanceMethod(self, @selector(statisticAnalysis_setDelegate:)));
}

#pragma mark - Method Swizzling
- (void)statisticAnalysis_setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    //先执行设置CollectionView代理的方法
    [self statisticAnalysis_setDelegate:delegate];
    
    //获取到CollecitonView的代理类,然后交换代理类中,点击item的方法
    Class class = [delegate class];
    if (class_addMethod([delegate class], NSSelectorFromString(SwizzledDelegateMethod), (IMP)statisticAnalysis_didSelectItemAtIndexPath, "v@:@@")) {
        
        Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(SwizzledDelegateMethod));
        Method swizzledMethod = class_getInstanceMethod(class, @selector(collectionView:didSelectItemAtIndexPath:));
        //交换实现
        method_exchangeImplementations(originalMethod,swizzledMethod);
    }
    
}

void statisticAnalysis_didSelectItemAtIndexPath(id target, SEL _cmd, id collectionView, id indexpath) {
    
    //先执行原代理方法
    SEL selector = NSSelectorFromString(SwizzledDelegateMethod);
    ((void(*)(id, SEL,id, id))objc_msgSend)(target, selector, collectionView, indexpath);
    
    //统计数据缓存
    NSLog(@"Statistic CollectionView: \n ClassName:%@ \n MethodName:%@ \n collectionView:%@ \n section:%ld row:%ld",NSStringFromClass([target class]),NSStringFromSelector(_cmd),collectionView,(long)((NSIndexPath *)indexpath).section,(long)((NSIndexPath *)indexpath).row);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZEDStatisticAnalysisNotificationName object:[collectionView p_paramWithTargetClassName:NSStringFromClass([target class]) selectorName:NSStringFromSelector(_cmd) indexPath:indexpath]];
}

- (NSMutableDictionary *)p_paramWithTargetClassName:(NSString *)targetClassName selectorName:(NSString *)selectorName indexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:targetClassName forKey:kClassNameKey];
    [dic setObject:selectorName forKey:kMethodNameKey];
    [dic setObject:@(ZEDStaticTypeSelectCollectionView) forKey:kStatisticTypeKey];
    return dic;
}

@end
