//
//  HouseDetialFeedbackViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/13.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HouseDetialFeedbackViewController.h"

@interface HouseDetialFeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *contentHolderLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (assign, nonatomic) BOOL needKBoard;
@end

@implementation HouseDetialFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    self.contentHolderLabel.hidden = NO;
    self.contentTextView.delegate = self;
    self.phoneTextField.delegate = self;
    if (![self.title isEqualToString:@"反馈纠错"]) {
        self.titleLabel.text = @"咨询内容";
        self.contentHolderLabel.text = @"请输入您想咨询的内容";
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardChange:(NSNotification *)note{
    if (self.needKBoard) {
        CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyHeight =  [UIScreen mainScreen].bounds.size.height - frame.origin.y;
        self.view.frame = CGRectMake(0, -keyHeight/3, SCREEN_WIDTH, SCREEN_HEIGHT);
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
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
    self.countLabel.text = [NSString stringWithFormat:@"%ld",textView.text.length];
}

- (IBAction)updateFinishClick:(id)sender {
    [SVProgressHelper dismissWithMsg:@"已提交"];
    [self callBackClick];
}

@end
