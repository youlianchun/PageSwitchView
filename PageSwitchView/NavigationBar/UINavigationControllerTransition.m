//
//  SecondTransition.m
//  TransitionDemo
//
//  Created by JackXu on 16/7/10.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import "UINavigationControllerTransition.h"

@interface UINavigationControllerTransition()
@property (nonatomic, assign) UINavigationControllerOperation operation;
@end

@implementation UINavigationControllerTransition

-(instancetype)initWithOperation:(UINavigationControllerOperation)operation {
    self = [super init];
    if (self) {
        self.operation = operation;
    }
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    __weak typeof(self) wself = self;
    if (self.operation == UINavigationControllerOperationPop) {
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            wself.interactiveTransition = nil;
        }];
    }else if (self.operation == UINavigationControllerOperationPush){
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        toViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            wself.interactiveTransition = nil;
        }];
    }
}
//-(UIPercentDrivenInteractiveTransition *)interactiveTransition {
//    if (!_interactiveTransition) {
//        _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
//    }
//    return _interactiveTransition;
//}
@end
