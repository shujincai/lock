//
//  MainViewController.m
//  lock
//
//  Created by 李金洋 on 2020/3/20.
//  Copyright © 2020 li. All rights reserved.
//

#import "MainViewController.h"
#import "MapViewController.h"
#import "HomeViewController.h"

@interface MainViewController ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>

@property(strong, nonatomic)NSArray<NSString *> *titles;
@property (nonatomic,strong)JXCategoryTitleView * categoryView;
@property (nonatomic,strong)JXCategoryListContainerView * listContainerView;
@property(nonatomic,strong)NSMutableArray * arr;
@end

@implementation MainViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 初始化
    HomeViewController * homeVC = [[HomeViewController alloc]init];
    MapViewController * mapVC = [[MapViewController alloc]init];
    self.arr = [[NSMutableArray alloc]initWithArray:@[homeVC,mapVC]];
    
    self.titles = @[STR_HOMEPAGE,STR_MAP];
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, STATUS_BAR_HEIGHT)];
    [self.view addSubview:topView];
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, UISCREEN_WIDTH, NAV_BAR_HEIGHT)];
    self.categoryView.cellSpacing = 0;
    self.categoryView.titles = self.titles;
    self.categoryView.contentEdgeInsetLeft = 0;
    self.categoryView.contentEdgeInsetRight = 0;
    self.categoryView.averageCellSpacingEnabled = NO;
    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.cellWidth = UISCREEN_WIDTH/2.0;
    self.categoryView.titleFont = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H3);
    self.categoryView.titleSelectedFont = SYSTEM_FONT_OF_SIZE(FONT_SIZE_H2);
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    // 添加指示器
    JXCategoryIndicatorLineView * lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorWidth = UISCREEN_WIDTH/2.0;
    self.categoryView.indicators = @[lineView];
    //关联到categoryView
    //添加试图
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.frame = CGRectMake(0, NAV_HEIGHT, UISCREEN_WIDTH, UISCREEN_HEIGHT - NAV_HEIGHT);
    [self.view addSubview:self.listContainerView];
    self.categoryView.listContainer = self.listContainerView;
if ([CommonUtil getLockType]) {
    topView.backgroundColor = COLOR_BLUE;
    self.categoryView.backgroundColor = COLOR_BLUE;
    self.categoryView.titleSelectedColor = COLOR_WHITE;
    self.categoryView.titleColor = COLOR_WHITE;
    lineView.indicatorColor = COLOR_RED;
} else {
    topView.backgroundColor = COLOR_WHITE;
    self.categoryView.backgroundColor = COLOR_WHITE;
    self.categoryView.titleSelectedColor = COLOR_BTN_BG;
    self.categoryView.titleColor = COLOR_BLACK;
    lineView.indicatorColor = COLOR_BTN_BG;
}
}

//返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}
//根据下标index返回对应遵从`JXCategoryListContentViewDelegate`协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self.arr[index];
}
@end
