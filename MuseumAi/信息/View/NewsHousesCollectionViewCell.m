//
//  NewsHousesCollectionViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "NewsHousesCollectionViewCell.h"

@implementation NewsHousesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backView.backgroundColor = kListBgColor;
}


- (void)setNewsModel:(NewsModel *)newsModel{
    _newsModel = newsModel;
    
    _contentLabel.text = @"";
//    _titleLabel.numberOfLines = 0;
    
    
    _titleLabel.text = newsModel.title;
    _contentLabel.text = newsModel.publishdate;
    if (_titleLabel.text.length == 0) {
        _titleLabel.text = newsModel.bt;
    }
    if (_contentLabel.text.length == 0) {
        _contentLabel.text = newsModel.fbsj;
    }
    if (_contentLabel.text.length == 0) {
        _contentLabel.text = newsModel.sj;
    }
    [self.coverImageView setOtherImageUrl:_newsModel.img];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5; // 调整行间距
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_titleLabel.text length])];
    [_titleLabel setAttributedText:attributedString];
}

@end
