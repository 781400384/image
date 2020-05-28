//
//  AppDelegate.h
//  ImageList
//
//  Created by 纪明 on 2019/12/17.
//  Copyright © 2019 纪明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AFNetworkReachabilityManager.h>
typedef NS_ENUM(NSUInteger,ReachStatus){
    
    ReachStatusWiFi = 0,//WiFi
    ReachStatusWWAN,//手机数据
    ReachStatusUnable,//无网络
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow * window;
@property (nonatomic, assign) ReachStatus                      reachStatus;
@property (nonatomic, assign) AFNetworkReachabilityStatus      reachabilityStatus;

@end

