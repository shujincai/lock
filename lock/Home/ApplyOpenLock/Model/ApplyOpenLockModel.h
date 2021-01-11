//
//  ApplyOpenLockModel.h
//  lock
//
//  Created by 金万码 on 2020/12/30.
//  Copyright © 2020 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//获取锁列表

@interface ApplyOpenLockTreeRequest : RequestBean

@property(nonatomic,copy)NSString * deptids;

@end

@protocol ApplyOpenLockTreeBean
@end
@interface ApplyOpenLockTreeBean : BaseBean
@property(nonatomic,copy)NSString * label; // 锁名称
@property(nonatomic,copy)NSString * value; // 锁id
@property(nonatomic,copy)NSString * labelWithDept; // 锁名称和部门名称
@end

@interface ApplyOpenLockTreePage : BaseBean
@property (nonatomic,assign)NSInteger pagesize;//每页数量
@property (nonatomic,assign)NSInteger totalcount;//总数
@property (nonatomic,assign)NSInteger page;//当前页
@property (nonatomic,strong)NSMutableArray<ApplyOpenLockTreeBean> * content;//锁列表
@end

@interface ApplyOpenLockTreeResponse : ResponseBean
@property (nonatomic,strong)ApplyOpenLockTreePage * data;
@end

@interface ApplyOpenLockTaskRequest : RequestBean
@property (nonatomic,strong)NSArray<NSString*> * daterange;//日期
@property (nonatomic,strong)NSArray<NSString*> * deptids;//部门
@property (nonatomic,strong)NSArray<NSString*> * keynos;//钥匙
@property (nonatomic,strong)NSArray<NSString*> * locknos;//锁
@property(nonatomic,copy)NSString * subject; // 任务名称
@property (nonatomic,strong)NSArray * timerangelist;//时间段
@end

NS_ASSUME_NONNULL_END
