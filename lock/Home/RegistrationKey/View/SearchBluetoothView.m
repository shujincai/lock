

//
//  SearchBluetoothView.m
//  blueDemo
//
//  Created by mac on 2020/6/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SearchBluetoothView.h"

static CGFloat lineWidth = 4.0f;

@implementation SearchBluetoothView
{
    CADisplayLink *_link;
    CAShapeLayer *_animationLayer;
    
    CGFloat _startAngle;
    CGFloat _endAngle;
    CGFloat _progress;
}

+(SearchBluetoothView*)showIn:(UIView*)view{
    [self hideIn:view];
    SearchBluetoothView *hud = [[SearchBluetoothView alloc] initWithFrame:view.bounds];
    [hud start];
    [view addSubview:hud];
    return hud;
}
+(SearchBluetoothView *)hideIn:(UIView *)view{
    SearchBluetoothView *hud = nil;
    for (SearchBluetoothView *subView in view.subviews) {
        if ([subView isKindOfClass:[SearchBluetoothView class]]) {
            [subView hide];
            [subView removeFromSuperview];
            hud = subView;
        }
    }
    return hud;
}

-(void)start{
if ([CommonUtil getLockType]) {
    _animationLayer.strokeColor = COLOR_BLUE.CGColor;
} else {
    _animationLayer.strokeColor = COLOR_BTN_BG.CGColor;
}
    _link.paused = false;
}

-(void)hide{
    _animationLayer.strokeColor = COLOR_NONE.CGColor;
    _link.paused = true;
    _progress = 0;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI{
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"trans_capture_resume"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    _animationLayer = [CAShapeLayer layer];
    _animationLayer.bounds = CGRectMake(0, 0, 70, 70);
    _animationLayer.position = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0);
    _animationLayer.fillColor = [UIColor clearColor].CGColor;
if ([CommonUtil getLockType]) {
    _animationLayer.strokeColor = COLOR_BLUE.CGColor;
} else {
    _animationLayer.strokeColor = COLOR_BTN_BG.CGColor;
}
    _animationLayer.lineWidth = lineWidth;
    _animationLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_animationLayer];
    
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link.paused = true;
    
    
}
- (void)searchBtnClick {
    if (_link.paused == true) {
        [self start];
    }else {
        [self hide];
    }
    self.searchBluetoothBlock(_link.paused);
}
-(void)displayLinkAction{
    _progress += [self speed];
    if (_progress >= 1) {
        _progress = 0;
    }
    [self updateAnimationLayer];
}

-(void)updateAnimationLayer{
    _startAngle = -M_PI_2;
    _endAngle = -M_PI_2 +_progress * M_PI * 2;
    if (_endAngle > M_PI) {
        CGFloat progress1 = 1 - (1 - _progress)/0.25;
        _startAngle = -M_PI_2 + progress1 * M_PI * 2;
    }
    CGFloat radius = _animationLayer.bounds.size.width/2.0f - lineWidth/2.0f;
    CGFloat centerX = _animationLayer.bounds.size.width/2.0f;
    CGFloat centerY = _animationLayer.bounds.size.height/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:true];
    path.lineCapStyle = kCGLineCapRound;
    
    _animationLayer.path = path.CGPath;
}

-(CGFloat)speed{
    if (_endAngle > M_PI) {
        return 0.3/70.0f;
    }
    return 2/70.0f;
}
@end
