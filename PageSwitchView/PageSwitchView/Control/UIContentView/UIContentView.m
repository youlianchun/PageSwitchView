//
//  UIContentView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/11/30.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "UIContentView.h"

#pragma mark -
#pragma mark - _UIContentView
@interface _UIContentView : UIView
@end
@implementation _UIContentView
@end

#pragma mark -
#pragma mark - UIContentView
@interface UIContentView ()
{
    UIView* _content;
}
@property (nonatomic, retain) UIView *contentView;
@end

@implementation UIContentView

-(void)dealloc {
    [self clearSubviews];
}

-(void)setContent:(UIView*)content {
    [self clearSubviews];
    [self addSubview:content];
    _content = content;
}

-(id)content {
    return _content;
}

-(NSArray<UIView *> *)subviews {
    return self.contentView.subviews;
}

-(void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

-(void)addSubview:(UIView *)view {
    [self.contentView addSubview:view];
}

-(void)clearSubviews {
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    _content = nil;
}

-(UIView *)contentView {
    if (!_contentView) {
        _contentView = [[_UIContentView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.frame = self.bounds;
        _contentView.opaque = NO;
        [super addSubview:_contentView];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return _contentView;
}

@end
