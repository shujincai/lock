//
//  SystemParameterModel.h
//  lock
//
//  Created by 金万码 on 2020/6/11.
//  Copyright © 2020 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//修改密码

@interface ChangePasswordRequest : RequestBean
@property(nonatomic,copy)NSString * newpwd;//新密码
@property(nonatomic,copy)NSString * oldpwd;//旧密码
@end

NS_ASSUME_NONNULL_END
