//
//  AppDelegate.m
//  ImageList
//
//  Created by 纪明 on 2019/12/17.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "BaseTabarViewController.h"
@interface AppDelegate ()<WXApiDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[IQKeyboardManager sharedManager]setEnable:YES];
       [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
       [[IQKeyboardManager sharedManager]setShouldResignOnTouchOutside:YES];
       [self netWorkListener];
       BaseTabarViewController *  vc=[[BaseTabarViewController alloc]init];
                       BaseNavigationViewController  *  nav=[[BaseNavigationViewController alloc]initWithRootViewController:vc];
                       self.window.rootViewController = nav;
         [self.window makeKeyAndVisible];
       [self registerWechat];
    return YES;
}
- (void)registerWechat {
    [WXApi registerApp:WX_APPID universalLink:@"https://kcb-cp.qianr.com/ImageList/"];
}

-(void)onReq:(BaseReq *)req{
    
}
-(void)onResp:(BaseResp *)resp{

    switch (resp.errCode) {
               case 0:
               {
                  
                   SendAuthResp *aresp = (SendAuthResp *)resp;
                   [[NSNotificationCenter defaultCenter] postNotificationName:WXLoginNotification object:self userInfo:@{@"code":aresp.code}];
                   
               }
                   break;
               case -4://用户拒绝授权
                   break;
               case -2://用户取消授权
                   break;
               default:
                   break;
           }
   
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}
#pragma mark - 网络判断
- (void)netWorkListener {
    
    
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                
                self.reachabilityStatus = AFNetworkReachabilityStatusUnknown;
                NSLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                
                self.reachabilityStatus = AFNetworkReachabilityStatusNotReachable;
                NSLog(@"没有网络(断网)");
                [self.window toast:@"当前无网络"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                
                self.reachabilityStatus = AFNetworkReachabilityStatusReachableViaWWAN;
                NSLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
                self.reachabilityStatus = AFNetworkReachabilityStatusReachableViaWiFi;
                NSLog(@"WIFI");
                break;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
}




@end
