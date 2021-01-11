//
//  OpenLockAuditModel.h
//  Vanmalock
//
//  Created by 金万码 on 2021/1/5.
//  Copyright © 2021 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenLockAuditRequest : RequestBean

@property(nonatomic,copy)NSString * auth; // 审核状态：1-通过，2-驳回

@end

NS_ASSUME_NONNULL_END
