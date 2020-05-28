//
//  LoginHandle.m
//  PlayFootBall
//
//  Created by 纪明 on 2019/12/13.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "LoginHandle.h"

@implementation LoginHandle
/// 登录
/// @param code <#code description#>
/// @param bundle_name <#bundle_name description#>
/// @param version <#version description#>
/// @param sys <#sys description#>
/// @param channel <#channel description#>
/// @param identification <#identification description#>
/// @param type <#type description#>
/// @param uuid <#uuid description#>
/// @param success <#success description#>
/// @param failed <#failed description#>
+(void)loginWithCode:(NSString *)code bundle_name:(NSString *)bundle_name version:(NSString *)version sys:(NSString *)sys channel:(NSString *)channel identification:(NSString *)identification type:(NSString *)type uuid:(NSString *)uuid success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary * dic=@{@"code":code,
                        @"bundle_name":bundle_name,
                        @"version":version,
                        @"sys":sys,
                        @"channel":channel,
                        @"identification":identification,
                        @"type":type,
                        @"uuid":uuid
                         
                        };
    
    [HttpTools postWithBasePath:@"" Path:LoginBase params:dic loading:NO success:^(id  _Nonnull json) {
          success(json);
    } failure:^(NSError * _Nonnull error) {
        failed(error);
    }];
}
/// 上传头像
/// @param token <#token description#>
/// @param avatarImage <#avatarImage description#>
/// @param success <#success description#>
/// @param failed <#failed description#>
+(void)uploadAvatarWithToken:(NSString *)token image:(UIImage *)avatarImage success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dic=@{
        @"token":token
    };
    [HttpTools uploadImageWithBasePath:@"" Path:API_UPLOAD_AVATAR params:dic thumbName:@"file" images:avatarImage success:^(id  _Nonnull json) {
        success(json);
    } failure:^(NSError * _Nonnull error) {
        failed(error);
    } progress:^(CGFloat progress) {
        
    }];
}
@end
