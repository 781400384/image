//
//  PersonTableViewCell.m
//  PlayFootBall
//
//  Created by 纪明 on 2019/12/12.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

-(void)layoutSubviews{
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13*KScaleW);
        make.width.mas_equalTo(SCREEN_WIDTH-26*KScaleW);
        make.height.mas_equalTo(54*KScaleH);
    }];
    [self.lineView addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(22*KScaleW);
        make.centerY.mas_equalTo(self.lineView.centerY);
        make.height.width.mas_equalTo(16*KScaleW);
    }];
    [self.lineView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.image.mas_right).offset(21.5*KScaleW);
        make.centerY.mas_equalTo(self.lineView.mas_centerY);
    }];
    [self.lineView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-23*KScaleW);
        make.centerY.mas_equalTo(self.lineView.mas_centerY);
    }];
    [self.lineView addSubview:self.next];
    [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17.5*KScaleW);
        make.centerY.mas_equalTo(self.lineView.mas_centerY);
        make.width.height.mas_equalTo(12*KScaleW);
    }];
    
}
-(UIImageView *)image{
    if (!_image) {
        _image=[[UIImageView alloc]init];
        _image.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _image;
}
-(UILabel *)label{
    if (!_label) {
        _label=[[UILabel alloc]init];
        _label.textColor=[UIColor colorWithHexString:@"#1F1812"];
        _label.font=APP_NORMAL_FONT(14.0);
        _label.textAlignment=NSTextAlignmentCenter;
    }
    return _label
    ;
}
-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel=[[UILabel alloc]init];
        _detailLabel.textColor=[UIColor colorWithHexString:@"#B1ABB2"];
        _detailLabel.font=APP_NORMAL_FONT(14.0);
        _detailLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _detailLabel
    ;
}
-(UIImageView *)next{
    if (!_next) {
        _next=[[UIImageView alloc]init];
        _next.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _next;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=[UIColor whiteColor];
        _lineView.layer.borderWidth=0.5*KScaleW;
        _lineView.layer.borderColor=[UIColor colorWithHexString:@"#EFEFF0"].CGColor;
        [_lineView setRadius:5*KScaleW];
    }
    return _lineView;
}

@end
