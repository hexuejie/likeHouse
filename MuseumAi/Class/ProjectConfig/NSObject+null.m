//
//  NSObject+null.m
//  banni
//
//  Created by zhudongliang on 2018/11/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NSObject+null.h"

@implementation NSObject (null)

- (id)removeNull{
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dic = self.mutableCopy;
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSNull class]]) {
                /**
                 *  @brief  此处直接移除null，而不是替换为字符串
                 *  替换成字符串可能导致程序闪退，原因：原本是要NSArray或者NSDictionary对象，我们替换成NSString对象，导致读取出错而闪退
                 */
                [dic removeObjectForKey:key];
                
            }
            if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
                 id newObj = [obj removeNull];
                [dic setObject:newObj forKey:key];
            }
        }];
        return dic;
    }
    if ([self isKindOfClass:[NSArray class]]) { //后台null
        // 拷贝为可变数组
        NSMutableArray *replaced = [NSMutableArray arrayWithArray:self];
        
        // 移除当前数组中的null对象
        [replaced removeObjectsAtIndexes:[(NSArray*)self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [obj isKindOfClass:[NSNull class]];
        }]];
        
        // 遍历数组，移除当前数组中的元素是数组或字典中包含的null对象
        [replaced enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([obj isKindOfClass:[NSNull class]]) {
                /**
                 *  @brief  此处直接移除null，而不是替换为字符串
                 *  替换成字符串可能导致程序闪退，原因：原本是要NSArray或者NSDictionary对象，我们替换成NSString对象，导致读取出错而闪退
                 */
                [replaced removeObjectAtIndex:idx];
                
            }
            if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
                
                id newObj = [obj removeNull];
                [replaced replaceObjectAtIndex:idx withObject:newObj];
                
            }
        }];
        
        return replaced;
    }
    return self;
}

@end
