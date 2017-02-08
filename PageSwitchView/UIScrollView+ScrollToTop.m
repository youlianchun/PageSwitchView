//
//  UIScrollView+ScrollTop.m
//  RefreshDataArray
//
//  Created by YLCHUN on 2017/1/20.
//  Copyright © 2017年 YLCHUN. All rights reserved.
//

#import "UIScrollView+ScrollToTop.h"
#import<libkern/OSAtomic.h>
#import <objc/runtime.h>

@interface UIScrollView ()
@property (nonatomic,assign) BOOL disabled;//是否禁止默认NO
@property (nonatomic, retain) NSLock *lock;
@end

@implementation UIScrollView (ScrollToTop)

-(void)scrollToTopWithTime:(double)time animatie:(BOOL)animate completion:(void(^)())completion {
    __weak UIScrollView *scrollView = self;
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    scrollView.disabled = YES;
    scrollView.userInteractionEnabled = NO;
    [scrollView.lock lock];
    void(^_completion)() = ^{
        scrollView.disabled = NO;
        scrollView.userInteractionEnabled = YES;
        [scrollView.lock unlock];
        if (completion) {
            completion();
        }
    };
    if (scrollView.contentOffset.y>0) {
        if (animate && time > 0) {
            double count = 1000;
            double interval =  time/count;
            __block CGFloat y = scrollView.contentOffset.y;
            CGFloat offset_y = y / count;
            
//            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, DISPATCH_TARGET_QUEUE_DEFAULT);
            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
            dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0);
            __block int32_t timeOutCount = count;
            dispatch_source_set_event_handler(timer, ^{
                OSAtomicDecrement32(&timeOutCount);
                y = y - offset_y;
                if (y > 0) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
                        [scrollView setContentOffset:CGPointMake(0, y)];
//                    });
                }else{
                    timeOutCount = 0;
                    [scrollView setContentOffset:CGPointMake(0, 0)];
                }
                if (timeOutCount == 0) {
                    dispatch_source_cancel(timer);
                    _completion();
                }
            });
            dispatch_source_set_cancel_handler(timer, ^{
            });
            dispatch_resume(timer);
            

        }else{
            [scrollView setContentOffset:CGPointZero];
            _completion();
        }
    }else{
        _completion();
    }
}

-(void)scrollToTopWithAnimatie:(BOOL)animate completion:(void(^)())completion {
    [self scrollToTopWithTime:0.2 animatie:animate completion:completion];
}

-(BOOL)disabled {
    return [objc_getAssociatedObject(self, @selector(disabled)) boolValue];
}

-(void)setDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, @selector(disabled), @(disabled), OBJC_ASSOCIATION_RETAIN);
}

-(NSLock *)lock {
    return objc_getAssociatedObject(self, @selector(lock));
}


-(void)setLock:(NSLock *)lock {
    objc_setAssociatedObject(self, @selector(lock), lock, OBJC_ASSOCIATION_RETAIN);
}
@end
