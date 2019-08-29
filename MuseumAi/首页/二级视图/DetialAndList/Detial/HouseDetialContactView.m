//
//  HouseDetialContactView.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/8/29.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HouseDetialContactView.h"

@implementation HouseDetialContactView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentHolderLabel.hidden = NO;
    self.contentTextView.delegate = self;
    self.phoneTextField.delegate = self;
    if ([LoginSession sharedInstance].phone) {
        self.phoneTextField.text = [LoginSession sharedInstance].phone;
    }
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.45];
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardChange:(NSNotification *)note{
    if (self.needKBoard) {
        CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyHeight =  [UIScreen mainScreen].bounds.size.height - frame.origin.y;
        self.frame = CGRectMake(0, -keyHeight/3, SCREEN_WIDTH, SCREEN_HEIGHT);
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.needKBoard = NO;
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.needKBoard = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length+text.length>300&&text>0) {
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length) {
        self.contentHolderLabel.hidden = YES;
    }else{
        self.contentHolderLabel.hidden = NO;
    }
}

- (IBAction)updateFinishClick:(id)sender {
    if(self.contentTextView.text.length == 0) {
        [SVProgressHelper dismissWithMsg: @"请输入您想咨询的内容"];
        return;
    }
    
    if (!_strBH) {
        _strBH = @"201806110829";
    }
    NSString *strURL;
    NSDictionary *pram;
    strURL = @"/api/family/xf/user/lxw";
    pram = @{@"saleid":_strBH
             ,@"nr":self.contentTextView.text
             ,@"sjhm":[NSString stringWithFormat:@"%@",self.phoneTextField.text]
             };
    
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/xf/user/lxw") para:pram isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        if (success) {
            [SVProgressHelper dismissWithMsg:@"已提交"];
            [weakSelf removeFromSuperview];
            
        }else{
            [SVProgressHelper dismissWithMsg:@"提交失败"];
        }
    }];
}


- (IBAction)closeClick:(id)sender {
    [self removeFromSuperview];
}

@end
