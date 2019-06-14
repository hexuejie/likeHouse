//
//  RealFinishTipView1.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/30.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "RealFinishTipView1.h"

@interface RealFinishTipView1 ()

@end

@implementation RealFinishTipView1

- (void)setSureType:(NSInteger)sureType{
    _sureType = sureType;
    
    
    if (_sureType == 6) {//外籍
        
        self.contentTipLabel.text = @"";
        
        self.exampleImage.image = [UIImage imageNamed:@"exampleSecond"];
        self.exampleSecondView.frame = CGRectMake(0, 0, 315*CustomScreenFit, 260);
        [self.contentview addSubview:self.exampleSecondView];
        self.titleLabel.text = @"";
        self.tipLabel.text = @"";
        self.cancelButton.hidden = YES;
        self.sureWidthContent.constant = 200*CustomScreenFit;
        self.sureBottomCantant.constant = 36;
        self.sureMagin.constant = 58;
        [self.sureButton setTitle:@"我知道了" forState:UIControlStateNormal];
        
        [self.exampleSecondView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self.contentview);
        }];
    }else if (_sureType == 5) {
        
        self.contentTipLabel.text = @"";
        
        self.exampleSecondView.frame = CGRectMake(0, 0, 315*CustomScreenFit, 260);
        [self.contentview addSubview:self.exampleSecondView];
        self.titleLabel.text = @"";
        self.tipLabel.text = @"";
        self.cancelButton.hidden = YES;
        self.sureWidthContent.constant = 200*CustomScreenFit;
        self.sureBottomCantant.constant = 36;
        self.sureMagin.constant = 58;
        [self.sureButton setTitle:@"我知道了" forState:UIControlStateNormal];
        
        [self.exampleSecondView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self.contentview);
        }];
    }else if (_sureType == 4) {//港澳台
        
        self.exampleTipLabel.text = @"";
        self.contentTipLabel.text = @"";
        self.exampleImage.image = [UIImage imageNamed:@"exampleSecond2"];
        
        self.exampleSecondView.frame = CGRectMake(0, 0, 315*CustomScreenFit, 204);
        [self.contentview addSubview:self.exampleSecondView];
        self.titleLabel.text = @"";
        self.tipLabel.text = @"";
        self.cancelButton.hidden = YES;
        self.sureWidthContent.constant = 200*CustomScreenFit;
        self.sureBottomCantant.constant = 36;
        self.sureMagin.constant = 58;
        [self.sureButton setTitle:@"我知道了" forState:UIControlStateNormal];
        
        [self.exampleSecondView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self.contentview);
            make.height.mas_equalTo(204);
        }];
    }else if (_sureType == 3) {
        
        self.exampleTipLabel.text = @"";
        self.contentTipLabel.text = @"";
        
        self.exampleImage.image = [UIImage imageNamed:@"exampleFirst2"];
        self.exampleSecondView.frame = CGRectMake(0, 0, 315*CustomScreenFit, 204);
        [self.contentview addSubview:self.exampleSecondView];
        self.titleLabel.text = @"";
        self.tipLabel.text = @"";
        self.cancelButton.hidden = YES;
        self.sureWidthContent.constant = 200*CustomScreenFit;
        self.sureBottomCantant.constant = 36;
        self.sureMagin.constant = 58;
        [self.sureButton setTitle:@"我知道了" forState:UIControlStateNormal];
        
        [self.exampleSecondView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self.contentview);
            make.height.mas_equalTo(204);
        }];
    }else   if (_sureType == 2) {//军人提示
        self.contentTitleLabel.text = @"依照相关政策，军人实名认证和购房审查功能暂时关闭，请至楼盘线下认筹！";
        self.contentTipLabel.text = @"";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contentTitleLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5; // 调整行间距
        NSRange range = NSMakeRange(0, [self.contentTitleLabel.text length]);
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [self.contentTitleLabel setAttributedText:attributedString];
        
        self.finishContentView.frame = CGRectMake(0, 0, 315*CustomScreenFit, 91);
        [self.contentview addSubview:self.finishContentView];
        self.titleLabel.text = @"";
        self.cancelButton.hidden = YES;
        self.sureWidthContent.constant = 200*CustomScreenFit;
        self.sureBottomCantant.constant = 36;
        self.sureMagin.constant = 58;
        [self.sureButton setTitle:@"好的" forState:UIControlStateNormal];
        
        [self.finishContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self.contentview);
        }];
    }else if (_sureType == 1) {//提交完成
        self.finishContentView.frame = CGRectMake(0, 0, 315*CustomScreenFit, 91);
        [self.contentview addSubview:self.finishContentView];
        self.titleLabel.text = @"";
        self.cancelButton.hidden = YES;
        self.sureWidthContent.constant = 200*CustomScreenFit;
        self.sureBottomCantant.constant = 36;
        self.sureMagin.constant = 58;
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
        
        [self.finishContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self.contentview);
        }];
    }else if (_sureType == 0) {
        self.textFieldView.frame = CGRectMake(0, 0, 315*CustomScreenFit, 291);
        [self.contentview addSubview:self.textFieldView];

        [self.textFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self.contentview);
        }];
    }else if (_sureType == -1) {//未实名r认证  两个按钮
        [self.cancelButton setTitle:@"稍后认证" forState:UIControlStateNormal];
        [self.sureButton setTitle:@"去认证" forState:UIControlStateNormal];
        
        self.contentTitleLabel.text = @"您尚未进行实名认证，请先认证！";
        self.contentTipLabel.text = @"";
        
        
        self.contentTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.finishContentView.frame = CGRectMake(0, 0, 315*CustomScreenFit, 91);
        [self.contentview addSubview:self.finishContentView];
        self.titleLabel.text = @"";
        
        [self.finishContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self.contentview);
        }];
    }
    
    
    
}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.sureWidthContent.constant = 130*CustomScreenFit;
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 2.0;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 2.0;
    self.cancelButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderColor = kUIColorFromRGB(0x9E9C9F).CGColor;
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
}

- (IBAction)sureButtonClick:(id)sender {
    
    [self closeClick:nil];
}

- (IBAction)cancelButtonClick:(id)sender {
    
    [self closeClick:nil];
}
- (IBAction)closeClick:(id)sender {
    [self customHidden];
}

- (void)customHidden{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

- (void)setContentLineSpacing:(CGFloat)lineSpacing{
    if (self.contentTitleLabel.text.length <= 0) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contentTitleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing; // 调整行间距
    NSRange range = NSMakeRange(0, [self.contentTitleLabel.text length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [self.contentTitleLabel setAttributedText:attributedString];
}
@end
