//
//  UserModel.h
//  lock
//
//  Created by 李金洋 on 2020/3/30.
//  Copyright © 2020 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//部门信息
@interface UserDepartmentInfo : BaseBean
@property(nonatomic,copy)NSString * children;//
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

@interface UserInfo : BaseBean

@property(nonatomic,copy)NSString * address;//地址
@property(nonatomic,copy)NSString * apppwd;//密码
@property(nonatomic,copy)NSString * approved;//
@property(nonatomic,copy)NSString * appusername;//帐号名称
@property(nonatomic,copy)NSString * createtime;//创建时间
@property(nonatomic,copy)NSString * gender;//性别
@property(nonatomic,copy)NSString * platform;//平台
@property(nonatomic,copy)NSString * regcode;//注册code
@property(nonatomic,copy)NSString * syscode;//系统code
@property(nonatomic,copy)NSString * tel;//电话
@property(nonatomic,copy)NSString * token;//token
@property(nonatomic,copy)NSString * workerid;//用户id
@property(nonatomic,copy)NSString * workername;//用户名称
@property(nonatomic,strong)NSMutableArray * keylist;//钥匙数组
@property(nonatomic,strong)UserDepartmentInfo * dept;//部门信息

@end

//获取token
@interface UserTokenRequest : RequestBean
@property (nonatomic,copy)NSString * username;//帐号
@property (nonatomic,copy)NSString * password;//密码
@end

@interface UserInfoResponse : ResponseBean

@property(nonatomic,strong)UserInfo * data;//用户信息

@end


NS_ASSUME_NONNULL_END
