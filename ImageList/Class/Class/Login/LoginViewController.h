//
//  LoginViewController.h
//  ImageList
//
//  Created by 纪明 on 2019/12/17.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LoginSuccessBlock)();
@interface LoginViewController : BaseViewController
@property (nonatomic, copy) LoginSuccessBlock         loginSuccessBlock;
@end

NS_ASSUME_NONNULL_END
