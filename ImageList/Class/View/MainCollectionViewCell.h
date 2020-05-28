//
//  MainCollectionViewCell.h
//  ImageList
//
//  Created by 纪明 on 2019/12/19.
//  Copyright © 2019 纪明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"
#import "CollectModel.h"
#import "SearchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) SearchModel    *    searchModel;
@property (nonatomic, strong) ImageModel     *    model;
@property (nonatomic, strong) CollectModel   *    collectModel;
@property (nonatomic, strong) UIImageView    *    image;
@end

NS_ASSUME_NONNULL_END
