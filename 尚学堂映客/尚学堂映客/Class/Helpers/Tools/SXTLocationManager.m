//
//  SXTLocationManager.m
//  尚学堂映客
//
//  Created by JohnnyCheng on 2016/9/28.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTLocationManager.h"
#import <CoreLocation/CoreLocation.h>
@interface SXTLocationManager()<CLLocationManagerDelegate>//遵守协议

@property (nonatomic,strong) CLLocationManager *locManager;
@property (nonatomic,copy) LocationBlock block;

@end



@implementation SXTLocationManager
+ (instancetype)sharedLocationManager{
    
    static SXTLocationManager *_manager;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        _manager = [[SXTLocationManager alloc]init];
    });
    
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _locManager = [[CLLocationManager alloc]init];
        [_locManager setDesiredAccuracy:kCLLocationAccuracyBest];//精确度
        _locManager.distanceFilter = 100;
        _locManager.delegate = self;
        if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"开启服务");
        }else{
            
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];//结构体
            if (status==kCLAuthorizationStatusNotDetermined) {
                [_locManager requestWhenInUseAuthorization];
            }
        
        }
        
    }
    return self;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    
    CLLocationCoordinate2D coor = locations[0].coordinate;
    
    NSString *lat = [NSString stringWithFormat:@"%@",@(coor.latitude)];
    
    NSString *lon = [NSString stringWithFormat:@"%@",@(coor.longitude)];

    [SXTLocationManager sharedLocationManager].lat = lat;
    [SXTLocationManager sharedLocationManager].lon = lon;

 
    
    self.block(lat,lon);
    
    
    [self.locManager stopUpdatingHeading];

}


- (void)getGps:(LocationBlock)block{

    self.block = block;

    //开始定位的请求
    [self.locManager startUpdatingLocation];
    


}




@end
