//
//  WorkListModel.h
//  lock
//
//  Created by 李金洋 on 2020/3/31.
//  Copyright © 2020 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockRecordListRequest : RequestBean
@property (nonatomic,copy)NSString * begintime;//开关锁开始时间
@property (nonatomic,copy)NSString * endtime;//开关锁截止时间
@property (nonatomic,assign)NSInteger page;//页码
@property (nonatomic,assign)NSInteger pagesize;//每页条数
@end

//开锁记录
@protocol LockRecordListBean
@end
@interface LockRecordListBean : BaseBean
@property(nonatomic,copy)NSString * deptname;//部门名称
@property(nonatomic,copy)NSString * keyname;//钥匙名称
@property(nonatomic,copy)NSString * keytype;//钥匙类型
@property(nonatomic,copy)NSString * opttime;
@property(nonatomic,copy)NSString * lockname;//锁名称
@property(nonatomic,copy)NSString * eventtype;
@end

@interface LockRecordListPage : BaseBean
@property (nonatomic,assign)NSInteger pagesize;//每页数量
@property (nonatomic,assign)NSInteger totalcount;//总数
@property (nonatomic,assign)NSInteger page;//当前页
@property (nonatomic,strong)NSMutableArray<LockRecordListBean> * content;//开锁
@end

@interface LockRecordListResponse : ResponseBean
@property (nonatomic,strong)LockRecordListPage * data;
@end

NS_ASSUME_NONNULL_END
