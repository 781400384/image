//
//  MainViewController.m
//  ImageList
//
//  Created by 纪明 on 2019/12/17.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "MainViewController.h"
#import "MainCollectionViewCell.h"
#import "ImageDetailViewController.h"
#import "ImageModel.h"
#import "MainHandle.h"
#import <AFNetworkReachabilityManager.h>
static NSString   *  const cellID=@"cellID";
@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView    *   collectionView;
@property (nonatomic, strong) NSMutableArray      *   dataList;
@property (nonatomic, assign) int                       page;
@property (nonatomic, assign) AFNetworkReachabilityStatus      reachabilityStatus;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self.collectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    self.naviView.hidden=YES;
    [self loadData];
    self.page=1;
self.collectionView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
       self.page = 1;
       [self loadData];
   }];
   self.collectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
       
       self.page++;
       [self loadData];
   }];

}

-(void)loadData{
    [MainHandle getImageListWithTypeId:[self.ID intValue] page:self.page pageNum:30 success:^(id  _Nonnull obj) {
        NSDictionary  *  dic=(NSDictionary *)obj;
        NSLog(@"dic==%@",dic);
        if ([dic[@"code"] intValue]==1) {
            if (self.page==1) {
                 self.dataList=[ImageModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            }else{
                [self.dataList addObjectsFromArray:[ImageModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
               
            }
            if (self.dataList.count==0) {
                
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
    
   
        
        return CGSizeMake((SCREEN_WIDTH - 6*KScaleW)/2, 328.5*KScaleH );
  
    
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
    
    ImageModel  *  mode=self.dataList[indexPath.row];
    ImageDetailViewController  *  vc=[[ImageDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.imgUrl=mode.image;
    vc.imgId=mode.id;
    vc.themubUrl=mode.img_thumb;
    vc.type=@"1";
    [self.navigationController pushViewController:vc animated:NO];
    
   
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    MainCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor=[UIColor grayColor];
    cell.model=self.dataList[indexPath.row];
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
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-tabbar-self.naviView.bottom) collectionViewLayout:stretchyLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

@end
