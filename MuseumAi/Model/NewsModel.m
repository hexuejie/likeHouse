//
//  NewsModel.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/14.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (void)setPublishdate:(NSString *)publishdate{
    _publishdate = publishdate;
    if (publishdate == nil) {
        _publishdate = _fbsj;
        if (_fbsj == nil) {
            _publishdate = _sj;
            if (_sj == nil) {
                _publishdate = _tjsj;
            }
        }
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    if (title == nil) {
        _title = _bt;
    }
}

@end
