//
//  HouseAroundTableViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/13.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HouseAroundTableViewCell.h"

@interface AroundTableItem : UIView

@property (nonatomic,strong)UILabel *titleLabel, *contentLabel;
@property (nonatomic,strong)UIButton *locationButton;

@end

@implementation AroundTableItem

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutCommentViews];
    }
    return self;
}

-(void)layoutCommentViews{
    _titleLabel = [UILabel new];
    [self addSubview:_titleLabel];
    _titleLabel.textColor = kUIColorFromRGB(0x333333);
    _titleLabel.font = kSysFont(16);
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    _contentLabel = [UILabel new];
    [self addSubview:_contentLabel];
    _contentLabel.textColor = kUIColorFromRGB(0x8E8E8E);
    _contentLabel.font = kSysFont(14);
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self);
        make.trailing.equalTo(self).offset(-80);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
    }];
    
    
    _locationButton = [UIButton new];
    [self addSubview:_locationButton];
    [_locationButton setImage:[UIImage imageNamed:@"detial_location_tag"] forState:UIControlStateNormal];
    [_locationButton setTitleColor:kUIColorFromRGB(0x8E8E8E) forState:UIControlStateNormal];
    _locationButton.titleLabel.font = kSysFont(15);
    
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_trailing).offset(-60);
        make.centerY.equalTo(self.titleLabel);
    }];
}
@end



@interface HouseAroundTableViewCell()

@property (nonatomic,strong) NSMutableArray *imageViews;

@end

@implementation HouseAroundTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentBgView.backgroundColor = kUIColorFromRGB(0xf8f8f8);
}


- (NSMutableArray *)imageViews{
    if (_imageViews == nil) {
        _imageViews = [[NSMutableArray alloc]init];
    }
    return _imageViews;
}

- (void)setItemArray:(NSArray *)itemArray{
    _itemArray = itemArray;
    while (self.imageViews.count > _itemArray.count) {
        AroundTableItem *item = [self.imageViews lastObject];
        [item removeFromSuperview];
        [self.imageViews removeLastObject];
    }
    
    while (_itemArray.count > self.imageViews.count) {
        AroundTableItem *item = [[AroundTableItem alloc] initWithFrame:CGRectZero];
        item.clipsToBounds = YES;
        item.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentBgView addSubview:item];
        [self.imageViews addObject:item];
    }
    [self layoutCommentViews];
}

-(void)layoutCommentViews{
    
    if (self.itemArray.count == 0){
        return;
    }
    
    CGFloat kMerchantFirstGap = 12;
    
    
    for (int i = 0 ; i< [self.itemArray count]; i ++ ){
        
        AroundTableItem *item = self.imageViews[i];
        id coment = self.itemArray[i];
        item.tag = i;
        item.titleLabel.text = coment[@"zbmc"];
        item.contentLabel.text = coment[@"zbms"];
        [item.locationButton setTitle:[NSString stringWithFormat:@"%@米",coment[@"wzjl"]] forState:UIControlStateNormal];
        
        if (item.contentLabel.text.length > 0) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:item.contentLabel.text];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 2; // 调整行间距
            NSRange range = NSMakeRange(0, [item.contentLabel.text length]);
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
            [item.contentLabel setAttributedText:attributedString];
        }
        
        if (i == 0 ){
            [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentBgView).offset(15);
                make.top.equalTo(self.contentBgView).offset(kMerchantFirstGap);
                make.trailing.equalTo(self.contentBgView).offset(-kMerchantFirstGap);
            }];
        }else{
            AroundTableItem *preItem = self.imageViews[i-1];
            [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(preItem);
                make.top.equalTo(preItem.mas_bottom).offset(19);
            }];
        }if (i == [self.itemArray count]-1) {
            [item mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentBgView).offset(-kMerchantFirstGap);
            }];
        }
    }
}

//saleId = 13,
//lpbh = "200912243738",
//zbms = "蔡锷北路乐古道巷9号",
//zbmc = "长沙市艺芳中学",
//wzjl = 107,
//zblx = 1,
//bh = 318,

@end
