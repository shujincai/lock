//
//  ResponseBean.h
//  lock
//
//  Created by admin on 2020/5/19.
//  Copyright © 2020 li. All rights reserved.
//

#import "BaseBean.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResponseBean : BaseBean

// 错误码
@property (nonatomic, copy)NSString *resultCode;
@property (nonatomic, copy)NSString *statusCode;
// 错误信息
@property (nonatomic, copy) NSString *msg;

@end

NS_ASSUME_NONNULL_END
