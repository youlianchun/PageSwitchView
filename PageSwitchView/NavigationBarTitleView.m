//
//  NavigationBarTitleView.m
//  PageSwitchView
//
//  Created by YLCHUN on 2016/12/3.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "NavigationBarTitleView.h"

@interface NavigationBarTitleView ()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *titleView;
@end

@implementation NavigationBarTitleView
//-(instancetype)init {
//    
//}
//-(void)didMoveToSuperview {
//    [super didMoveToSuperview];
//    self.center = CGPointMake(self.superview.center.x, self.center.y);
//}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.alpha = 1;
        [self addSubview:_titleLabel];
        [self addConstraint:_titleLabel inserts:UIEdgeInsetsMake(0, 0, 0, 0)];

    }
    return _titleLabel;
}
-(UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.alpha = 0;
        [self addSubview:_titleView];
        [self addConstraint:_titleView inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return _titleView;
}

-(void)setLabelShowRatio:(CGFloat)labelShowRatio {
    CGFloat ratio = MIN(1.0, MAX(0.0, labelShowRatio));
    self.titleLabel.alpha = ratio;
    self.titleView.alpha = 1-ratio;
}

-(void)addConstraint:(UIView*)view inserts:(UIEdgeInsets)inserts {
    UIView *superview = view.superview;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1 constant:inserts.left]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1 constant:inserts.right]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:inserts.top]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1 constant:inserts.bottom]];
}

@end
