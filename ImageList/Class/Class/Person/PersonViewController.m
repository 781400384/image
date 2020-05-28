//
//  PersonViewController.m
//  ImageList
//
//  Created by 纪明 on 2019/12/17.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "PersonViewController.h"
#import "MineCollectViewController.h"
#import "LoginViewController.h"
#import "PersonTableViewCell.h"
#import "LCActionAlertView.h"
#import "LoginHandle.h"
@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>{
    UIButton *logoutBtn;
     UIImageView    *   headImage;
}
@property (nonatomic, copy)   NSArray               *            dataList;
@property (nonatomic, copy)   NSArray               *            imageList;
@property (nonatomic, strong) UITableView           *            tableView;
@property (nonatomic,strong)  UILabel               *            detailLab ;
@property (nonatomic, strong) UILabel               *            version;

@end

@implementation PersonViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXLoginNoti:) name:LoginSuccessNotification object:nil];
    [super viewWillAppear:animated];
    self.dataList=@[@[@""],@[@"我的收藏"],@[@"给我们评分",@"清理缓存",@"版本号"]];
    self.imageList=@[@[@""],@[@"p_collect"],@[@"p_judge",@"p_cache",@"p_verson"]];
}
-(void)WXLoginNoti:(NSNotification *)noti{
    logoutBtn.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.hidden=YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else
        if (section==1) {
            return 1;
        }else{
            return 3;
        }
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"userCenterCell";
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[PersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11"];
    }
    cell.label.text = self.dataList[indexPath.section][indexPath.row];
    cell.image.image=[UIImage imageNamed:self.imageList[indexPath.section][indexPath.row]];
    
    if (indexPath.section==0) {
        cell.lineView.hidden=YES;
        UIView  *   lineView=[[UIView alloc]init];
        lineView.frame=CGRectMake(13*KScaleW, 0, SCREEN_WIDTH-26*KScaleW, 96*KScaleH);
        lineView.backgroundColor=[UIColor clearColor];
        lineView.layer.borderWidth=0.5*KScaleW;
        [lineView setRadius:5*KScaleW];
        lineView.layer.borderColor=[UIColor colorWithHexString:@"#EFEFF0"].CGColor;
        [cell addSubview:lineView];
        UIImageView    *   headImage=[[UIImageView alloc]initWithFrame:CGRectMake(35.5*KScaleW, 26*KScaleH, 44*KScaleH, 44*KScaleH)];
        [headImage setRadius:22*KScaleH];
        headImage.clipsToBounds=YES;
        headImage.contentMode=UIViewContentModeScaleAspectFill;
        [cell addSubview:headImage];
        
        UILabel  *  nickName=[[UILabel alloc]initWithFrame:CGRectMake(headImage.right+37.5*KScaleW, 41.5*KScaleH, 180*KScaleW, 13*KScaleH)];
        nickName.textAlignment=NSTextAlignmentLeft;
        nickName.font=APP_NORMAL_FONT(16.0);
        nickName.textColor=[UIColor colorWithHexString:@"#1F1812"];
        [cell addSubview:nickName];
        
        if ([UserInfoDefaults isLogin] ) {
            [headImage sd_setImageWithURL:[NSURL URLWithString:[UserInfoDefaults userInfo].avatar] placeholderImage:[UIImage imageNamed:@"p_normal_avatar"]];
            nickName.text=[UserInfoDefaults userInfo].nickname;
        }else{
            headImage.image=[UIImage imageNamed:@"p_normal_avatar"];
            nickName.text=@"未登录";
        }
    }
    if (indexPath.section==1) {
           cell.next.image = [UIImage imageNamed:@"p_next"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section==2) {
        if (indexPath.row==0) {

            
        }
        if (indexPath.row==2) {
            cell.detailLabel.text=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        }
        if (indexPath.row==1) {
            
            self.detailLab=cell.detailLabel;
        if ([UserInfoDefaults isLogin]) {
            
        
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSUInteger size = [[SDImageCache sharedImageCache]getSize];
                    YYCache *cache = [[YYCache alloc]initWithName:NET_CACHE];
                    NSUInteger yy_size = cache.memoryCache.totalCost;
                    
                    NSString *cacheSize = [self fileSizeWithInterge:(size+yy_size)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                          cell.detailLabel.text = cacheSize;
                          
                    });
         });
            
        }else{
            cell.detailLabel.hidden=YES;
        }
            
        }
    }
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
      return   96*KScaleH;
    }else  if (indexPath.section==1){
        return 54*KScaleH;
    } else{
        return 65*KScaleH;
        }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
   
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
         
    if ([UserInfoDefaults isLogin]) {
        if (indexPath.section==0) {            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                          imagePickerController.delegate = self;
                          imagePickerController.allowsEditing = YES;
                          [LCActionAlertView showActionViewNames:@[@"照相机",@"本地相册"] completed:^(NSInteger index,NSString * name) {
                              if (index==0) {
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                  [self presentViewController:imagePickerController animated:YES completion:nil];
                              }else{
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  [self presentViewController:imagePickerController animated:YES completion:nil];
                              }
                          } canceled:^{

                          }];
        }
        if (indexPath.section==1) {
            MineCollectViewController   *  vc=[[MineCollectViewController alloc]init];
            
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
        if (indexPath.section==2) {
            if (indexPath.row==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id1491589742"]];
            }else{
            if (indexPath.row==1) {
           
            YYCache *cache = [[YYCache alloc]initWithName:NET_CACHE];
            [cache removeAllObjects];

            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                self.detailLab.text = @"0M";
               
                
            }];
            }
                
            }
        }
        
           
        }else{
            [self jumpLogin];
        }
    
}


#pragma mark - lazy

- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat tabbar_height = IS_X ? TABBAR_HEIGHT_X : TABBAR_HEIGHT;
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-tabbar_height) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor=[UIColor whiteColor];
        tableView.separatorColor = [UIColor clearColor];
        tableView.tableFooterView = [self addFooterButton];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}
- (UIView *)addFooterButton {
    
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54*KScaleH)];
    logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(13*KScaleW, 0, SCREEN_WIDTH-26*KScaleW, 54*KScaleH);
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    if ([UserInfoDefaults isLogin]) {
         logoutBtn.hidden=NO;
    }else{
         logoutBtn.hidden=YES;
    }
    
    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"#6A676C"] forState:UIControlStateNormal];
    [logoutBtn setBackgroundColor:[UIColor whiteColor]];
    [logoutBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.layer.borderWidth=0.5*KScaleW;
    [logoutBtn setRadius:5*KScaleW];
    logoutBtn.layer.borderColor=[UIColor colorWithHexString:@"#EFEFF0"].CGColor;
    logoutBtn.titleLabel.font=APP_NORMAL_FONT(14.0);
    [footer addSubview:logoutBtn];
    
    return footer;
}
-(void)logoutAction:(UIButton *)sender{
    [UserInfoDefaults logoutUserInfo];
    [self.tableView reloadData];
     logoutBtn.hidden=YES;
    NSUserDefaults  *  defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"cityId"];
    [self jumpLogin];
}
-(void)jumpLogin{
    LoginViewController  *  vc=[[LoginViewController alloc]init];
       vc.hidesBottomBarWhenPushed=YES;
    vc.loginSuccessBlock = ^{
        [self dismissViewControllerAnimated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    logoutBtn.hidden=NO;
                              
                          });
                      }];
      
    };
   [self presentViewController:vc animated:YES completion:nil];
}

- (NSString *)fileSizeWithInterge:(NSInteger)size{
    if (size < 1024) {
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}
#pragma mark - 上传头像
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imgData = UIImageJPEGRepresentation([self fixOrientation:image], 0.5);
    UIImage *rightImage = [UIImage imageWithData:imgData];
    [headImage setImage:rightImage];
    [LoginHandle uploadAvatarWithToken:[UserInfoDefaults userInfo].token image:rightImage success:^(id  _Nonnull obj) {
        NSDictionary * dic=(NSDictionary *)obj;
        if ([dic[@"code"] intValue]==1) {
            UserInfoModel   *  model=[UserInfoDefaults userInfo];
            model.avatar=dic[@"data"][@"avatar"];
            [UserInfoDefaults saveUserInfo:model];
            [self.tableView reloadData];
        }
    } failed:^(id  _Nonnull obj) {
        
    }];
    
}
-(UIImage *)fixOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end
