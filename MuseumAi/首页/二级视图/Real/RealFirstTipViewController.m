//
//  RealFirstTipViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/29.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "RealFirstTipViewController.h"
#import "RealFirstChooseViewController.h"
#import "ChooseQualificationTypeViewController.h"
#import "ChooseOtherRealViewController.h"

@interface RealFirstTipViewController ()

@end

@implementation RealFirstTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.contentTextView.attributedText = [[NSAttributedString alloc] initWithString:self.contentTextView.text attributes:attributes];
    
    if ([self.title isEqualToString:@"购房资格审查说明"]) {
        [self.bottomButton setTitle:@"阅读完毕，下一步" forState:UIControlStateNormal];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 2;// 字体的行间距
        self.contentTextView.text = @"1、购房资格预审以您提交的信息为主要审核依据，不代表最终审查结果，如您提供的信息有误，有可能导致预审结果错误，届时，网签将无法通过，由此导致的后果由您自行承担。\n\n2、购房资格审查需要准备以下文件:申请人身份证原件、户口本原件或扫描件、结婚证原件或扫描件(已婚)、离婚证原件或扫描件(离异) ;申请人配偶身份证原件、户口本原件或扫描件;申请人未成年子女户口本原件或扫描件。\n\n3、申请人家庭成员包括配偶或前配偶、未成年子女，如子女已满18岁，则无需登记。\n\n4、如申请人婚姻状况为离异， 则需上传离婚证并添加前配偶以下信息，包括前配偶姓名、户籍所在地、身份证号码。如申请人离异后再婚且未再离异，则仅需上传当前配偶信息及所。\n\n5、购房资格审查信息提交后，需工作人员人工审核，审核周期为5个工作日。预审结果将通过APP、短信等方式通知申请人。\n\n6、本APP提供身份证的OCR识别转化功能，如识别信息有误，请手动修改，务必保证提交信息与实际情况一致，并保证户口本已更新至最新状况，因信息不实造成的损失由本人承担。\n\n7、资格审查的预审结果将根据政策的变动而进行调整，最终审核结果以购房网签时进行的购房资格审查结果为准。\n\n8、工作单位不在长沙市的省直企业职工，不能凭社保在长沙限购区买房，该类人员请不要在长沙购房APP上提交购房资格审查，否则，可能app审核通过，买到房后的网签购房资格审查不通过。";
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:12],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.contentTextView.attributedText = [[NSAttributedString alloc] initWithString:self.contentTextView.text attributes:attributes];
    }
}
- (IBAction)finishClick:(id)sender {
    if ([self.title isEqualToString:@"购房资格审查说明"]) {
        [self.navigationController pushViewController:[ChooseQualificationTypeViewController new] animated:YES];//购房资格审核
    }else{//[RealFirstChooseViewController
        [LoginSession sharedInstance].pageType = 0;
        [self.navigationController pushViewController:[ChooseOtherRealViewController new] animated:YES];
//        [self.navigationController pushViewController:[RealFirstChooseViewController new] animated:YES];
    }
}

@end
