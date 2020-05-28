//
//  SearchTableViewCell.m
//  ImageList
//
//  Created by 纪明 on 2019/12/19.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

-(void)layoutSubviews{
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18*KScaleH);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
//    [self addSubview:self.lineView];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(18*KScaleW);
//        make.height.mas_equalTo(0.*KScaleH);
//        make.width.mas_equalTo(SCREEN_WIDTH-36*KScaleW);
//        make.bottom.mas_equalTo(0);
//    } ];
}
-(UILabel *)label{
    if (!_label) {
        _label=[[UILabel alloc]init];
        _label.textAlignment=NSTextAlignmentCenter;
        _label.font=[UIFont systemFontOfSize:12.0];
        _label.textColor=[UIColor colorWithHexString:@"#B1ABB2"];
    }
    return _label;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#EFEFF0"];
    }
    return _lineView;
}
@end
