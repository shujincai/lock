//
//  RegistrationKeyTableViewCell.h
//  lock
//
//  Created by 李金洋 on 2020/4/3.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationKeyTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * leftImage;
@property(nonatomic,strong)UIImageView * rightImage;
@property(nonatomic,strong)SZKLabel* topLabel;
@property(nonatomic,strong)SZKLabel* bottomLabel;


@end

NS_ASSUME_NONNULL_END
