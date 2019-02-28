//
//  Boy.m
//  PYLProtect
//
//  Created by yulei pang on 2019/2/28.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "Boy.h"
#import "NSObject+PYLProtect.h"

@implementation Boy

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceOldMethod:@selector(m1) toNewMethod:@selector(m2)];
    });
}
@end
