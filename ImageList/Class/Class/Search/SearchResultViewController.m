//
//  SearchResultViewController.m
//  ImageList
//
//  Created by 纪明 on 2019/12/23.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MainCollectionViewCell.h"
#import "SearchModel.h"
#import "ImageDetailViewController.h"
#define RecordCount 5
#define SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"SearchHistory"]
static NSString   *  const collectionID=@"cellID";
static NSString   *  const headerID=@"headerID";
@interface SearchResultViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic, assign) int                       page;
@property (nonatomic, assign) int                       num;
@property (nonatomic, strong) NSMutableArray    *    dataList;
@property (nonatomic, strong) UITextField   *  tf3;
@property (nonatomic, strong) UICollectionView    *   collectionView;
@property (nonatomic, strong) UIImageView       *       emptyImage;
@property (nonatomic, strong) UILabel           *       emptyLabel;
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.hidden=YES;
    [self loadDatawithPage:self.page word:self.str ];
    self.page=0;
    [self.collectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:collectionID];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
       self.collectionView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
           
           self.page =0;
           self.num=0;
           [self loadDatawithPage:self.num word:self.str];
       }];
       self.collectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
         
           self.page++;
           self.num=self.page*20;
    [self loadDatawithPage:self.num word:self.str ];
       }];
    [self setUpEmpty];
}

#pragma mark - collectionview

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
    
            UICollectionReusableView * headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
          UIView   *   bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 59.5*KScaleH)];
                 bgView.backgroundColor=[UIColor colorWithHexString:@"#B68B61"];
                 [headerView addSubview:bgView];
                 UIView   *   tfBgview=[[UIView alloc]initWithFrame:CGRectMake(18*KScaleW, bgView.bottom-22.5*KScaleH, SCREEN_WIDTH-36*KScaleW, 45*KScaleH)];
                 tfBgview.userInteractionEnabled=YES;
                 tfBgview.layer.borderColor=[UIColor colorWithHexString:@"#B68B61"].CGColor;
                 tfBgview.layer.borderWidth=0.5;
                 [tfBgview setRadius:5.0*KScaleW];
                 [headerView addSubview:tfBgview];
                 self.tf3=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-93*KScaleW, 45*KScaleH)];
                 self.tf3.backgroundColor=[UIColor whiteColor];
                 self.tf3.delegate=self;;
                self.tf3.textColor=[UIColor colorWithHexString:@"#1F1812"];
                 [tfBgview addSubview:self.tf3];
         self.tf3.tintColor=[UIColor colorWithHexString:@"#B68B61"];
//                 UIButton *button = [self.tf3 valueForKey:@"_clearButton"];
//                 [button setImage:[UIImage imageNamed:@"text_close"] forState:UIControlStateNormal];
                 self.tf3.clearButtonMode = UITextFieldViewModeWhileEditing;
                 self.tf3.returnKeyType=UIReturnKeySearch;
                 self.tf3.text=self.str;
                 UIButton  *  canel=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-93*KScaleW, 0, 57*KScaleW, 45*KScaleH)];
                 [canel setTitle:@"取消" forState:UIControlStateNormal];
                 canel.titleLabel.font=[UIFont systemFontOfSize:12.0];
                 [canel setTitleColor:[UIColor colorWithHexString:@"#1F1812"] forState:UIControlStateNormal];
                 canel.backgroundColor=[UIColor whiteColor];
                 [canel addTarget:self action:@selector(collectionCanel) forControlEvents:UIControlEventTouchUpInside];
                 [tfBgview addSubview:canel];
                 UIImageView  *  leftImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_search"]];
                 leftImage.frame=CGRectMake(0, 0, 43.9*KScaleW, 44.5*KScaleH);
                 leftImage.contentMode=UIViewContentModeScaleAspectFill;
                  NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"请输入搜索内容"];
                        [placeholder addAttribute:NSFontAttributeName
                                         value:[UIFont boldSystemFontOfSize:12.0]
                                         range:NSMakeRange(0, 7)];
                 self.tf3.attributedPlaceholder = placeholder;
                 self.tf3.leftView=leftImage;
                 self.tf3.leftViewMode=UITextFieldViewModeAlways;
               
               reusableview=headerView;
        }
        
    
    
    
    
    return reusableview;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
   
        return CGSizeMake(SCREEN_WIDTH, 83*KScaleH );
  
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
        
        return CGSizeMake( (SCREEN_WIDTH - 6*KScaleW)/2, 328.5*KScaleH );
  
    
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
    
    SearchModel  *  mode=self.dataList[indexPath.row];
    ImageDetailViewController  *  vc=[[ImageDetailViewController alloc]init];
    vc.imgUrl=mode.middleURL;
    vc.themubUrl=mode.thumbURL;
    vc.hidesBottomBarWhenPushed=YES;
    vc.type=@"1";
    [self.navigationController pushViewController:vc animated:NO];
    
   
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    MainCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    cell.backgroundColor=[UIColor grayColor];
    cell.searchModel=self.dataList[indexPath.row];

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
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, IS_X?NAVI_SUBVIEW_Y_iphoneX:NAVI_SUBVIEW_Y_Normal, SCREEN_WIDTH, SCREEN_HEIGHT-tabbar) collectionViewLayout:stretchyLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(void)collectionCanel{
    
     [[NSNotificationCenter defaultCenter] postNotificationName:POPBackNotification object:self userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loadDatawithPage:(int)page word:(NSString *)word {
    int num = (arc4random() % 1000);
  NSString *  three = [NSString stringWithFormat:@"%.3d", num];
    int numNine = (arc4random() % 1000000000);
    NSString *  nine = [NSString stringWithFormat:@"%.9d", numNine];
     NSString *str1 = [word stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString  *  url=[NSString stringWithFormat:@"https://image.baidu.com/search/acjson?tn=resultjson_com&ipn=rj&ct=%@&is=&fp=result&queryWord=&lm=-1&ie=utf-8&oe=utf-8&st=-1&ic=0&word=%@&width=750&height=1334&face=0&istype=2&cg=wallpaper&pn=%d&rn=20&gsm=&%@%@=",nine,str1,page,[self getNowTimeTimestamp],three];
    [HttpTools postWithBasePath:url Path:nil params:nil loading:NO success:^(id  _Nonnull json) {
        NSDictionary * dic=(NSDictionary *)json;
        NSLog(@"dic====%@",dic);
        if (self.page==0) {
           self.dataList =[SearchModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
           [self.dataList removeLastObject];
                   }else{
                [self.dataList addObjectsFromArray:[SearchModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
                    [self.dataList removeLastObject];
                   }
                    if (self.dataList.count==0) {
                    self.emptyImage.hidden=NO;
                    self.emptyLabel.hidden=NO;
                                                           
                                                                   }else{
                                                            self.emptyImage.hidden=YES;
                                                            self.emptyLabel.hidden=YES;
                                                                     
                                                                      
                                                                   }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error===%@",error);
    }];
    
   
}



-(NSString *)getNowTimeTimestamp{

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{   if(self.tf3==textField){
    [self addSearchRecord:self.tf3.text];
    [self.tf3 resignFirstResponder];
    
    self.str=textField.text;
    [self loadDatawithPage:self.page  word:self.tf3.text ];
}
    return YES;
}
#pragma mark - history
-(void)addSearchRecord:(NSString *)searchStr
{
    NSMutableArray *searchArray = [[NSMutableArray alloc]initWithArray:SEARCH_HISTORY];
    if (searchArray == nil) {
        searchArray = [[NSMutableArray alloc]init];
    } else if ([searchArray containsObject:searchStr]) {
        [searchArray removeObject:searchStr];
    } else if ([searchArray count] >= RecordCount) {
        [searchArray removeObjectsInRange:NSMakeRange(RecordCount - 1, [searchArray count] - RecordCount + 1)];
    }
    [searchArray insertObject:searchStr atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:searchArray forKey:@"SearchHistory"];
    NSLog(@"history=%@",searchArray);
}
-(void)setUpEmpty{
    self.emptyImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_search"]];
    self.emptyImage.frame=CGRectMake((SCREEN_WIDTH-75*KScaleW)/2, 253*KScaleH, 75*KScaleW, 75*KScaleW);
    self.emptyImage.contentMode=UIViewContentModeScaleAspectFill;
    self.emptyImage.clipsToBounds=YES;
    self.emptyImage.hidden=YES;
    [self.view addSubview:self.emptyImage];
    
    self.emptyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.emptyImage.bottom+20.5*KScaleH, SCREEN_WIDTH, 13*KScaleH)];
    self.emptyLabel.textAlignment=NSTextAlignmentCenter;
    self.emptyLabel.font=APP_NORMAL_FONT(14.0);
    self.emptyLabel.textColor=[UIColor colorWithHexString:@"#B1ABB2"];
    self.emptyLabel.text=@"暂无结果";
     self.emptyLabel.hidden=YES;
    [self.view addSubview:self.emptyLabel];
    
    
   
    
}

@end
