//
//  HomeCollectionViewCell.h
//  lock
//
//  Created by 李金洋 on 2020/3/24.
//  Copyright © 2020 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView * image;
@property(nonatomic,strong)SZKLabel* TopLabel;
@property(nonatomic,strong)RKNotificationHub *hub;

@end

NS_ASSUME_NONNULL_END
