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
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, retain) UIView *makeView;
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
        self.topView = fromViewController.view;
        self.topView.layer.shadowOpacity = 1;
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        [self showMakeViewIn:containerView];
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
            wself.makeView.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            wself.interactiveTransition = nil;
            wself.topView = nil;
        }];
    }else if (self.operation == UINavigationControllerOperationPush){
        self.topView = toViewController.view;
        self.topView.layer.shadowOpacity = 0;
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        toViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
        
        [self showMakeViewIn:containerView];
        self.makeView.alpha = 0;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toViewController.view.transform = CGAffineTransformIdentity;
            wself.topView.layer.shadowOpacity = 1;
            wself.makeView.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            wself.interactiveTransition = nil;
            wself.topView = nil;
        }];
    }
}

-(void)setTopView:(UIView *)topView {
    if (topView) {
        topView.layer.shadowOffset = CGSizeMake(2, 0);
        topView.layer.shadowRadius = 5;
        topView.layer.shadowColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
    }else{
        topView.layer.shadowOpacity = 0;
        [self.makeView removeFromSuperview];
    }
    _topView = topView;
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.topView.layer.shadowOpacity = shadowOpacity;
    self.makeView.alpha = shadowOpacity;
}

-(UIView *)makeView {
    if (!_makeView) {
        _makeView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _makeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    }
    return _makeView;
}

-(void)showMakeViewIn:(UIView*)view {
    [self.makeView removeFromSuperview];
    [view insertSubview:self.makeView atIndex:1];
}

//-(UIPercentDrivenInteractiveTransition *)interactiveTransition {
//    if (!_interactiveTransition) {
//        _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
//    }
//    return _interactiveTransition;
//}
@end
