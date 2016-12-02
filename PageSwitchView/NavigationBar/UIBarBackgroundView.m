//
//  UIBarBackgroundView.m
//  NavigationController
//
//  Created by YLCHUN on 16/10/27.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "UIBarBackgroundView.h"
#import <objc/runtime.h>

@interface  UIBarBackgroundView()
@property (nonatomic) UIVisualEffectView     *backgroundEffectView;
@property (nonatomic) UIImageView            *backgroundImageView;
@property (nonatomic) UIView                 *shadowView_t;
@property (nonatomic) UIView                 *shadowView_b;

@end

@implementation UIBarBackgroundView

-(void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self addConstraint:self inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self backgroundEffectView];
    [self shadowView];
}

-(UIVisualEffectView *)backgroundEffectView {
    if (!_backgroundEffectView) {
        _backgroundEffectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        [self addSubview:_backgroundEffectView];
        [self addConstraint:_backgroundEffectView inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return _backgroundEffectView;
}

-(UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.hidden = YES;
        [self insertSubview:_backgroundImageView atIndex:0];
        [self addConstraint:_backgroundImageView inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return _backgroundImageView;
}

-(UIView *)shadowView {
    UIView *shadowView;
    if ([self.superview isKindOfClass:[UINavigationBar class]] || [self.superview.superview isKindOfClass:[UINavigationBar class]]) {
        shadowView = self.shadowView_t;
    }
    if ([self.superview isKindOfClass:[UITabBar class]] || [self.superview.superview isKindOfClass:[UITabBar class]]) {
        shadowView = self.shadowView_b;
    }
    if (shadowView) {
        shadowView.hidden = NO;
    }
    return shadowView;
}

-(UIView *)shadowView_t {
    if (!_shadowView_t) {
        _shadowView_t = [[UIView alloc]init];
        _shadowView_t.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        _shadowView_t.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView_t.layer.shadowRadius = 1;
        _shadowView_t.layer.shadowOpacity = 10;
        _shadowView_t.layer.shadowColor = _shadowView_t.backgroundColor.CGColor;
        [self addSubview:_shadowView_t];
        
        _shadowView_t.hidden = NO;
        _shadowView_t.translatesAutoresizingMaskIntoConstraints = false;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_shadowView_t attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_shadowView_t attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [_shadowView_t addConstraint:[NSLayoutConstraint constraintWithItem:_shadowView_t attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.5]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_shadowView_t attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return _shadowView_t;
}

-(UIView *)shadowView_b {
    if (!_shadowView_b) {
        _shadowView_b = [[UIView alloc]init];
        _shadowView_b.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        _shadowView_b.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView_b.layer.shadowRadius = 1;
        _shadowView_b.layer.shadowOpacity = 10;
        _shadowView_b.layer.shadowColor = _shadowView_b.backgroundColor.CGColor;
        [self addSubview:_shadowView_b];
        
        _shadowView_b.hidden = NO;
        _shadowView_b.translatesAutoresizingMaskIntoConstraints = false;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_shadowView_b attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_shadowView_b attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [_shadowView_b addConstraint:[NSLayoutConstraint constraintWithItem:_shadowView_b attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.5]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_shadowView_b attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return _shadowView_b;
}


-(void)setShadowColor:(UIColor *)shadowColor {
    self.shadowView.layer.shadowColor = shadowColor.CGColor;
}

-(UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.shadowView.layer.shadowColor];
}

-(CGFloat)shadowHeight {
    return self.shadowView.layer.shadowRadius;
}

-(void)setShadowHeight:(CGFloat)shadowHeight {
    self.shadowView.layer.shadowRadius = shadowHeight;
}
-(void)setBackgroundImage:(UIImage *)backgroundImage {
    self.backgroundImageView.image = backgroundImage;
    self.backgroundImageView.hidden = !backgroundImage;
}
-(UIImage *)backgroundImage {
    return self.backgroundImageView.image;
}

-(BOOL)translucent {
    return !self.backgroundEffectView.hidden;
}

-(void)setTranslucent:(BOOL)translucent {
    self.backgroundEffectView.hidden = !translucent;
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
