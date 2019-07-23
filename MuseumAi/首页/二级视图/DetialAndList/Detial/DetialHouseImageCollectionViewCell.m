//
//  DetialHouseImageCollectionViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "DetialHouseImageCollectionViewCell.h"

@implementation DetialHouseImageCollectionViewCell

//-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithReuseIdentifier:reuseIdentifier]){
//        [self setup];
//    }
//    return self;
//}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup{
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 257)];
    [self.contentView addSubview: _allView];
    
    
    [_allView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(3);
        
        make.trailing.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    _allImageView = [[UIImageView alloc]init];
    _allImageView.clipsToBounds = YES;
    [_allView addSubview:_allImageView];
    [_allImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(self.allView);
    }];
    _allImageView.contentMode = UIViewContentModeScaleToFill;
    
    
    
    _mapView = [[DetialCustomMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-24, 257-18)];
    [self.contentView addSubview: _mapView];
    _mapView.clipsToBounds = YES;
    [_allView addSubview:_mapView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(self.allView);
    }];
    _allView.contentMode = UIViewContentModeScaleToFill;
}


@end
