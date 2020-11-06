//
//  RegistrationKeyModel.h
//  blueDemo
//
//  Created by mac on 2020/6/3.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationKeyInfoBean : BaseBean

@property(nonatomic,copy)NSString * group_id;//一般用来绑定用户的组
@property(nonatomic,copy)NSString * key_id;//钥匙id
@property(nonatomic,copy)NSString * key_time;//钥匙时间
@property(nonatomic,copy)NSString * key_type;//钥匙类型
@property(nonatomic,copy)NSString * key_validity_period_end;//截止时间
@property(nonatomic,copy)NSString * key_validity_period_start;//生效时间
@property(nonatomic,copy)NSString * mac_address;//mac地址
@property(nonatomic,copy)NSString * power;//电量
@property(nonatomic,copy)NSString * read_key_made_time;//读钥匙时间
@property(nonatomic,copy)NSString * read_key_serial_number;//读取密钥序列号
@property(nonatomic,copy)NSString * verify_day;//验证天数
@property(nonatomic,copy)NSString * version;//钥匙版本
@end

//注册钥匙
@interface RegistrationKeyRegRequest : BaseBean
@property(nonatomic,copy)NSString * factoryno;//钥匙硬件编号
@property(nonatomic,copy)NSString * keyid;//钥匙id
@property(nonatomic,copy)NSString * keymode;//钥匙模式（0-普通钥匙、1-巡检钥匙)
@property(nonatomic,copy)NSString * keyname;//钥匙名称
@property(nonatomic,copy)NSString * keyno;//钥匙号
@property(nonatomic,copy)NSString * keystatus;//0钥匙状态
@property(nonatomic,copy)NSString * keytype;//钥匙类型 0-NFC钥匙、1-蓝牙钥匙、2-指纹钥匙
@property(nonatomic,copy)NSString * manager;//钥匙管理人
@property(nonatomic,copy)NSString * deptcode;
@property(nonatomic,copy)NSString * bleflag;//蓝牙唯一标志
@end


NS_ASSUME_NONNULL_END
