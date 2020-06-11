//
//  WorkListTableViewCell.h
//  lock
//
//  Created by 李金洋 on 2020/3/31.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkListTableViewCell : UITableViewCell
@property(nonatomic,strong)SZKLabel * topLabel;
@property(nonatomic,strong)SZKLabel *  middleLabel;
@property(nonatomic,strong)SZKLabel *  bottomLabel;

@end

NS_ASSUME_NONNULL_END
