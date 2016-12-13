//
//  SearchView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()
@property (nonatomic, retain) UIView *view;
@property (nonatomic) NSLayoutConstraint *view_CT;
@property (nonatomic) BOOL canAnimate;
@end

@implementation SearchView

-(void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.canAnimate = YES;
}

-(UIView *)view {
    if (!_view) {
        _view = [[UIView alloc]init];
        [self addSubview:_view];
        _view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        self.view_CT = [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self addConstraint:self.view_CT];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }
    return _view;
}

-(void)doShow {
    if (self.canAnimate && self.hidden) {
        self.canAnimate = NO;
        self.hidden = NO;
        __weak typeof(self) wself = self;
        [UIView animateWithDuration:0.2 animations:^{
            wself.view_CT.constant = 0;
            [wself layoutIfNeeded];
        }completion:^(BOOL finished) {
            wself.canAnimate = YES;
        }];
    }
}

-(void)doHide {
    if (self.canAnimate && !self.hidden) {
        self.canAnimate = NO;
        __weak typeof(self) wself = self;
        [UIView animateWithDuration:0.2 animations:^{
            wself.view_CT.constant = -wself.bounds.size.height;
            [wself layoutIfNeeded];
        } completion:^(BOOL finished) {
            wself.hidden = YES;
            wself.canAnimate = YES;
        }];
    }
}

@end
