//
//  RangeDatePickerCell.m
//  lock
//
//  Created by 金万码 on 2020/6/6.
//  Copyright © 2020 li. All rights reserved.
//

#import "RangeDatePickerCell.h"

@implementation RangeDatePickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        CALayer *selectionLayer = [[CALayer alloc] init];
        selectionLayer.backgroundColor = [UIColor orangeColor].CGColor;
        selectionLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        self.selectionLayer = selectionLayer;
        
        CALayer *middleLayer = [[CALayer alloc] init];
        middleLayer.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3].CGColor;
        middleLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:middleLayer below:self.titleLabel.layer];
        self.middleLayer = middleLayer;
        
        self.shapeLayer.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.bounds;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    self.selectionLayer.frame = self.contentView.bounds;
    self.middleLayer.frame = self.contentView.bounds;
}

@end
