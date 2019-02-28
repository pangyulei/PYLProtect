//
//  main.m
//  PYLProtect
//
//  Created by yulei pang on 2019/2/28.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <objc/runtime.h>
#import "Boy.h"

void p(id obj) {
    Class cls = object_getClass(obj);
    printf("%s\n", class_getName(cls));
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //验证子类的 swizzle 父类中的方法不会影响父类
        [[Boy new] m1];
        [[Boy new] m2];
        [[Person new] m1];
        [[Person new] m2];
        
//        [[Person new] performSelector:NSSelectorFromString(@"callJohn:")];
//        p(@[].mutableCopy);
//        p(@[@1].mutableCopy);
//        p(@[@1,@2].mutableCopy);
//        p([NSMutableArray array]);
//        p([NSMutableArray arrayWithObject:@1]);
//
//        [@[].mutableCopy objectAtIndex:0];
//        [@[] mutableCopy][0];
//
//        [@[@1].mutableCopy objectAtIndex:1];
//        [@[@1] mutableCopy][1];
//
//        [@[@1,@2] objectAtIndex:2];
//        [@[@1,@2] mutableCopy][2];
    }
    return 0;
}
