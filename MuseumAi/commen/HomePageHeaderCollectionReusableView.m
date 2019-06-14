//
//  HomePageHeaderCollectionReusableView.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/27.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HomePageHeaderCollectionReusableView.h"

@implementation HomePageHeaderCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        [self addSubview:_topLine];
        _topLine.backgroundColor = kUIColorFromRGB(0xF4F4F4);
        
        
       _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 24, SCREEN_WIDTH, 10)];
        _titleLabel.textColor = kUIColorFromRGB(0x444444);
        _titleLabel.font = kSysFont(18);
        [self addSubview:_titleLabel];
        _titleLabel.text = @"最新开盘";
        
        _intoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH-14, 18)];
        _intoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_intoButton setImage:[UIImage imageNamed:@"push_into"] forState:UIControlStateNormal];
        [self addSubview:_intoButton];
        _intoButton.hidden = YES;
    }
    return self;
}


@end
