//
//  UIImage+Helper.h
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Helper)

+(UIImage*)mm_imageWithColor:(UIColor*)color;

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end

NS_ASSUME_NONNULL_END
