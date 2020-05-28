//
//  SearchViewController.m
//  ImageList
//
//  Created by 纪明 on 2019/12/17.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "MainHandle.h"
#import "KeyWordsModel.h"
#import "SearchResultViewController.h"
#import "WebDetailViewController.h"

#define NeedStartMargin 18   // 首列起始间距
#define NeedFont 12   // 需求文字大小
#define NeedBtnHeight 26   // 按钮高度
#define RecordCount 5
#define SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"SearchHistory"]

static   NSString   *   const   cellID  = @"searchCell";
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UIButton  *  button;
    UIButton  *  Clear;
    UILabel   *  label;
   
}

@property (nonatomic, strong) UITableView     *      tableView;
@property (nonatomic, strong) UITextField   *  tf1;
@property (nonatomic, strong) UITextField   *  tf2;

@property (nonatomic, strong) NSMutableArray    *    dataList;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
     [self getAllSearchHistory];
  self.tabBarController.tabBar.hidden=NO;
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popNoti:) name:POPBackNotification object:nil];

}
-(void)popNoti:(NSNotification *)wxLogin{
    self.tableView.tableHeaderView=[self setHeaderView];
}
#pragma mark - tabbleView
-(UITableView *)tableView{
    if (!_tableView) {
        CGFloat tabbar=IS_X?TABBAR_HEIGHT_X:TABBAR_HEIGHT;
           _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-tabbar) style:UITableViewStylePlain];
           _tableView.delegate = self;
           _tableView.showsVerticalScrollIndicator = NO;
           _tableView.backgroundColor = [UIColor whiteColor];
           _tableView.dataSource = self;
           _tableView.separatorColor=[UIColor clearColor];
           _tableView.tableHeaderView=[self setHeaderView];
           [self.view addSubview:_tableView];
    }
   
    return _tableView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray * array=SEARCH_HISTORY;
    NSString * str=array[indexPath.row];
    [self addSearchRecord:str];
   SearchResultViewController   *  vc=[[SearchResultViewController alloc]init];
    vc.str=str;
     vc.hidesBottomBarWhenPushed=NO;
    [self.navigationController pushViewController:vc animated:NO];
   Clear.hidden=NO;;
    label.hidden=NO;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
              cell= [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
           }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
     NSArray * array=SEARCH_HISTORY;
    cell.label.text=array[indexPath.row];
    UIView   *   lineView=[[UIView alloc]initWithFrame:CGRectMake(18*KScaleW,49.5*KScaleH, SCREEN_WIDTH-62*KScaleW, 0.5*KScaleH)];
    lineView.backgroundColor=[UIColor colorWithHexString:@"#EFEFF0"];
    [cell addSubview:lineView];
    
    return cell;
    
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array=SEARCH_HISTORY;
    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*KScaleH;
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



-(NSArray *)getAllSearchHistory
{
    NSLog(@"%@",SEARCH_HISTORY);
    return SEARCH_HISTORY;
}

- (void)clearAllSearchHistory
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc]init] forKey:@"SearchHistory"];
}
#pragma mark- normalhEADER
-(UIView *)setHeaderView{
    UIView  *  bg=[[UIView alloc]init];
    UIView   *   bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 266.5*KScaleH)];
       bgView.backgroundColor=[UIColor colorWithHexString:@"#B68B61"];
       [bg addSubview:bgView];
   
       UIImageView   *   image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_bg"]];
       image.contentMode=UIViewContentModeScaleAspectFit;
       image.clipsToBounds=YES;
   
       [bgView addSubview:image];
       image.frame=CGRectMake(0, 97*KScaleH, SCREEN_WIDTH, 114*KScaleH);
    self.tf1=[[UITextField alloc]initWithFrame:CGRectMake(18*KScaleW, bgView.bottom-22.5*KScaleH, SCREEN_WIDTH-36*KScaleW, 45*KScaleH)];
      self.tf1.backgroundColor=[UIColor whiteColor];
      [self.tf1 setRadius:5.0];
      self.tf1.delegate=self;
      self.tf1.layer.borderColor=[UIColor colorWithHexString:@"#B68B61"].CGColor;
      self.tf1.layer.borderWidth=0.5;
    self.tf1.tintColor=[UIColor colorWithHexString:@"#B68B61"];
      [bg addSubview:self.tf1];
      UIImageView  *  leftImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_search"]];
      leftImage.frame=CGRectMake(0, 0, 43.9*KScaleW, 44.5*KScaleH);
      leftImage.contentMode=UIViewContentModeScaleAspectFill;
       NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"请输入搜索内容"];
             [placeholder addAttribute:NSFontAttributeName
                              value:[UIFont boldSystemFontOfSize:12.0]
                              range:NSMakeRange(0, 7)];
      self.tf1.attributedPlaceholder = placeholder;
      self.tf1.leftView=leftImage;
      self.tf1.leftViewMode=UITextFieldViewModeAlways;
   
      
      UILabel  *  noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(18*KScaleW, self.tf1.bottom+38.5*KScaleH, SCREEN_WIDTH-18*KScaleW, 13.5*KScaleH)];
    
      noticeLabel.textColor=[UIColor colorWithHexString:@"#B78C62"];
      noticeLabel.font=[UIFont boldSystemFontOfSize:14.0];
      noticeLabel.textAlignment=NSTextAlignmentLeft;
      noticeLabel.text=@"大家都在搜";
      [bg addSubview:noticeLabel];
  
    
    
    float butX = NeedStartMargin;
    float butY = noticeLabel.bottom+26*KScaleH;
    CGFloat height=26*KScaleH;
       for(int i = 0; i < self.dataList.count; i++){
           KeyWordsModel  *  model=self.dataList[i];
           //宽度自适应计算宽度
           NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:NeedFont]};
           CGRect frame_W = [model.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
           
           //宽度计算得知当前行不够放置时换行计算累加Y值
           if (butX+frame_W.size.width+NeedStartMargin*2>SCREEN_WIDTH-NeedStartMargin) {
               butX = NeedStartMargin;
               butY += (NeedBtnHeight+12);//Y值累加，具体值请结合项目自身需求设置 （值 = 按钮高度+按钮间隙）
               height+=NeedBtnHeight+12;
           }
           
           //设置计算好的位置数值
           UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(butX,butY, frame_W.size.width+NeedStartMargin*2, NeedBtnHeight)];
           //设置内容
           [btn setTitle:model.name forState:UIControlStateNormal];
           btn.tag = i;
           //添加事件
           //设置圆角
           btn.layer.cornerRadius = 5;//2.0是圆角的弧度，根据需求自己更改
           btn.layer.borderColor =[UIColor colorWithHexString:@"#E6E6E8"].CGColor;//设置边框颜色
           btn.layer.borderWidth = 0.5f;//设置边框颜色
           [btn setTitleColor:[UIColor colorWithHexString:@"#B1ABB2"] forState:UIControlStateNormal];
           
           btn.titleLabel.font = [UIFont systemFontOfSize:12];
           [btn addTarget:self action:@selector(SelBtn:) forControlEvents:UIControlEventTouchUpInside];
           //添加按钮
           [self.view addSubview:btn];
           //一个按钮添加之后累加X值后续计算使用
           butX = CGRectGetMaxX(btn.frame)+15;
           [bg addSubview:btn];
           button=btn;
           
       }
    
    
      UILabel  *  noticeLabel1=[[UILabel alloc]initWithFrame:CGRectMake(18*KScaleW, button.bottom+31*KScaleH, SCREEN_WIDTH-56*KScaleW, 13*KScaleH)];
          noticeLabel1.textColor=[UIColor colorWithHexString:@"#B78C62"];
          noticeLabel1.font=[UIFont boldSystemFontOfSize:14.0];
          noticeLabel1.textAlignment=NSTextAlignmentLeft;
          noticeLabel1.text=@"搜索历史";
          [bg addSubview:noticeLabel1];
        
       UIButton  *  clear=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-38*KScaleW, button.bottom+34.5*KScaleH, 25.5*KScaleW, 9.5*KScaleH)];
       clear.backgroundColor=[UIColor whiteColor];
       [clear setTitle:@"清空" forState:UIControlStateNormal];
       clear.titleLabel.font=[UIFont systemFontOfSize:10.0];
    [clear addTarget:self action:@selector(deleALL) forControlEvents:UIControlEventTouchUpInside];
       [clear setTitleColor:[UIColor colorWithHexString:@"#D0CCD1"] forState:UIControlStateNormal];
       [bg addSubview:clear];
    Clear=clear;
   label=noticeLabel1;
       if (SEARCH_HISTORY != nil && ![SEARCH_HISTORY isKindOfClass:[NSNull class]] && SEARCH_HISTORY.count != 0) {
           clear.hidden=NO;
           noticeLabel1.hidden=NO;
                    }else{
          clear.hidden=YES;
          noticeLabel1.hidden=YES;
            }
   
      bg.frame=CGRectMake(0, 0, SCREEN_WIDTH, bgView.height+self.tf1.height/2+38.5*KScaleH+noticeLabel.height+26*KScaleH+height+31*KScaleH+noticeLabel.height);
    return bg;
}
-(void)SelBtn:(UIButton *)sender{

    KeyWordsModel  *  model=self.dataList[sender.tag];
    if ([model.type isEqualToString:@"0"]) {
        [self addSearchRecord:model.name];
           SearchResultViewController   *  vc=[[SearchResultViewController alloc]init];
           vc.str=model.name;
           Clear.hidden=NO;;
               label.hidden=NO;
            vc.hidesBottomBarWhenPushed=NO;
           [self.navigationController pushViewController:vc animated:NO];
           [self.tableView reloadData];
    }if ([model.type isEqualToString:@"1"]){
        WebDetailViewController  *  vc=[[WebDetailViewController alloc]init];
        vc.linkUrl=model.link_url;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
   
}
-(void)loadData{
  
    [MainHandle getKeyWordsListWithSuccess:^(id  _Nonnull obj) {
        NSDictionary   *  dic=(NSDictionary *)obj;
        if ([dic[@"code"] intValue]==1) {
        self.dataList=[KeyWordsModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            [self.tableView reloadData];
            [self.tf2 becomeFirstResponder];
        }
    } failed:^(id  _Nonnull obj) {
        
    }];
}
-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList=[NSMutableArray array];
    }
    return _dataList;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//返回一个BOOL值，指定是否循序文本字段开始编辑
    if (self.tf1==textField) {
         [self.tf2 isFirstResponder];
        return YES;
    }
return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {

//开始编辑,文本字段将成为 first responder
    
    if (self.tf1==textField) {
//        self.tf2=textField;
        self.tableView.tableHeaderView=[self setNewHeaderView];
        [self loadData];
        
    }

}

#pragma mark - newHeaderView
-(UIView *)setNewHeaderView{
    UIView  *  bg=[[UIView alloc]init];
    UIView   *   bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 59.5*KScaleH)];
        bgView.backgroundColor=[UIColor colorWithHexString:@"#B68B61"];
        [bg addSubview:bgView];
        UIView   *   tfBgview=[[UIView alloc]initWithFrame:CGRectMake(18*KScaleW, bgView.bottom-22.5*KScaleH, SCREEN_WIDTH-36*KScaleW, 45*KScaleH)];
        tfBgview.userInteractionEnabled=YES;
        tfBgview.layer.borderColor=[UIColor colorWithHexString:@"#B68B61"].CGColor;
        tfBgview.layer.borderWidth=0.5;
        [tfBgview setRadius:5.0*KScaleW];
        [bg addSubview:tfBgview];
        self.tf2=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-93*KScaleW, 45*KScaleH)];
        self.tf2.backgroundColor=[UIColor whiteColor];
        self.tf2.delegate=self;;
        [tfBgview addSubview:self.tf2];
    self.tf2.tintColor=[UIColor colorWithHexString:@"#B68B61"];
//        UIButton *button = [self.tf2 valueForKey:@"_clearButton"];
//        [button setImage:[UIImage imageNamed:@"text_close"] forState:UIControlStateNormal];
        self.tf2.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.tf2.returnKeyType=UIReturnKeySearch;
        
        UIButton  *  canel=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-93*KScaleW, 0, 57*KScaleW, 45*KScaleH)];
        [canel setTitle:@"取消" forState:UIControlStateNormal];
        canel.titleLabel.font=[UIFont systemFontOfSize:12.0];
        [canel setTitleColor:[UIColor colorWithHexString:@"#1F1812"] forState:UIControlStateNormal];
        canel.backgroundColor=[UIColor whiteColor];
    [canel addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [tfBgview addSubview:canel];
        UIImageView  *  leftImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_search"]];
        leftImage.frame=CGRectMake(0, 0, 43.9*KScaleW, 44.5*KScaleH);
        leftImage.contentMode=UIViewContentModeScaleAspectFill;
         NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"请输入搜索内容"];
               [placeholder addAttribute:NSFontAttributeName
                                value:[UIFont boldSystemFontOfSize:12.0]
                                range:NSMakeRange(0, 7)];
    
        self.tf2.attributedPlaceholder = placeholder;
        self.tf2.leftView=leftImage;
        self.tf2.leftViewMode=UITextFieldViewModeAlways;
      
      
     UILabel  *  noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(18*KScaleW, tfBgview.bottom+38.5*KScaleH, SCREEN_WIDTH-18*KScaleW, 13.5*KScaleH)];
        
          noticeLabel.textColor=[UIColor colorWithHexString:@"#B78C62"];
          noticeLabel.font=[UIFont boldSystemFontOfSize:14.0];
          noticeLabel.textAlignment=NSTextAlignmentLeft;
          noticeLabel.text=@"大家都在搜";
          [bg addSubview:noticeLabel];
      
        
        
        float butX = NeedStartMargin;
        float butY = noticeLabel.bottom+26*KScaleH;
        CGFloat height=26*KScaleH;
           for(int i = 0; i < self.dataList.count; i++){
               KeyWordsModel  *  model=self.dataList[i];
               //宽度自适应计算宽度
               NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:NeedFont]};
               CGRect frame_W = [model.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
               
               //宽度计算得知当前行不够放置时换行计算累加Y值
               if (butX+frame_W.size.width+NeedStartMargin*2>SCREEN_WIDTH-NeedStartMargin) {
                   butX = NeedStartMargin;
                   butY += (NeedBtnHeight+12);//Y值累加，具体值请结合项目自身需求设置 （值 = 按钮高度+按钮间隙）
                   height+=NeedBtnHeight+12;
                   NSLog(@"高度==%f",height);
               }
               
               //设置计算好的位置数值
               UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(butX,butY, frame_W.size.width+NeedStartMargin*2, NeedBtnHeight)];
               //设置内容
               [btn setTitle:model.name forState:UIControlStateNormal];
               btn.tag = i;
               //添加事件
               //设置圆角
               btn.layer.cornerRadius = 5;//2.0是圆角的弧度，根据需求自己更改
               btn.layer.borderColor =[UIColor colorWithHexString:@"#E6E6E8"].CGColor;//设置边框颜色
               btn.layer.borderWidth = 0.5f;//设置边框颜色
               [btn setTitleColor:[UIColor colorWithHexString:@"#B1ABB2"] forState:UIControlStateNormal];
               
               btn.titleLabel.font = [UIFont systemFontOfSize:12];
               [btn addTarget:self action:@selector(SelBtn:) forControlEvents:UIControlEventTouchUpInside];
               //添加按钮
               [self.view addSubview:btn];
               //一个按钮添加之后累加X值后续计算使用
               butX = CGRectGetMaxX(btn.frame)+15;
               [bg addSubview:btn];
               button=btn;
               
           }
        
        
          UILabel  *  noticeLabel1=[[UILabel alloc]initWithFrame:CGRectMake(18*KScaleW, button.bottom+31*KScaleH, SCREEN_WIDTH-56*KScaleW, 13*KScaleH)];
              noticeLabel1.textColor=[UIColor colorWithHexString:@"#B78C62"];
              noticeLabel1.font=[UIFont boldSystemFontOfSize:14.0];
              noticeLabel1.textAlignment=NSTextAlignmentLeft;
              noticeLabel1.text=@"搜索历史";
              [bg addSubview:noticeLabel1];
            
           UIButton  *  clear=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-38*KScaleW, button.bottom+34.5*KScaleH,25.5*KScaleW, 9.5*KScaleH)];
           clear.backgroundColor=[UIColor whiteColor];
           [clear setTitle:@"清空" forState:UIControlStateNormal];
           clear.titleLabel.font=[UIFont systemFontOfSize:10.0];
           [clear setTitleColor:[UIColor colorWithHexString:@"#D0CCD1"] forState:UIControlStateNormal];
           [bg addSubview:clear];
    Clear=clear;
     label=noticeLabel1;
          if (SEARCH_HISTORY != nil && ![SEARCH_HISTORY isKindOfClass:[NSNull class]] && SEARCH_HISTORY.count != 0) {
                    clear.hidden=NO;
              noticeLabel1.hidden=NO;
                             }else{
                                 clear.hidden=YES;
                                 noticeLabel1.hidden=YES;
                                

                             }
        [clear addTarget:self action:@selector(deleALL) forControlEvents:UIControlEventTouchUpInside];
          bg.frame=CGRectMake(0, 0, SCREEN_WIDTH, bgView.height+self.tf2.height/2+38.5*KScaleH+noticeLabel.height+26*KScaleH+height+31*KScaleH+noticeLabel.height);
    return bg;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{   if(self.tf2==textField){
    [self addSearchRecord:self.tf2.text];
    [self.tf2 resignFirstResponder];
    [self.tableView reloadData];
    SearchResultViewController   *  vc=[[SearchResultViewController alloc]init];
    vc.str=self.tf2.text;
    Clear.hidden=NO;;
     label.hidden=NO;
    vc.hidesBottomBarWhenPushed=NO;
    [self.navigationController pushViewController:vc animated:NO];
    
}
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收

return YES;

}

-(void)pop{
    self.tableView.tableHeaderView=[self setHeaderView];
    [self loadData];
}
-(void)deleALL{
    Clear.hidden=YES;;
    label.hidden=YES;
    [self clearAllSearchHistory];
    [self loadData];
}
@end
