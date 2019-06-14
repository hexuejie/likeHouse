//
//  ReleaseHomeworkTimeViewMask.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/25.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReleaseHomeworkTimeViewMask : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickBottom;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;







@property (strong, nonatomic) IBOutlet UIPickerView *customPick;
@property (strong, nonatomic) NSString *selectedString;

@property (strong, nonatomic) NSArray *customPickArray;

@end

NS_ASSUME_NONNULL_END
