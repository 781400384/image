//
//  MainHandle.h
//  ImageList
//
//  Created by 纪明 on 2019/12/20.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "BaseHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainHandle : BaseHandle
/// 获取图片根类
/// @param success <#success description#>
/// @param failed <#failed description#>
+(void)getTypeWithSucces:(SuccessBlock)success failed:(FailedBlock)failed;

/// 获取图片列表
/// @param typeId <#typeId description#>
/// @param page <#page description#>
/// @param pageNum <#pageNum description#>
/// @param success <#success description#>
/// @param failed <#failed description#>
+(void)getImageListWithTypeId:(int)typeId page:(int)page pageNum:(int)pageNum success:(SuccessBlock)success failed:(FailedBlock)failed;

/// 添加图片收藏
/// @param imageNormal <#imageNormal description#>
/// @param imageThem <#imageThem description#>
/// @param success <#success description#>
/// @param failed <#failed description#>
+(void)addCollectWithImageNormal:(NSString *)imageNormal imageThem:(NSString *)imageThem success:(SuccessBlock)success failed:(FailedBlock)failed;

/// 获取收藏列表
/// @param success <#success description#>
/// @param failed <#failed description#>
+(void)getCollcectListWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

/// 取消收藏
/// @param ID <#ID description#>
/// @param success <#success description#>
/// @param failed <#failed description#>
+(void)canelCollectWithID:(int)ID success:(SuccessBlock)success failed:(FailedBlock)failed;

/// 获取关键字列表
/// @param success <#success description#>
/// @param failed <#failed description#>
+(void)getKeyWordsListWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

/// 判断是否收藏
/// @param imageNormal <#imageNormal description#>
/// @param imageThem <#imageThem description#>
/// @param success <#success description#>
/// @param failed <#failed description#>
+(void)judgeWithImageNormal:(NSString *)imageNormal imageThem:(NSString *)imageThem success:(SuccessBlock)success failed:(FailedBlock)failed;
@end

NS_ASSUME_NONNULL_END
