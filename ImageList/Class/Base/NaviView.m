//
//  NaviView.m
//  PlayFootBall
//
//  Created by 纪明 on 2019/12/7.
//  Copyright © 2019 纪明. All rights reserved.
//

#import "NaviView.h"

@implementation NaviView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    [self addSubview:self.leftItemButton];
    [self addSubview:self.naviTitleLabel];
    [self addSubview:self.rightItemButton];
    [self addSubview:self.rightTitleLabel];
    
    [self.rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15*KScaleW));
        make.centerY.equalTo(self.naviTitleLabel);
    }];
    
    
}

- (UIButton *)leftItemButton {
    
    if (!_leftItemButton) {
        CGFloat y = IS_X ? NAVI_SUBVIEW_Y_iphoneX : NAVI_SUBVIEW_Y_Normal;
        _leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftItemButton.frame = CGRectMake(13, y, 7.5, self.height-y);
        _leftItemButton.titleLabel.font = APP_MAIN_FONT;
        [_leftItemButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    }
    return _leftItemButton;
}
- (UIButton *)rightItemButton {
    
    if (!_rightItemButton) {
        CGFloat y = IS_X ? NAVI_SUBVIEW_Y_iphoneX : NAVI_SUBVIEW_Y_Normal;
        _rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightItemButton.frame = CGRectMake(SCREEN_WIDTH-70, y, 65, self.height-y);
        _rightItemButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _rightItemButton;
}

- (UILabel *)rightTitleLabel {
    
    if (!_rightTitleLabel) {
        _rightTitleLabel = [[UILabel alloc]init];
        _rightTitleLabel.font = APP_MAIN_FONT;
        _rightTitleLabel.textAlignment = NSTextAlignmentRight;
        [_rightTitleLabel sizeToFit];
        _rightTitleLabel.userInteractionEnabled = YES;
    }
    return _rightTitleLabel;
}

- (UILabel *)naviTitleLabel {
    
    if (!_naviTitleLabel) {
        
        CGFloat y = IS_X ? NAVI_SUBVIEW_Y_iphoneX : NAVI_SUBVIEW_Y_Normal;
        _naviTitleLabel = [[UILabel alloc]init];
            _naviTitleLabel.frame=CGRectMake(self.leftItemButton.right+11.5, y, SCREEN_WIDTH-self.leftItemButton.width*2-10*2, self.height-y);
        _naviTitleLabel.textAlignment = NSTextAlignmentLeft;
        _naviTitleLabel.textColor = [UIColor colorWithHexString:@"#6A676C"];
        _naviTitleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    }
    return _naviTitleLabel;
}

@end
