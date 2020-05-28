//
//  MineCollectViewController.m
//  ImageList
//
//  Created by 纪明 on 2019/12/17.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "MineCollectViewController.h"
#import "MainCollectionViewCell.h"
#import "ImageDetailViewController.h"
#import "CollectModel.h"
#import "MainHandle.h"
static NSString   *  const cellID=@"collectionId";
@interface MineCollectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView    *   collectionView;
@property (nonatomic, strong) NSMutableArray      *   dataList;
@property (nonatomic, assign) int                       page;
@property (nonatomic, strong) UIImageView       *       emptyImage;
@property (nonatomic, strong) UILabel           *       emptyLabel;
@property (nonatomic, strong) UILabel           *       emptyLabel1;

@end

@implementation MineCollectViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: YES];
        [self loadData];
        self.page=1;
    self.collectionView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{

           self.page = 1;
           [self loadData];
       }];
       self.collectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{

           self.page++;
           [self loadData];}];
     [self setUpEmpty];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    self.naviView.naviTitleLabel.text=@"我的收藏";
   
  

}
-(void)loadData{
    [MainHandle getCollcectListWithSuccess:^(id  _Nonnull obj) {
        NSDictionary  *  dic=(NSDictionary *)obj;
              NSLog(@"dic==%@",dic);
              if ([dic[@"code"] intValue]==1) {
                  if (self.page==1) {
                       self.dataList=[CollectModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                  }else{
                      [self.dataList addObjectsFromArray:[CollectModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
                     
                  }
                   if (self.dataList.count==0) {
                                           self.emptyImage.hidden=NO;
                                           self.emptyLabel.hidden=NO;
                                           self.emptyLabel1.hidden=NO;
                                                  }else{
                                           self.emptyImage.hidden=YES;
                                           self.emptyLabel.hidden=YES;
                                                      self.emptyLabel1.hidden=YES;
                                                     
                                                  }
                  [self.collectionView reloadData];
                  [self.collectionView.mj_header endRefreshing];
                  [self.collectionView.mj_footer endRefreshing];
              }
    } failed:^(id  _Nonnull obj) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
   
}
#pragma mark - UICollectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
        
        return CGSizeMake( (SCREEN_WIDTH - 8*KScaleW)/3, 217*KScaleH );
  
    
}

#pragma mark - delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.dataList.count;
   
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    CollectModel  *  mode=self.dataList[indexPath.row];
    ImageDetailViewController  *  vc=[[ImageDetailViewController alloc]init];
    vc.imgUrl=mode.image_normal;
    vc.imgId=mode.id;
    vc.themubUrl=mode.image_thumb;
    vc.type=@"2";
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:NO];
    
   
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    MainCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor=[UIColor grayColor];
    cell.collectModel=self.dataList[indexPath.row];
       return  cell;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(2, 2, 2, 2 );
    
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;

}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *stretchyLayout= [UICollectionViewFlowLayout new];
        CGFloat  tabbar=IS_X?TABBAR_HEIGHT_X:TABBAR_HEIGHT;
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-tabbar-self.naviView.bottom) collectionViewLayout:stretchyLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
-(void)setUpEmpty{
    self.emptyImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_collect"]];
    self.emptyImage.frame=CGRectMake((SCREEN_WIDTH-75*KScaleW)/2, 253*KScaleH, 75*KScaleW, 75*KScaleW);
    self.emptyImage.contentMode=UIViewContentModeScaleAspectFill;
    self.emptyImage.clipsToBounds=YES;
    self.emptyImage.hidden=YES;
    [self.view addSubview:self.emptyImage];
    
    self.emptyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.emptyImage.bottom+20.5*KScaleH, SCREEN_WIDTH, 13*KScaleH)];
    self.emptyLabel.textAlignment=NSTextAlignmentCenter;
    self.emptyLabel.font=APP_NORMAL_FONT(14.0);
    self.emptyLabel.textColor=[UIColor colorWithHexString:@"#B1ABB2"];
    self.emptyLabel.text=@"还没有收藏哦~";
     self.emptyLabel.hidden=YES;
    [self.view addSubview:self.emptyLabel];
    
    self.emptyLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, self.emptyLabel.bottom+10.5*KScaleH, SCREEN_WIDTH, 13*KScaleH)];
    self.emptyLabel1.textAlignment=NSTextAlignmentCenter;
    self.emptyLabel1.font=APP_NORMAL_FONT(14.0);
    self.emptyLabel1.textColor=[UIColor colorWithHexString:@"#63717E"];
     self.emptyLabel1.hidden=YES;
    [self.view addSubview:self.emptyLabel1];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"快去主页看看吧"];
    NSRange range1 = [[str string] rangeOfString:@"快去"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#B1ABB2"] range:range1];
    NSRange range2 = [[str string] rangeOfString:@"主页"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#B68B61"] range:range2];
    NSRange range3 = [[str string] rangeOfString:@"看看吧"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#B1ABB2"] range:range3];
     self.emptyLabel1.attributedText=str;
    self.emptyLabel1.userInteractionEnabled=YES;
     __weak typeof(self) weakSelf = self;
    UITapGestureRecognizer    *  tap=[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
         [weakSelf.tabBarController setSelectedIndex:0];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.emptyLabel1 addGestureRecognizer:tap];
   
    
}

@end
