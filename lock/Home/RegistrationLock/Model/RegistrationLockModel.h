//
//  RegistrationLockModel.h
//  blueDemo
//
//  Created by mac on 2020/6/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationLockInfoBean : BaseBean

@property(nonatomic,copy)NSString * event_time;//时间
@property(nonatomic,copy)NSString * event_type;//类型
@property(nonatomic,copy)NSString * key_id;//钥匙id
@property(nonatomic,copy)NSString * lock_id;//锁id

@end

@interface RegistrationLockRegRequest : RequestBean

@property(nonatomic,copy)NSString * lockid;//锁ID
@property(nonatomic,copy)NSString * lockname;//锁名称
@property(nonatomic,copy)NSString * lockno;//锁号

@end


@interface RegistrationLockInitBean : BaseBean
@property(nonatomic,copy)NSString * lockid;//锁ID
@property(nonatomic,copy)NSString * keyno;//锁名称
@property(nonatomic,copy)NSString * lockno;//锁号
@end

@interface RegistrationLockInitResponse : ResponseBean
@property (nonatomic,strong)RegistrationLockInitBean * data;
@end
NS_ASSUME_NONNULL_END
