//
//  WebViewViewController.m
//  ClassSchedule
//
//  Created by 纪明 on 2019/11/26.
//  Copyright © 2019 Superme. All rights reserved.
//

#import "WebViewViewController.h"
#import <WebKit/WebKit.h>
@interface WebViewViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.naviTitleLabel.text=@"详情";
   WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];

    config.selectionGranularity = WKSelectionGranularityDynamic;

    config.allowsInlineMediaPlayback = YES;

    WKPreferences *preferences = [WKPreferences new];

    //是否支持JavaScript

    preferences.javaScriptEnabled = YES;

    //不通过用户交互，是否可以打开窗口

    preferences.javaScriptCanOpenWindowsAutomatically = YES;

    config.preferences = preferences;

    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        WKUserContentController* userContent = [[WKUserContentController alloc] init];
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        [userContent addScriptMessageHandler:self name:@"NativeMethod"];
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent;

    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];

    [self.view addSubview:webview];

    /* 加载服务器url的方法*/

    NSString *url = self.url;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    [webview loadRequest:request];

    webview.navigationDelegate = self;

    webview.UIDelegate = self;


}
#pragma mark - WKNavigationDelegate
/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
}
/* 开始返回内容 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
     
}
/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
     
}
/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
     
}
/* 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

  NSURL *url =  navigationAction.request.URL;
    
    NSString *urlStr = url.absoluteString;
    NSLog(@"【load url】=== %@", urlStr);
   //不允许跳转
   //decisionHandler(WKNavigationActionPolicyCancel);
   //return;

    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
}
/* 在收到响应后，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
     
    NSLog(@"===%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

// 接收到服务器跳转请求之后调用

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {

    NSLog(@"-------接收到服务器跳转请求之后调用");

}

// 数据加载发生错误时调用

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

    NSLog(@"----数据加载发生错误时调用");

}

// 需要响应身份验证时调用 同样在block中需要传入用户身份凭证

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void(^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {

    //用户身份信息    NSLog(@"----需要响应身份验证时调用 同样在block中需要传入用户身份凭证");

    NSURLCredential *newCred = [NSURLCredential credentialWithUser:@""                                                          password:@""                                                      persistence:NSURLCredentialPersistenceNone];

    // 为 challenge 的发送方提供 credential    [[challenge sender] useCredential:newCred forAuthenticationChallenge:challenge];

    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);

}

// 进程被终止时调用

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {

    NSLog(@"----------进程被终止时调用");

}




@end
