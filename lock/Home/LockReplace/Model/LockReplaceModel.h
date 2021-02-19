//
//  LockReplaceModel.h
//  lock
//
//  Created by 金万码 on 2021/2/7.
//  Copyright © 2021 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockReplaceListRequest : RequestBean

@property (nonatomic,assign)NSInteger page;//页码
@property (nonatomic,assign)NSInteger pagesize;//每页条数
@end

@interface LockReplaceDepartmentInfo : BaseBean
@property(nonatomic,copy)NSString * createtime;//创建时间
@property(nonatomic,copy)NSString * deptcode;//部门号码
@property(nonatomic,copy)NSString * deptid;//部门id
@property(nonatomic,copy)NSString * deptname;//部门名称
@property(nonatomic,copy)NSString * deptpwd;//部门密码
@property(nonatomic,copy)NSString * parentid;//上级部门id
@property(nonatomic,copy)NSString * remark;//备注
@property(nonatomic,copy)NSString * sequence;//序列
@property(nonatomic,copy)NSString * updatetime;//更新时间
@end

// 获取已领出钥匙列表

@protocol LockReplaceListBean
@end
@interface LockReplaceListBean : BaseBean
@property(nonatomic,strong)LockReplaceDepartmentInfo * dept;
@property(nonatomic,copy)NSString * blng;//经度
@property(nonatomic,copy)NSString * blat;//纬度
@property(nonatomic,copy)NSString * replacetime;//替换时间
@property(nonatomic,copy)NSString * locksn;//
@property(nonatomic,copy)NSString * lockstatus;//锁状态 0未安装 1已安装 2损坏 3维修
@property(nonatomic,copy)NSString * createtime;//创建时间
@property(nonatomic,copy)NSString * glng;//经度
@property(nonatomic,copy)NSString * glat;//纬度
@property(nonatomic,copy)NSString * lockno;//锁号
@property(nonatomic,copy)NSString * lng;//经度
@property(nonatomic,copy)NSString * lat;//纬度
@property(nonatomic,copy)NSString * updatetime;//更新时间
@property(nonatomic,copy)NSString * locksite;//网站
@property(nonatomic,copy)NSString * factoryno;//设备序列号
@property(nonatomic,copy)NSString * locknohm;//
@property(nonatomic,copy)NSString * lockid;//锁id
@property(nonatomic,copy)NSString * lockname;//锁名称


@end

@interface LockReplaceListPage : BaseBean
@property (nonatomic,assign)NSInteger pagesize;//每页数量
@property (nonatomic,assign)NSInteger totalcount;//总数
@property (nonatomic,assign)NSInteger page;//当前页
@property (nonatomic,strong)NSMutableArray<LockReplaceListBean> * content;//开锁
@end

@interface LockReplaceListResponse : ResponseBean
@property (nonatomic,strong)LockReplaceListPage * data;
@end

//获取锁详情

@interface LockReplaceDetailResponse : ResponseBean
@property (nonatomic,strong)LockReplaceListBean * data;
@end

//锁替换

@interface LockReplaceRequest : RequestBean

@property(nonatomic,copy)NSString * newlockno;//新锁编号
@property(nonatomic,copy)NSString * replacereason;//替换原因

@end
NS_ASSUME_NONNULL_END
