//
//  NavigationController.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/2.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "NavigationController.h"
#import "UINavigationBar+Background.h"
#import "UINavigationControllerTransition.h"

@interface UIPopGestureRecognizer :UIScreenEdgePanGestureRecognizer
@end
@implementation UIPopGestureRecognizer
-(instancetype)init {
    self = [super init];
    if (self) {
        self.edges = UIRectEdgeLeft;
    }
    return self;
}
@end

@interface NavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic) UIPopGestureRecognizer *popGestureRecognizer;
@property (nonatomic) UINavigationControllerTransition *popTransition;
@property (nonatomic) UINavigationControllerTransition *pushTransition;

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self popGestureRecognizer];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    self.navigationBar.backImageView.hidden = !(self.viewControllers.count>1);
}

-(UIPopGestureRecognizer *)popGestureRecognizer {
    if (!_popGestureRecognizer) {
        _popGestureRecognizer = [[UIPopGestureRecognizer alloc] init];
//        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
//        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
//        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
//        [_popGestureRecognizer addTarget:internalTarget action:internalAction];
        [_popGestureRecognizer addTarget:self action:@selector(handleNavigationTransition:)];
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:_popGestureRecognizer];
        _popGestureRecognizer.delegate = self;
        
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return _popGestureRecognizer;
}
/**
 *  我们把用户的每次Pan手势操作作为一次pop动画的执行
 */
- (void)handleNavigationTransition:(UIPanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer locationInView:recognizer.view].x / recognizer.view.bounds.size.width;
    progress = MIN(1.0, MAX(0.0, progress));
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.popTransition.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self popViewControllerAnimated:YES];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.popTransition.interactiveTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if (progress > 0.5) {
            [self.popTransition.interactiveTransition finishInteractiveTransition];
        } else {
            [self.popTransition.interactiveTransition cancelInteractiveTransition];
        }
        self.popTransition.interactiveTransition = nil;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return self.pushTransition;
    }
    if (operation == UINavigationControllerOperationPop) {
        return self.popTransition;
    }
    return nil;
}
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[UINavigationControllerTransition class]]) {
        UINavigationControllerTransition *transition = (UINavigationControllerTransition*)animationController;
        return transition.interactiveTransition;
    }
    return nil;
}

-(UINavigationControllerTransition *)pushTransition {
    if (!_pushTransition) {
        _pushTransition = [[UINavigationControllerTransition alloc] initWithOperation:UINavigationControllerOperationPush];
    }
    return _pushTransition;
}

-(UINavigationControllerTransition *)popTransition {
    if (!_popTransition) {
        _popTransition = [[UINavigationControllerTransition alloc] initWithOperation:UINavigationControllerOperationPop];
    }
    return _popTransition;
}
@end
