//
//  UIScrollView+GestureRecognizer.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/2.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "UIScrollView+GestureRecognizer.h"
#import <objc/runtime.h>

BOOL gestureRecognizer(UIScrollView *self, SEL _cmd, UIGestureRecognizer *gestureRecognizer, UIGestureRecognizer *otherGestureRecognizer){
    if (_cmd == @selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:)) {
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
                [self setContentOffset:contentOffset animated:true];
                return YES;
            }
            return YES;
        }
        return NO;
    }
    if (_cmd == @selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPopGestureRecognizer")]) {
            return YES;
        }
        return NO;
    }
    return true;
}

static inline BOOL addClassMethod(Class class, SEL selector, IMP imp, const char *types) {
    BOOL success = [class resolveInstanceMethod:selector];
    if (!success) {
        success = class_addMethod(class, selector, imp, types);
    }
    return success;
}

//static inline BOOL swizzleNewClassMethod(Class class, SEL originalSelector, IMP imp, const char *types, SEL swizzledSelector) {
//    BOOL success = addClassMethod(class, originalSelector, imp, types);
//    if (success) {
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        
//         success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//        if (success) {
//            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    }
//    return success;
//}



@implementation UIScrollView (GestureRecognizer)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL selector;
        IMP imp = (IMP)gestureRecognizer;
        const char *types = "B@:@:@";
//        SEL swizzledSelector;
        
        selector = NSSelectorFromString(@"gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:");
        addClassMethod(class, selector, imp, types);
//        swizzledSelector = @selector(gr_gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);
//        swizzleNewClassMethod(class, selector, imp, types, swizzledSelector);
        
        selector = NSSelectorFromString(@"gestureRecognizer:shouldRequireFailureOfGestureRecognizer:");
        addClassMethod(class, selector, imp, types);
//        swizzledSelector = @selector(gr_gestureRecognizer:shouldRequireFailureOfGestureRecognizer:);
//        swizzleNewClassMethod(class, selector, imp, types, swizzledSelector);
    });
}


//- (BOOL)gr_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return [self gr_gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
//}
//
//- (BOOL)gr_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return [self gr_gestureRecognizer:gestureRecognizer shouldRequireFailureOfGestureRecognizer:otherGestureRecognizer];
//}

@end
