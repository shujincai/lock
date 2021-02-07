//
//  BlackListModel.h
//  lock
//
//  Created by 金万码 on 2021/2/4.
//  Copyright © 2021 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 获取黑名单列表

@interface  BlackListRequest : RequestBean
@property (nonatomic,assign)NSInteger keytype;//钥匙类型（0NFC钥匙、1蓝牙钥匙、2指纹钥匙）
@property (nonatomic,assign)NSInteger page;//页码
@property (nonatomic,assign)NSInteger pagesize;//每页条数
@end

@protocol BlackListBean
@end
@interface BlackListBean : BaseBean
@property(nonatomic,copy)NSString * blackid;//黑名单id
@property(nonatomic,copy)NSString * keyno;//钥匙号
@property(nonatomic,copy)NSString * deptid;//部门id
@property(nonatomic,copy)NSString * createtime;//创建时间
@property(nonatomic,copy)NSString * endtime;//结束时间
@property(nonatomic,copy)NSString * keytype;//钥匙类型
@property(nonatomic,copy)NSString * userid;//操作人id
@property(nonatomic,copy)NSString * deptname;//部门名称
@property(nonatomic,copy)NSString * keyname;//钥匙名称
@property(nonatomic,copy)NSString * deptcode;//部门编码
@property(nonatomic,copy)NSString * keyid;//钥匙id
@property(nonatomic,copy)NSString * username;//用户名称
@property(nonatomic,copy)NSString * keymode;//


@end

@interface BlackListPage : BaseBean
@property (nonatomic,assign)NSInteger pagesize;//每页数量
@property (nonatomic,assign)NSInteger totalcount;//总数
@property (nonatomic,assign)NSInteger page;//当前页
@property (nonatomic,strong)NSMutableArray<BlackListBean> * content;//开锁
@end

@interface BlackListResponse : ResponseBean
@property (nonatomic,strong)BlackListPage * data;
@end

NS_ASSUME_NONNULL_END
