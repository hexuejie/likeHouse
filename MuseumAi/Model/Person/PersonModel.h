//
//  PersonModel.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/25.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "jtcyPersonModel.h"
#import "zzxxPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonModel : NSObject

@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) jtcyPersonModel *jtcy;
@property (nonatomic,strong) zzxxPersonModel *zzxx;
@property (nonatomic,strong) NSDictionary *sfz;
@end

NS_ASSUME_NONNULL_END
