//
//  MainCollectionViewCell.m
//  ImageList
//
//  Created by 纪明 on 2019/12/19.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "MainCollectionViewCell.h"

@implementation MainCollectionViewCell


-(void)layoutSubviews{
    [self addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(self.height);
    }];
}
-(UIImageView *)image{
    if (!_image) {
        _image=[[UIImageView alloc]init];
        _image.clipsToBounds=YES;
        _image.userInteractionEnabled=YES;
        _image.contentMode=UIViewContentModeScaleAspectFill;
    }
    return _image;
}
-(void)setModel:(ImageModel *)model{
    _model=model;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.img_thumb] placeholderImage:[UIImage imageNamed:@""]];
}
-(void)setCollectModel:(CollectModel *)collectModel{
    _collectModel=collectModel;
      [self.image sd_setImageWithURL:[NSURL URLWithString:collectModel.image_thumb] placeholderImage:[UIImage imageNamed:@""]];
}
-(void)setSearchModel:(SearchModel *)searchModel{
    _searchModel=searchModel;
     [self.image sd_setImageWithURL:[NSURL URLWithString:searchModel.thumbURL] placeholderImage:[UIImage imageNamed:@""]];
}
@end
