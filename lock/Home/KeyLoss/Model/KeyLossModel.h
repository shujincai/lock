//
//  KeyLossModel.h
//  lock
//
//  Created by 金万码 on 2021/2/4.
//  Copyright © 2021 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyLossListRequest : RequestBean

@property (nonatomic,assign)NSInteger page;//页码
@property (nonatomic,assign)NSInteger pagesize;//每页条数
@end

@interface KeyLossDepartmentInfo : BaseBean
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

@protocol KeyLossListBean
@end
@interface KeyLossListBean : BaseBean
@property(nonatomic,strong)KeyLossDepartmentInfo * dept;
@property(nonatomic,copy)NSString * createtime;//创建时间
@property(nonatomic,copy)NSString * factoryno;//设备序列号
@property(nonatomic,copy)NSString * keyflag;//
@property(nonatomic,copy)NSString * keyid;//钥匙id
@property(nonatomic,copy)NSString * keymode;//
@property(nonatomic,copy)NSString * keyname;//钥匙名称
@property(nonatomic,copy)NSString * keyno;//钥匙号
@property(nonatomic,copy)NSString * keystatus;//钥匙状态
@property(nonatomic,copy)NSString * keytype;//钥匙类型
@property(nonatomic,copy)NSString * manager;//管理者
@property(nonatomic,copy)NSString * updatetime;//更新时间
@property(nonatomic,copy)NSString * workerid;//用户id
@property(nonatomic,copy)NSString * workername;//用户名称
@property(nonatomic,copy)NSString * bleflag;//钥匙唯一标志


@end

@interface KeyLossListPage : BaseBean
@property (nonatomic,assign)NSInteger pagesize;//每页数量
@property (nonatomic,assign)NSInteger totalcount;//总数
@property (nonatomic,assign)NSInteger page;//当前页
@property (nonatomic,strong)NSMutableArray<KeyLossListBean> * content;//开锁
@end

@interface KeyLossListResponse : ResponseBean
@property (nonatomic,strong)KeyLossListPage * data;
@end

NS_ASSUME_NONNULL_END
