//
//  PersonTableViewCell.h
//  PlayFootBall
//
//  Created by 纪明 on 2019/12/12.
//  Copyright © 2019 纪明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView    *    image;
@property (nonatomic, strong) UILabel        *    label;
@property (nonatomic, strong) UILabel        *    detailLabel;
@property (nonatomic, strong) UIImageView    *    next;
@property (nonatomic, strong) UIView         *    lineView;
@end

NS_ASSUME_NONNULL_END
