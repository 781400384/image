//
//  BaseViewController.m
//  PlayFootBall
//
//  Created by 纪明 on 2019/12/7.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "BaseViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppDelegate.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    if ([SVProgressHUD isVisible]) {
//        [SVProgressHUD dismiss];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

#pragma mark - UI

- (void)initUI{
    
    [self.view addSubview:self.naviView];
    [self.naviView.leftItemButton addTarget:self action:@selector(leftDismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightTitleLabelTap)];
    [self.naviView.rightTitleLabel addGestureRecognizer:tap];
}
#pragma mark - UI event

- (void)rightTitleLabelTap {
    
}

- (void)leftDismiss {
    
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showLeftItemButton:(BOOL)show {
    
    self.naviView.leftItemButton.hidden = !show;
}
- (void)showRightItemButton:(BOOL)show{
    
    self.naviView.rightItemButton.hidden = !show;
}

#pragma mark - lazy

-(NaviView *)naviView {
    
    if (!_naviView) {
        CGFloat height = IS_X ? NAVI_HEIGHT_X : NAVI_HEIGHT;
        _naviView = [[NaviView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
//        _naviView.backgroundColor =APP_NAVI_COLOR ;
    }
    return _naviView;
}


@end
