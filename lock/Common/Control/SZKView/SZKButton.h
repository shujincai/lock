//
//  SZKButton.h
//  lock
//
//  Created by 李金洋 on 2020/3/23.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^STButtonTouchAction)(UIButton* sender);

@interface SZKButton : UIButton
- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString*)title
                   titleColor:(UIColor*)titlecolor
                    titleFont:(CGFloat)fongtsize
                 cornerRadius:(CGFloat)radiu
              backgroundColor:(UIColor*)color
              backgroundImage:(UIImage*)image
                        image:(UIImage*)image;
@property(nonatomic,copy)STButtonTouchAction    clicAction;

//点击回调
- (void)setClicAction:(STButtonTouchAction)clicAction;
@end

NS_ASSUME_NONNULL_END
