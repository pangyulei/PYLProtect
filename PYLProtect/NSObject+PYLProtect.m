//
//  NSObject+PYLProtect.m
//  PYLProtect
//
//  Created by yulei pang on 2019/2/28.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "NSObject+PYLProtect.h"
#import <objc/runtime.h>

@implementation NSObject (Basic)

+ (void)swizzleInstanceOldMethod:(SEL)oldSEL toNewMethod:(SEL)newSEL
{
    Method oldMethod = class_getInstanceMethod(self, oldSEL);
    Method newMethod = class_getInstanceMethod(self, newSEL);
    if (!oldMethod || !newMethod) {
        return;
    }
    IMP oldIMP = method_getImplementation(oldMethod);
    IMP newIMP = method_getImplementation(newMethod);
    const char *oldType = method_getTypeEncoding(oldMethod);
    const char *newType = method_getTypeEncoding(newMethod);
    class_replaceMethod(self, oldSEL, newIMP, newType);
    class_replaceMethod(self, newSEL, oldIMP, oldType);
}

@end

//防止 unrecognize selector send to instance
@implementation NSObject (PYLProtect)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceOldMethod:@selector(methodSignatureForSelector:) toNewMethod:@selector(_pyl_protect_methodSignatureForSelector:)];
        [self swizzleInstanceOldMethod:@selector(forwardInvocation:) toNewMethod:@selector(_pyl_protect_forwardInvocation:)];
    });
}

- (NSMethodSignature *)_pyl_protect_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [self _pyl_protect_methodSignatureForSelector:aSelector];
    if (sig) {
        //原来的类里有别人做了处理
        return sig;
    } else {
        IMP subClassIMP = [[self class] instanceMethodForSelector:@selector(methodSignatureForSelector:)];
        IMP NSObjectIMP = [NSObject instanceMethodForSelector:@selector(methodSignatureForSelector:)];
        if (subClassIMP != NSObjectIMP) {
            //子类有自己的 methodSignatureForSelector 实现
            return nil;
        } else {
            return [NSObject instanceMethodSignatureForSelector:@selector(init)];
        }
    }
}

- (void)_pyl_protect_forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"pyl_protect: send %s to %@", sel_getName(anInvocation.selector), anInvocation.target);
}

@end

@implementation NSArray (PYLProtect)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /*
         __NSArray0
         __NSSingleObjectArrayI
         __NSArrayI
         */
        Class __NSArray0 = object_getClass(@[]);
        Class __NSSingleObjectArrayI = object_getClass(@[@1]);
        Class __NSArrayI = object_getClass(@[@1,@2]);
        
        SEL oldSEL = @selector(objectAtIndex:);
        SEL newSEL = @selector(_pyl_protect_objectAtIndex:);
        [__NSArray0 swizzleInstanceOldMethod:oldSEL toNewMethod:newSEL];
        [__NSSingleObjectArrayI swizzleInstanceOldMethod:oldSEL toNewMethod:newSEL];
        [__NSArrayI swizzleInstanceOldMethod:oldSEL toNewMethod:newSEL];

        [__NSArrayI swizzleInstanceOldMethod:@selector(objectAtIndexedSubscript:) toNewMethod:@selector(_pyl_protect_objectAtIndexedSubscript:)];
    });
}

- (id)_pyl_protect_objectAtIndex:(NSUInteger)index {
    if (0 <= index && index < [self count]) {
        return [self _pyl_protect_objectAtIndex:index];
    } else {
        NSLog(@"pyl_protect: %@ beyond bounds idx:%lu", self, (unsigned long)index);
        return nil;
    }
}

- (id)_pyl_protect_objectAtIndexedSubscript:(NSUInteger)idx {
    if (0 <= idx && idx < [self count]) {
        return [self _pyl_protect_objectAtIndexedSubscript:idx];
    } else {
        NSLog(@"pyl_protect: %@ beyond bounds idx:%lu", self, (unsigned long)idx);
        return nil;
    }
}

@end

@implementation NSMutableArray (PYLProtect)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSArrayM = object_getClass(@[].mutableCopy);
        [__NSArrayM swizzleInstanceOldMethod:@selector(objectAtIndex:)
                                 toNewMethod:@selector(_pyl_protect_objectAtIndex:)];
        [__NSArrayM swizzleInstanceOldMethod:@selector(objectAtIndexedSubscript:)
                                 toNewMethod:@selector(_pyl_protect_objectAtIndexedSubscript:)];
    });
}

- (id)_pyl_protect_objectAtIndex:(NSUInteger)index {
    if (0 <= index && index < [self count]) {
        return [self _pyl_protect_objectAtIndex:index];
    } else {
        NSLog(@"pyl_protect: %@ beyond bounds idx:%lu", self, (unsigned long)index);
        return nil;
    }
}

- (id)_pyl_protect_objectAtIndexedSubscript:(NSUInteger)idx {
    if (0 <= idx && idx < [self count]) {
        return [self _pyl_protect_objectAtIndexedSubscript:idx];
    } else {
        NSLog(@"pyl_protect: %@ beyond bounds idx:%lu", self, (unsigned long)idx);
        return nil;
    }
}

@end
