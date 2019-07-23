//
//  ResultImageTableViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/11.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ResultImageTableViewCell.h"

@interface ResultImageTableViewCell()

@property (nonatomic,strong) NSMutableArray *imageViews;

@end

@implementation ResultImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




- (NSMutableArray *)imageViews{
    if (_imageViews == nil) {
        _imageViews = [[NSMutableArray alloc]init];
    }
    return _imageViews;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    while (self.imageViews.count > _imageArray.count) {
        UIImageView *item = [self.imageViews lastObject];
        [item removeFromSuperview];
        [self.imageViews removeLastObject];
    }
    
    while (_imageArray.count > self.imageViews.count) {
        UIImageView *item = [[UIImageView alloc] initWithFrame:CGRectZero];
        item.clipsToBounds = YES;
        item.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:item];
        [self.imageViews addObject:item];
    }
    [self layoutCommentViews];
}

-(void)layoutCommentViews{
    
    if (self.imageArray.count == 0){
        return;
    }

    
    CGFloat firstWidth = 168*CustomScreenFit;
    CGFloat kMerchantLeading = 12;
    CGFloat kMerchantFirstGap = 12;
    
    CGFloat kFirtLineNumber = 2;
    
    for (int i = 0 ; i < kFirtLineNumber &&i< [self.imageArray count]; i ++ ){
        
        UIImageView *item = self.imageViews[i];
        id coment = self.imageArray[i];
        item.tag = i;
        if ([coment isKindOfClass:[UIImage class]]) {
            item.image = coment;
        }else{
            item.contentMode = UIViewContentModeScaleAspectFill;
            [item setCommenImageUrl:coment];
        }
//        item.backgroundColor = kTestColor;
        if (i == 0 ){
            [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(kMerchantLeading);
                make.top.equalTo(self.contentView).offset(23);
                make.width.mas_equalTo(firstWidth);
                make.height.equalTo(item.mas_width).multipliedBy(0.6430).with.priority(900);
            }];
        }else{
            UIImageView *preItem = self.imageViews[i-1];
            [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.width.height.equalTo(preItem);
                make.leading.equalTo(preItem.mas_trailing).offset(kMerchantFirstGap);
            }];
        }
        
    }
    
    NSInteger remainNumber = [_imageArray count] - kFirtLineNumber;
    
    if (remainNumber <= 0) {
        return;
    }
    CGFloat kSecondLineNumber = 2;
    
    NSUInteger loopTimes = remainNumber / kSecondLineNumber;
    NSUInteger plusNumber = (remainNumber - loopTimes * kSecondLineNumber) == 0 ? 0 : 1;
    
    loopTimes += plusNumber;
    
    CGFloat secondWidth = firstWidth;
    CGFloat kMerchantSecondGap = 12;
    
    for (int i=0; i<loopTimes;i++ ){
        for (int j=0; j<kSecondLineNumber;j++ ){
            
            NSUInteger index = kFirtLineNumber + i*kSecondLineNumber + j ;
            
            if (index >= [_imageArray count] ){
                return;
            }
            
            UIImageView *item = self.imageViews[index];
            item.tag = (i+1)*2 +j;
            id coment = self.imageArray[item.tag];
            if ([coment isKindOfClass:[UIImage class]]) {
                item.image = coment;
            }else{
                item.contentMode = UIViewContentModeScaleAspectFill;
                [item setCommenImageUrl:coment];
            }
//            item.backgroundColor = kTestColor;
            
            if (index == kFirtLineNumber){ //第一个
                UIImageView *preItem = self.imageViews[0];
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(preItem.mas_leading);
                    make.top.equalTo(preItem.mas_bottom).offset(kMerchantSecondGap);
                    make.width.mas_equalTo(secondWidth);
                    make.height.equalTo(item.mas_width).multipliedBy(0.6430).with.priority(900);
                }];
            }else{
                
                if (j == 0){
                    NSInteger index = kFirtLineNumber + (i-1)*kSecondLineNumber;
                    UIImageView *preItem = self.imageViews[index];
                    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.leading.width.height.equalTo(preItem);
                        make.top.equalTo(preItem.mas_bottom).offset(kMerchantSecondGap);
                    }];
                    
                }else{
                    
                    UIImageView *preItem = self.imageViews[index - 1];
                    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.width.height.equalTo(preItem);
                        make.leading.equalTo(preItem.mas_trailing).offset(kMerchantSecondGap);
                    }];
                    
                }
                
            }
        }
    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
