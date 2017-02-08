//
//  SearchView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()
@property (nonatomic, retain) UIView *animateView;
@property (nonatomic) NSLayoutConstraint *view_CT;
@property (nonatomic) BOOL canAnimate;
@end

@implementation SearchView

-(void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.canAnimate = YES;
}

-(UIView *)animateView {
    if (!_animateView) {
        _animateView = [[UIView alloc]init];
        [self addSubview:_animateView];
        _animateView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_animateView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_animateView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        self.view_CT = [NSLayoutConstraint constraintWithItem:_animateView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self addConstraint:self.view_CT];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_animateView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }
    return _animateView;
}

-(void)doShowWithAnimate:(BOOL)animate {
    if (animate) {
        if (self.canAnimate && self.hidden) {
            self.canAnimate = NO;
            self.hidden = NO;
            __weak typeof(self) wself = self;
            self.view_CT.constant = -self.bounds.size.height;
            [UIView animateWithDuration:0.2 animations:^{
                wself.view_CT.constant = 0;
                [wself layoutIfNeeded];
            } completion:^(BOOL finished) {
                wself.canAnimate = YES;
            }];
        }
    }else {
        self.view_CT.constant = 0;
        self.hidden = NO;
    }
}

-(void)doHideWithAnimate:(BOOL)animate {
    if (animate) {
        if (self.canAnimate && !self.hidden) {
            self.canAnimate = NO;
            __weak typeof(self) wself = self;
            self.view_CT.constant = 0;
            [UIView animateWithDuration:0.2 animations:^{
                wself.view_CT.constant = -wself.bounds.size.height;
                [wself layoutIfNeeded];
            } completion:^(BOOL finished) {
                wself.hidden = YES;
                wself.canAnimate = YES;
            }];
        }
    }else {
        self.view_CT.constant = 0;
        self.hidden = YES;
    }
}
@end
