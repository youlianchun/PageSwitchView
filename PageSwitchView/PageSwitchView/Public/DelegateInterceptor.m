//
//  DelegateInterceptor.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "DelegateInterceptor.h"

@implementation DelegateInterceptor
- (id) forwardingTargetForSelector:(SEL)aSelector {
    if (self.middleMan && [self.middleMan respondsToSelector:aSelector]) {
        return self.middleMan;
    }
    if (self.receiver && [self.receiver respondsToSelector:aSelector]) {
        return self.receiver;
    }
    return	[super forwardingTargetForSelector:aSelector];
}

- (BOOL) respondsToSelector:(SEL)aSelector {
    NSString *aSelectorName = NSStringFromSelector(aSelector);
    if (![aSelectorName hasPrefix:@"keyboardInput"] ) {//键盘输入代理过滤
        if (self.middleMan && [self.middleMan respondsToSelector:aSelector]) {
            return YES;
        }
        if (self.receiver && [self.receiver respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return [super respondsToSelector:aSelector];
}

-(id)mySelf {
    return self;
}

@end
