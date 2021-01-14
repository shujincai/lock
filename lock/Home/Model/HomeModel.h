//
//  HomeModel.h
//  lock
//
//  Created by 李金洋 on 2020/3/31.
//  Copyright © 2020 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyInfoDetailResponse : ResponseBean

@property (nonatomic,strong)UserKeyInfoList * data;

@end


NS_ASSUME_NONNULL_END
