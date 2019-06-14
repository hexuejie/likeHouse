//
//  ReleaseHomeworkTimeViewMask.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/25.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "ReleaseHomeworkTimeViewMask.h"

@implementation ReleaseHomeworkTimeViewMask

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    _pickBottom.locale = locale;
  
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self .backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    self.pickBottom.backgroundColor = [UIColor whiteColor];
    
    [self.pickBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(220);
    }];
}

- (void)setCustomPickArray:(NSArray *)customPickArray{
    _customPickArray = customPickArray;
    
    if (!_customPick) {
        self.customPick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        [self addSubview:self.customPick];
    }
    
    self.customPick.backgroundColor = [UIColor whiteColor];
    
    self.customPick.delegate = self;
    self.customPick.dataSource = self;
    [self.customPick reloadAllComponents];
    
    [self.customPick mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(150);
    }];
}


#pragma mark pickerview function
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  [_customPickArray count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0f;

}


//显示的标题

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *str = [_customPickArray objectAtIndex:row];
    
    return str;
    
}

////显示的标题字体、颜色等属性
//
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
//
//    NSString *str = [_nameArray objectAtIndex:row];
//
//    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
//
//    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
//
//
//
//    return AttributedString;
//
//}//NS_AVAILABLE_IOS(6_0);



//被选择的行

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSLog(@"HANG%@",[_customPickArray objectAtIndex:row]);
    self.selectedString = [_customPickArray objectAtIndex:row];
}



@end
