//
//  SXTLocationManager.h
//  尚学堂映客
//
//  Created by JohnnyCheng on 2016/9/28.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LocationBlock)(NSString * lat,NSString * lon);

@interface SXTLocationManager : NSObject

+ (instancetype) sharedLocationManager;


- (void)getGps:(LocationBlock)block;

@property (nonatomic,copy) NSString * lat;
@property (nonatomic,copy) NSString * lon;

@end
