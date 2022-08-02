//
//  MyTaskDateModel.h
//  lock
//
//  Created by 金万码 on 2022/7/30.
//  Copyright © 2022 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyTaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LockDateListBean
@end
@interface LockDateListBean : BaseBean
@property(nonatomic,copy)NSString * lockno;//锁编号
@property(nonatomic,copy)NSString * lockname;//锁名称
@end

@protocol UnlockDateListBean
@end
@interface UnlockDateListBean : BaseBean
@property(nonatomic,copy)NSString * begindate;//开始日期
@property(nonatomic,copy)NSString * enddate;//结束日期
@property(nonatomic,strong)NSMutableArray<MyTaskTimeRangeListBean> * timelist;//锁列表
@property(nonatomic,strong)NSMutableArray<LockDateListBean> * locklist;//锁列表
@end

@protocol MyTaskDateListBean
@end
@interface MyTaskDateListBean : BaseBean
@property(nonatomic,copy)NSString * userid;//用户id
@property(nonatomic,copy)NSString * opttype;//操作类型
@property(nonatomic,copy)NSString * workername;//工作名称
@property(nonatomic,copy)NSString * updatetime;//更新时间
@property(nonatomic,copy)NSString * begindate;//开始日期
@property(nonatomic,copy)NSString * keyname;//钥匙名称
@property(nonatomic,copy)NSString * endtime;//结束时间
@property(nonatomic,copy)NSString * enddatetime;//结束日期
@property(nonatomic,copy)NSString * begintime;//开始时间
@property(nonatomic,copy)NSString * enddate;//结束日期
@property(nonatomic,copy)NSString * backid;//id
@property(nonatomic,copy)NSString * workerids;//工作人员id
@property(nonatomic,copy)NSString * taskid;//任务id
@property(nonatomic,copy)NSString * keyid;//钥匙id
@property(nonatomic,copy)NSString * begindatetime;//结束日期
@property(nonatomic,copy)NSString * keyno;//钥匙编号
@property(nonatomic,strong)NSMutableArray<UnlockListBean> * details;//锁列表
@property(nonatomic,copy)NSString * keytype;//钥匙类型
@property(nonatomic,copy)NSString * createtime;//创建时间
@property(nonatomic,copy)NSString * opttime;//操作时间
@property(nonatomic,copy)NSString * keymode;//钥匙
@property(nonatomic,copy)NSString * username;//用户名称
@property(nonatomic,strong)NSMutableArray<UserKeyInfoList> * keylist;//钥匙列表
@property(nonatomic,copy)NSString * subject;//任务名称
@property(nonatomic,copy)NSString * approved;//状态 0-待审核，1-已通过，2-已驳回
@property(nonatomic,assign)BOOL remotefingerprint; // true无线模式 false有线模式
@property(nonatomic,strong)NSMutableArray<UnlockDateListBean> * unlocklist; //开锁日期范围

@end

@interface MyTaskDateListPage : BaseBean
@property (nonatomic,assign)NSInteger pagesize;//每页数量
@property (nonatomic,assign)NSInteger totalcount;//总数
@property (nonatomic,assign)NSInteger page;//当前页
@property (nonatomic,strong)NSMutableArray<MyTaskDateListBean> * content;//开锁
@end

@interface MyTaskDateListResponse : ResponseBean
@property (nonatomic,strong)MyTaskDateListPage * data;
@end

NS_ASSUME_NONNULL_END
