//
//  PersonInfo.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "PersonInfo.h"

static PersonInfo *session;
static dispatch_once_t onceToken;
@implementation PersonInfo

+ (instancetype)sharedInstance{
    dispatch_once(&onceToken, ^{
        if (session == nil) {
            session = [[PersonInfo alloc] init];
        }
    });
    return session;
}

@end
