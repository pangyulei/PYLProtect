//
//  Person.m
//  PYLProtect
//
//  Created by yulei pang on 2019/2/28.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    } else {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    anInvocation.selector = @selector(log);
    [anInvocation invokeWithTarget:self];
}

- (void)log {
    NSLog(@"person log");
}

@end
