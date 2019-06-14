//
//  LoginSession.m
//  banni
//
//  Created by zhudongliang on 2018/11/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LoginSession.h"
//#import "ProUtils.h"
static LoginSession *session;
static dispatch_once_t onceToken;
@implementation LoginSession


+ (instancetype)sharedInstance{
    dispatch_once(&onceToken, ^{
        if (session == nil) {
            if ([ProUtils isNilOrNull:[ProUtils unarchiverSession].token]) {
                session = [[LoginSession alloc] init];
            } else {
                session = [ProUtils unarchiverSession];
            }
        }
    });
    return session;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.introduct forKey:@"introduct"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.headImg forKey:@"headImg"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
//    [aCoder encodeObject:self.addressInfo forKey:@"addressInfo"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.guidelink forKey:@"guidelink"];
    [aCoder encodeObject:self.schoolname forKey:@"schoolname"];
    [aCoder encodeObject:self.lstTagName forKey:@"lstTagName"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeBool:self.isBindWeChat forKey:@"isBindWeChat"];
    [aCoder encodeBool:self.isBindWeChat forKey:@"isBindWeChat"];
    [aCoder encodeBool:self.isHasUnreadMessage forKey:@"isHasUnreadMessage"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    self.token = [aDecoder decodeObjectForKey:@"token"];
    self.sex = [aDecoder decodeObjectForKey:@"sex"];
    self.introduct = [aDecoder decodeObjectForKey:@"introduct"];
    self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
    self.headImg = [aDecoder decodeObjectForKey:@"headImg"];
    self.phone = [aDecoder decodeObjectForKey:@"phone"];
//    self.addressInfo = [aDecoder decodeObjectForKey:@"addressInfo"];
    self.userId = [aDecoder decodeObjectForKey:@"userId"];
    self.guidelink = [aDecoder decodeObjectForKey:@"guidelink"];
    self.schoolname = [aDecoder decodeObjectForKey:@"schoolname"];
    self.lstTagName = [aDecoder decodeObjectForKey:@"lstTagName"];
    self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
    self.isBindQQ = [aDecoder decodeBoolForKey:@"isBindQQ"];
    self.isBindWeChat = [aDecoder decodeBoolForKey:@"isBindWeChat"];
    self.isHasUnreadMessage = [aDecoder decodeBoolForKey:@"isHasUnreadMessage"];
    return self;
}
- (instancetype)copyWithZone:(NSZone *)zone
{
    return session;
}
- (void)destroyInstance{
    onceToken = 0;
    session = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DestroyUserInfo" object:nil];
    [ProUtils removeSession];
}

- (BOOL)isLogin{
    if ([LoginSession sharedInstance].userId && [LoginSession sharedInstance].token) {
        return YES;
    }
    return NO;
}


@end
