//
//  ImageDetailViewController.m
//  ImageList
//
//  Created by 纪明 on 2019/12/19.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "MainHandle.h"
#import "LoginViewController.h"
@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView  *  bgImage=[[UIImageView alloc]init];
    [bgImage sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@""]];
    bgImage.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgImage.contentMode=UIViewContentModeScaleAspectFill;
    bgImage.clipsToBounds=YES;
    bgImage.userInteractionEnabled=YES;
    [self.view addSubview:bgImage];
    
    
    UIButton  *  close=[[UIButton alloc]initWithFrame:CGRectMake(22*KScaleW, 33*KScaleH, 33*KScaleW, 33*KScaleW)];
    [close setImage:[UIImage imageNamed:@"image_close"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closebtn) forControlEvents:UIControlEventTouchUpInside];
    [bgImage addSubview:close];
    
    UIButton  *  collect=[[UIButton alloc]initWithFrame:CGRectMake(22*KScaleW, SCREEN_HEIGHT-92.5*KScaleH, 155*KScaleW, 32*KScaleW)];
    if ([self.type isEqualToString:@"1"]) {
        [collect setImage:[UIImage imageNamed:@"image_collect"] forState:UIControlStateNormal];
        [collect setTitle:@"收    藏" forState:UIControlStateNormal];
    }else{
        [collect setImage:[UIImage imageNamed:@"image_remove"] forState:UIControlStateNormal];
               [collect setTitle:@"移除收藏" forState:UIControlStateNormal];
    }
   
    [collect addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    [collect setTitleColor:[UIColor colorWithHexString:@"#B68B61"] forState:UIControlStateNormal];
    [collect setRadius:5.0];
    collect.layer.borderColor=[UIColor colorWithHexString:@"#B68B61"].CGColor;
    collect.layer.borderWidth=0.5*KScaleW;
    collect.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    [collect setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [collect setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [bgImage addSubview:collect];
    
    UIButton  *  setting=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-177*KScaleW, SCREEN_HEIGHT-92.5*KScaleH, 155*KScaleW, 32*KScaleW)];
       [setting setImage:[UIImage imageNamed:@"image_setting"] forState:UIControlStateNormal];
       [setting addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
       [setting setTitle:@"设置壁纸" forState:UIControlStateNormal];
       [setting setTitleColor:[UIColor colorWithHexString:@"#B68B61"] forState:UIControlStateNormal];
       [setting setRadius:5.0];
       setting.layer.borderColor=[UIColor colorWithHexString:@"#B68B61"].CGColor;
    [setting setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
      [setting setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
     setting.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
       setting.layer.borderWidth=0.5*KScaleW;
       [bgImage addSubview:setting];
    
    
    
}
-(void)closebtn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)collect{
    if ([UserInfoDefaults isLogin]) {
    if ([self.type isEqualToString:@"1"]) {
               [self judge];
           } if ([self.type isEqualToString:@"2"]){
               NSLog(@"111");
               [self canel];
           }
    }else{
        [self jumpLogin];
    }
   
    
}
-(void)setting{
//    if ([UserInfoDefaults isLogin]) {
         [self saveImagheWithUrl:self.imgUrl];
//    }else{
//        [self jumpLogin];
//    }
    
}
-(void)saveImagheWithUrl:(NSString *)urlString{
    NSURL  *  url=[NSURL URLWithString:urlString];
    UIImage   *  img;
    NSData  *  data=[NSData dataWithContentsOfURL:url];
    img=[UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
  
}

//保存图片完成之后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message…
        [self.view toast:@"图片保存失败"];
    }
    else  // No errors
    {
        // Show message image successfully saved
         [self.view toast:@"图片保存成功"];

    }
}
-(void)judge{
    [MainHandle judgeWithImageNormal:self.imgUrl imageThem:self.themubUrl success:^(id  _Nonnull obj) {
        NSDictionary * dic=(NSDictionary *)obj;
         NSLog(@"dic==%@",dic);
        if ([dic[@"code"] intValue]==1) {
            [self loadData];
        }else{
            [self.view toast:dic[@"msg"]];
        }
    } failed:^(id  _Nonnull obj) {
        
    }];
}
-(void)loadData{
    [MainHandle addCollectWithImageNormal:self.imgUrl imageThem:self.themubUrl success:^(id  _Nonnull obj) {
        NSDictionary * dic=(NSDictionary *)obj;
        NSLog(@"dic==%@",dic);
               if ([dic[@"code"] intValue]==1) {
                   [self.view toast:@"收藏成功"];
               }else{
                   [self.view toast:dic[@"msg"]];
               }
    } failed:^(id  _Nonnull obj) {
        
    }];
}
-(void)canel{
    [MainHandle canelCollectWithID:[self.imgId intValue] success:^(id  _Nonnull obj) {
        NSDictionary * dic=(NSDictionary *)obj;
        NSLog(@"dic==%@",dic);
               if ([dic[@"code"] intValue]==1) {
                   [self.view toast:@"取消收藏成功"];
               }else{
                   [self.view toast:dic[@"msg"]];
               }
    } failed:^(id  _Nonnull obj) {
         NSLog(@"dic==%@",obj);
    }];
}
-(void)jumpLogin{
    LoginViewController  *  vc=[[LoginViewController alloc]init];
       vc.hidesBottomBarWhenPushed=YES;
    vc.loginSuccessBlock = ^{
        [self dismissViewControllerAnimated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:self userInfo:nil];
                              
                          });
                      }];
      
    };
   [self presentViewController:vc animated:YES completion:nil];
}
@end
