//
//  ZEDStatisticalAnlysisCategoryConst.h
//  ZEDStatisticalAnlysisCategoryDEMO
//
//  Created by 李超 on 2017/11/28.
//  Copyright © 2017年 ZED. All rights reserved.
//

#ifndef ZEDStatisticalAnlysisCategoryConst_h
#define ZEDStatisticalAnlysisCategoryConst_h

//通知名称
static NSString * const ZEDStatisticAnalysisNotificationName = @"ZEDStatisticAnalysisNotificationName";

//上抛通知参数Key
static NSString *const kClassNameKey = @"ClassName";
static NSString *const kMethodNameKey = @"MethodName";
static NSString *const kStatisticTypeKey = @"StatisticType";

//统计的事件类型
typedef NS_ENUM(NSInteger,ZEDStaticType) {
    ZEDStaticTypeSelectTableView,             //选中TableView Cell
    ZEDStaticTypeSelectCollectionView,        //选中CollectionView Cell
    ZEDStaticTypeSwitchViewController,        //页面切换
    ZEDStaticTypeReponseControlAction,        //UIControl的响应事件
};


#endif /* ZEDStatisticalAnlysisCategoryConst_h */
