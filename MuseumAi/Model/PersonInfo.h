//
//  PersonInfo.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonInfo : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,strong) NSDictionary *allmessageDic;

@end

NS_ASSUME_NONNULL_END
