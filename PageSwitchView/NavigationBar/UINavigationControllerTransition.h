//
//  SecondTransition.h
//  TransitionDemo
//
//  Created by JackXu on 16/7/10.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationControllerTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic) CGFloat shadowOpacity;
-(instancetype)initWithOperation:(UINavigationControllerOperation)operation;
@end
