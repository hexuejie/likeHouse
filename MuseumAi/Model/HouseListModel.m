//
//  HouseListModel.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/28.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HouseListModel.h"

@implementation HouseListModel

- (void)setBq:(NSString *)bq{
    _bq = bq;
    
    if (_bq) {
        _bq = [NSString stringWithFormat:@" %@",_bq];
        _bq = [_bq stringByReplacingOccurrencesOfString:@","withString:@"  "];
    }
}

@end
