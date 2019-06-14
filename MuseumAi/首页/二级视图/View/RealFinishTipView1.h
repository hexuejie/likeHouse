//
//  RealFinishTipView1.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/30.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RealFinishTipView1 : UIView

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureWidthContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBottomCantant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureMagin;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (assign, nonatomic) NSInteger sureType;












@property (weak, nonatomic) IBOutlet UIView *textFieldView;

//信息确认
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;

@property (weak, nonatomic) IBOutlet UITextField *textField5;
@property (weak, nonatomic) IBOutlet UITextField *textField6;
@property (weak, nonatomic) IBOutlet UITextField *textField7;
@property (weak, nonatomic) IBOutlet UITextField *textField8;




@property (weak, nonatomic) IBOutlet UIView *finishContentView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTipLabel;


@property (weak, nonatomic) IBOutlet UIView *exampleSecondView;
@property (weak, nonatomic) IBOutlet UIImageView *exampleImage;//exampleSecond   我知道了
@property (weak, nonatomic) IBOutlet UILabel *exampleTipLabel;


- (void)customHidden;

- (void)setContentLineSpacing:(CGFloat)lineSpacing;
@end

NS_ASSUME_NONNULL_END
