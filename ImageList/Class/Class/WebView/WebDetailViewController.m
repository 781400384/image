//
//  WebDetailViewController.m
//  PlayFootBall
//
//  Created by 纪明 on 2019/12/13.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "WebDetailViewController.h"
#import <BUAdSDK/BUAdSDK.h>
#import <AdSupport/AdSupport.h>
#import "WKWebViewJavascriptBridge.h"
#define APPID  @"5042778"
#define advertisingID @"942650753"
#import "OtherWebViewController.h"
#import "LoginViewController.h"
@interface WebDetailViewController ()<BUNativeExpressRewardedVideoAdDelegate>
@property (strong, nonatomic) WKWebView                *webView;
@property (strong, nonatomic) UIProgressView     *progressView;
//@property (strong, nonatomic) JSContext          *context;
@property (nonatomic, strong) BUNativeExpressRewardedVideoAd        *rewardedAd;
@property (nonatomic, strong) WKWebViewJavascriptBridge  *bridge;
@property (nonatomic, strong) NSString           *ggkID;


@end

@implementation WebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self addLeftReturnButton];
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
      
      NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.linkUrl]];
      [self.webView.scrollView setBounces:NO];
      [self.webView loadRequest:request];
      [self.view addSubview:self.webView];
      
      self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
      [self.bridge setWebViewDelegate:self];
      
//      WeakSelf;
      //
      [self.bridge registerHandler:@"userInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
          
         NSString *token =[UserInfoDefaults userInfo].token;
          NSLog(@"token = %@",token);
          if (!token.length) {
              token = @"";
          }
          NSString *version = [NSString getVersion];
          NSString *packageName = [NSString getBundleIdentifier];
          NSString *uuid = [NSString getDeviceUUID];
          
          NSString *result = [NSString stringWithFormat:@"{\"token\":\"%@\", \"version\":\"%@\",\"packageName\":\"%@\",\"uuid\":\"%@\"}",token,version,packageName,uuid];
          
         responseCallback(result);
      }];
      
      
      //关闭页面
      [self.bridge registerHandler:@"closeWebview" handler:^(id data, WVJBResponseCallback responseCallback) {
          [self popViewController];
      }];
      
      //播放激励视频
      [self.bridge registerHandler:@"seeAd" handler:^(id data, WVJBResponseCallback responseCallback) {
          
         self.ggkID = [[NSString alloc] initWithFormat:@"%@",data[@"id"]];
          //data:  1.穿山甲 3.腾讯  5.百度
              [self seeAdWithType:[data[@"type"] integerValue]];
      }];
      
      //去评论
      [self.bridge registerHandler:@"evaluate" handler:^(id data, WVJBResponseCallback responseCallback) {
          [self toComment];
      }];
      
      //去登录
      [self.bridge registerHandler:@"jumpLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
          [self toLogin];
//          [self popViewController];
      }];
      
      //去登录
      [self.bridge registerHandler:@"jumpSet" handler:^(id data, WVJBResponseCallback responseCallback) {
          [self toLogin];
//          [self popViewController];
      }];
      
      //回首页
      [self.bridge registerHandler:@"jumpHome" handler:^(id data, WVJBResponseCallback responseCallback) {
          [self popViewController];
      }];
      
      //回我的页面
      [self.bridge registerHandler:@"jumpMe" handler:^(id data, WVJBResponseCallback responseCallback) {
          [self toMe];
          [self popViewController];
      }];
      
      //跳转相应URL
      [self.bridge registerHandler:@"jumpUrl" handler:^(id data, WVJBResponseCallback responseCallback) {
          
          [self jumpUrl:data[@"url"]];
      }];
      
      
      //分享到微信
      [self.bridge registerHandler:@"jumpWechat" handler:^(id data, WVJBResponseCallback responseCallback) {
          NSLog(@"data = %@",data);
          //分享内容在data中
          [self jumpWXWithContent:data[@"data"]];
      }];
}
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.naviView.hidden=YES;
}
- (void)seeAdWithType:(NSInteger)type {
    [BUAdSDKManager setAppID:APPID];
    [BUAdSDKManager setIsPaidApp:NO];
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = @"123";
    self.rewardedAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:advertisingID rewardedVideoModel:model];
           self.rewardedAd.delegate = self;
           [self.rewardedAd loadAdData];
}
- (void)toLogin {
   LoginViewController  *  vc=[[LoginViewController alloc]init];
     __weak __typeof(self)weakSelf = self;
      BaseNavigationViewController *loginNav = [[BaseNavigationViewController alloc]initWithRootViewController:vc];
     vc.loginSuccessBlock = ^{
         [loginNav dismissViewControllerAnimated:YES completion:^{
                 
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     
                   [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:weakSelf userInfo:nil];
                     [self popViewController];
                     
                 });
             }];
             
         };
    [self presentViewController:loginNav animated:YES completion:nil];
   
}

- (void)toMe {
    [self.tabBarController setSelectedIndex:4];
}

- (void)toComment {
    NSString *itunesUrl = @"https://apps.apple.com/cn/app/id149158974";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesUrl]];
}

- (void)jumpUrl:(NSString *)url {
    OtherWebViewController *vc = [[OtherWebViewController alloc]init];
    vc.linkUrl = url;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)jumpWXWithContent:(NSString *)content{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"content";

    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }else {
       //未安装微信
    }
}


///穿山甲广告
#pragma mark - BUNativeExpressRewardedVideoAdDelegate
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    
    
}


- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error
{
    NSLog(@"error = %@",error.localizedDescription);
    [self.bridge callHandler:@"errorAd" data:nil responseCallback:^(id responseData) {

    }];
}


- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{

}


- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    if (self.rewardedAd.isAdValid) {
         [self.rewardedAd showAdFromRootViewController:self.navigationController];
    }
}


- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error
{
    //告诉js激励视频出现错误
    [self.bridge callHandler:@"errorAd" data:nil responseCallback:^(id responseData) {

    }];
    NSLog(@"error==============-------- = %@",error.localizedDescription);
}


- (void)nativeExpressRewardedVideoAdWillVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{

}



- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{

}


- (void)nativeExpressRewardedVideoAdWillClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{

}

/**
 This method is called when video ad is closed.
 */
- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    //[self.rewardedAd loadAdData];
}

/**
 This method is called when video ad is clicked.
 */
- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{

}

/**
 This method is called when the user clicked skip button.
 */
- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{

}

/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error
{

    if (error) { //如果错误
        [self.bridge callHandler:@"errorAd" data:nil responseCallback:^(id responseData) {

        }];
    } else {

        NSString *result = [NSString stringWithFormat:@"%@",self.ggkID];

        //告诉js激励视频播放完毕
        [self.bridge callHandler:@"endAd" data:result responseCallback:^(id responseData) {

        }];

    }
}

/**
 Server verification which is requested asynchronously is succeeded.
 @param verify :return YES when return value is 2000.
 */
- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify
{

}

/**
 Server verification which is requested asynchronously is failed.
 Return value is not 2000.
 */
- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    //告诉js激励视频出现错误
    [self.bridge callHandler:@"errorAd" data:nil responseCallback:^(id responseData) {

    }];
}



@end
