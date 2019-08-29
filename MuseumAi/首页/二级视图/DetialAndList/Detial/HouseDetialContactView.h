//
//  HouseDetialContactView.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/8/29.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseDetialContactView : UIView<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *contentHolderLabel;


@property (assign, nonatomic) BOOL needKBoard;

@property (nonatomic ,strong) NSString *strBH;
@end

NS_ASSUME_NONNULL_END
