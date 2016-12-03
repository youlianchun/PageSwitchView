//
//  UIScrollView+GestureRecognizer.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/2.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "UIScrollView+GestureRecognizer.h"
#import <objc/runtime.h>

@implementation UIScrollView (GestureRecognizer)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL selector;
        const char *types = "B@:@:@";
        
        selector = @selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);
        class_addMethod(class, selector, class_getMethodImplementation(self, selector), types);
        
        selector = @selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:);
        class_addMethod(class, selector, class_getMethodImplementation(self, selector), types);
        
    });
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPopGestureRecognizer")]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPopGestureRecognizer")]) {
        CGPoint p = [otherGestureRecognizer locationInView:otherGestureRecognizer.view];
        if (p.x <= 40 ) {
            UIEdgeInsets contentInset = self.contentInset;
            CGPoint contentOffset = self.contentOffset;
            CGSize contentSize = self.contentSize;
            CGSize size = self.bounds.size;
            CGFloat x2 = contentSize.width-size.width+contentInset.right;
            if (contentOffset.x > x2) {
                contentOffset.x = x2;
            }
            CGFloat y2 = contentSize.height-size.height+contentInset.bottom;
            if (contentOffset.y > y2) {
                contentOffset.y = y2;
            }
            CGFloat x1 = 0-contentInset.left;
            if (contentOffset.x < x1) {
                contentOffset.x = x1;
            }
            CGFloat y1 = 0-contentInset.top;
            if (contentOffset.y < y1) {
                contentOffset.y = y1;
            }
            [self setContentOffset:contentOffset animated:YES];
            return YES;
        }
        return YES;
    }
    return NO;
}
@end
