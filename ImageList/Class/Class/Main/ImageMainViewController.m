//
//  ImageMainViewController.m
//  ImageList
//
//  Created by 纪明 on 2019/12/20.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "ImageMainViewController.h"
#import "HGSegmentedPageViewController.h"
#import "MainViewController.h"
#import "MainHandle.h"
#import "TypeModel.h"
#import "LoginViewController.h"
#import <AFNetworkReachabilityManager.h>
//@property (nonatomic, assign) AFNetworkReachabilityStatus      reachabilityStatus;
@interface ImageMainViewController ()
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic, strong) NSMutableArray    *      titleList;
@property (nonatomic, assign) AFNetworkReachabilityStatus      reachabilityStatus;
@property (nonatomic, strong) UIImageView       *       emptyImage;
@property (nonatomic, strong) UILabel           *       emptyLabel;
@property (nonatomic, strong) UIButton           *       refresh;

@end

@implementation ImageMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.naviView.hidden=YES;
    [self getTitleList];
     [self setUpEmpty];
}
-(void)getTitleList{
    [MainHandle getTypeWithSucces:^(id  _Nonnull obj) {
        NSDictionary * dic=(NSDictionary *)obj;
        NSLog(@"%@",obj);
        if ([dic[@"code"] intValue]==1) {
            self.titleList=[TypeModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            [self addSegmentedPageViewController];
            [self setupPageViewControllers];
        }



    } failed:^(id  _Nonnull obj) {

    }];
        
   
}
#pragma mark - Private Methods
- (void)addSegmentedPageViewController {
    [self addChildViewController:self.segmentedPageViewController];
    [self.view addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController didMoveToParentViewController:self];
    CGFloat tabbar=IS_X?TABBAR_HEIGHT_X:TABBAR_HEIGHT;
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(IS_X?NAVI_SUBVIEW_Y_iphoneX:NAVI_SUBVIEW_Y_Normal);
        make.width.mas_equalTo(SCREEN_WIDTH);

        make.height.mas_equalTo(SCREEN_HEIGHT-tabbar);
    }];
}

- (void)setupPageViewControllers {
    NSMutableArray *controllers = [NSMutableArray array];

    for (int i = 0; i < self.titleList.count; i++) {
      TypeModel   *  model=self.titleList[i];
        MainViewController   *  controller=[MainViewController new];
        controller.ID=model.id;
        [controllers addObject:controller];
    }
    _segmentedPageViewController.pageViewControllers = controllers;
    _segmentedPageViewController.categoryView.titles = [self.titleList valueForKey:@"name"];
    _segmentedPageViewController.categoryView.alignment = HGCategoryViewAlignmentLeft;
    _segmentedPageViewController.categoryView.originalIndex = 0;
    _segmentedPageViewController.categoryView.itemSpacing = 25;
    _segmentedPageViewController.categoryView.topBorder.hidden = YES;
    _segmentedPageViewController.categoryView.titleNomalFont= [UIFont boldSystemFontOfSize:12.0];
    _segmentedPageViewController.categoryView.titleSelectedFont= [UIFont boldSystemFontOfSize:12.0];
    _segmentedPageViewController.categoryView.titleNormalColor= [UIColor colorWithHexString:@"#948F95"];
     _segmentedPageViewController.categoryView.titleSelectedColor= [UIColor colorWithHexString:@"#B68B61"];
     _segmentedPageViewController.categoryView.vernier.backgroundColor= [UIColor colorWithHexString:@"#B68B61"];
     [_segmentedPageViewController.categoryView setVernierHeight:1*KScaleH];
    [_segmentedPageViewController.categoryView setVernierWidth:58*KScaleW];
    [_segmentedPageViewController.categoryView setItemWidth:58*KScaleW];
     [_segmentedPageViewController.categoryView setItemSpacing:0];
    _segmentedPageViewController.categoryView.bottomBorder.hidden=YES;
    
}

#pragma mark Getters
- (HGSegmentedPageViewController *)segmentedPageViewController {
    if (!_segmentedPageViewController) {
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
    }
    return _segmentedPageViewController;
}

-(NSMutableArray *)titleList{
    if (!_titleList) {
        _titleList=[NSMutableArray array];
    }
    return _titleList;
}
-(void)setUpEmpty{
    self.emptyImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_empty"]];
    self.emptyImage.frame=CGRectMake((SCREEN_WIDTH-110.5*KScaleW)/2, 212*KScaleH, 110.5*KScaleW, 110.55*KScaleW);
    self.emptyImage.contentMode=UIViewContentModeScaleAspectFill;
    self.emptyImage.clipsToBounds=YES;
//    self.emptyImage.hidden=YES;
    [self.view addSubview:self.emptyImage];
    
    self.emptyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.emptyImage.bottom+20.5*KScaleH, SCREEN_WIDTH, 13*KScaleH)];
    self.emptyLabel.textAlignment=NSTextAlignmentCenter;
    self.emptyLabel.font=APP_NORMAL_FONT(14.0);
    self.emptyLabel.textColor=[UIColor colorWithHexString:@"#63717E"];
    self.emptyLabel.text=@"网络开小差了~";
//    self.emptyLabel.hidden=YES;
    [self.view addSubview:self.emptyLabel];
    
    self.refresh=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120*KScaleW)/2, self.emptyLabel.bottom+41*KScaleH, 120*KScaleW, 30*KScaleH)];
    [self.refresh setTitle:@"刷新一下试试" forState:UIControlStateNormal];
    self.refresh.layer.borderWidth=0.5*KScaleW;
    self.refresh.layer.borderColor=[UIColor colorWithHexString:@"#B68B61"].CGColor;
    [self.refresh setRadius:5*KScaleW];
    [self.view addSubview:self.refresh];
    self.refresh.titleLabel.font=APP_NORMAL_FONT(11.0);
    [self.refresh setTitleColor:[UIColor colorWithHexString:@"#6A676C"] forState:UIControlStateNormal];
    [self.refresh addTarget:self action:@selector(fresh) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.refresh];
//    self.refresh.hidden=YES;
}
-(void)fresh{
    if (self.reachabilityStatus=AFNetworkReachabilityStatusNotReachable) {
           self.emptyImage.hidden=NO;
           self.emptyLabel.hidden=NO;
           self.refresh.hidden=NO;
       }else{
           [self getTitleList];
           
       }
}
@end
