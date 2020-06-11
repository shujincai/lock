//
//  SZKLabel.h
//  lock
//
//  Created by 李金洋 on 2020/3/23.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZKLabel : UILabel
+(instancetype)labelWithFrame:(CGRect)frame
           text:(NSString *)text
      textColor:(UIColor *)textColor
           font:(UIFont *)font
  textAlignment:(NSTextAlignment)textAlignment
backgroundColor:(UIColor *)bgColor;
@end

NS_ASSUME_NONNULL_END
