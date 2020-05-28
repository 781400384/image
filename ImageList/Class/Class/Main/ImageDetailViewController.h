//
//  ImageDetailViewController.h
//  ImageList
//
//  Created by 纪明 on 2019/12/19.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageDetailViewController : BaseViewController
@property (nonatomic, copy) NSString   *   imgUrl;
@property (nonatomic, copy) NSString   *   imgId;
@property (nonatomic, copy) NSString   *   themubUrl;
@property (nonatomic, copy) NSString   *   type;//1是收藏   2取消收藏
@end

NS_ASSUME_NONNULL_END
