//
//  MapViewController.m
//  lock
//
//  Created by 李金洋 on 2020/3/20.
//  Copyright © 2020 li. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface MapViewController ()<MAMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    MAMapView *_mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;//设置代理也重要
    _mapView.zoomLevel = 14;
    ///把地图添加至view
    [self.view addSubview:_mapView];
    self.view.backgroundColor = [UIColor blueColor];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    //设置定位最小更新距离方法如下，单位米
    self.locationManager.distanceFilter = 200;
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //设置允许在后台定位
    
    //开启持续定位
    [self.locationManager startUpdatingLocation];
    //持续定位返回逆地理编码信息
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;//这句就是开启定位
}
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        NSLog(@"latitude : %f , longitude : %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}
- (UIView *)listView {
    return self.view;
}
@end
