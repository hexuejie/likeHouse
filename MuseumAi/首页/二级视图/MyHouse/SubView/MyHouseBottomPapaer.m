//
//  MyHouseBottomPapaer.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/11.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseBottomPapaer.h"
#import "MyHousePaperViewController.h"

@implementation MyHouseBottomPapaer
- (IBAction)paperBottomClick:(id)sender {
    if (_detialArray.count>0) {
//        MyHousePaperViewController *vc = [MyHousePaperViewController new];
//        vc.title = @"完税凭证";
//        vc.url = _url;
//        [[ProUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
        
        return;
    }
    MyHousePaperViewController *vc = [MyHousePaperViewController new];
    vc.title = @"完税凭证";
    vc.url = _url;
    [[ProUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)setDetialArray:(NSArray *)detialArray{
    _detialArray = detialArray;
    
    [_titleButton setTitle:@"查看缴费明细" forState:UIControlStateNormal];
}
@end
