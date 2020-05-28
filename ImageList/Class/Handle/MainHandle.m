//
//  MainHandle.m
//  ImageList
//
//  Created by 纪明 on 2019/12/20.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "MainHandle.h"

@implementation MainHandle
/// 获取分类
/// @param success <#success description#>
/// @param failed <#failed description#>
+(void)getTypeWithSucces:(SuccessBlock)success failed:(FailedBlock)failed{
    [HttpTools getWithBasePath:BaseURL Path:API_GET_TYPE params:nil success:^(id  _Nonnull json) {
        success(json);
    } failure:^(NSError * _Nonnull error) {
        failed(error);
    }];
}
/// 获取图片
/// @param typeId <#typeId description#>
/// @param page <#page description#>
/// @param pageNum <#pageNum description#>
/// @param success <#success description#>
/// @param failed <#failed description#>
+(void)getImageListWithTypeId:(int)typeId page:(int)page pageNum:(int)pageNum success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary   *  dic=@{@"type_id":[NSNumber numberWithInt:typeId],
                            @"page":[NSNumber  numberWithInt:page],
                            @"limit":[NSNumber numberWithInt:pageNum]
    };
    [HttpTools getWithBasePath:BaseURL Path:API_GET_IMAGE params:dic success:^(id  _Nonnull json) {
         success(json);
    } failure:^(NSError * _Nonnull error) {
        failed(error);
    }];
}
+(void)addCollectWithImageNormal:(NSString *)imageNormal imageThem:(NSString *)imageThem success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary  *  dic=@{@"token":[UserInfoDefaults userInfo].token,
                            @"image_normal":imageNormal,
                            @"image_thumb":imageThem
    };
    NSLog(@"参数==%@",dic);
    [HttpTools postWithBasePath:BaseURL Path:API_ADD_COLLECT params:dic loading:NO success:^(id  _Nonnull json) {
         success(json);
    } failure:^(NSError * _Nonnull error) {
        failed(error);
    }];
}
+(void)judgeWithImageNormal:(NSString *)imageNormal imageThem:(NSString *)imageThem success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary  *  dic=@{@"token":[UserInfoDefaults userInfo].token,
                               @"image_normal":imageNormal,
                               @"image_thumb":imageThem
       };
       [HttpTools postWithBasePath:BaseURL Path:API_JUDGE_IMAGE params:dic loading:NO success:^(id  _Nonnull json) {
            success(json);
       } failure:^(NSError * _Nonnull error) {
           failed(error);
       }];
}
+(void)getKeyWordsListWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed{
    [HttpTools getWithBasePath:BaseURL Path:API_GET_KEYWORDS_LIST params:nil success:^(id  _Nonnull json) {
         success(json);
    } failure:^(NSError * _Nonnull error) {
        failed(error);
    }];
    
}
+(void)getCollcectListWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary  *  dic=@{@"token":[UserInfoDefaults userInfo].token};
    [HttpTools getWithBasePath:BaseURL Path:API_GET_COLLECT_LIST params:dic success:^(id  _Nonnull json) {
           success(json);
      } failure:^(NSError * _Nonnull error) {
          failed(error);
      }];
}
+(void)canelCollectWithID:(int)ID success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary  *  dic=@{@"token":[UserInfoDefaults userInfo].token,
                           @"id":[NSNumber numberWithInt:ID]
         };
         [HttpTools postWithBasePath:BaseURL Path:API_CANEL_COLLECT params:dic loading:NO success:^(id  _Nonnull json) {
              success(json);
         } failure:^(NSError * _Nonnull error) {
             failed(error);
         }];
}
@end
