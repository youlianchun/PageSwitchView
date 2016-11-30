//
//  TwoScrollView.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/21.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "TwoScrollView.h"
#import "_TwoScrollView.h"
#import "DelegateInterceptor.h"
#import "UIGestureRecognizer+Group.h"
@interface TwoScrollView ()
@property (nonatomic) UIScrollView *scrollView_l;
@property (nonatomic) UIScrollView *scrollView_r;

@property (nonatomic) DelegateInterceptor *dI_l;
@property (nonatomic) DelegateInterceptor *dI_r;


@end

@implementation TwoScrollView

-(instancetype)initWithFrame:(CGRect)frame scrollView_l:(UIScrollView*)scrollView_l scrollView_r:(UIScrollView*)scrollView_r {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView_l = scrollView_l;
        self.scrollView_r = scrollView_r;
        [self initialize];
        [self lauout];
    }
    return self;
}

-(void)initialize {
    [self addSubview:self.scrollView_l];
    [self addSubview:self.scrollView_r];
    self.scrollView_l.panGestureRecognizer.groupTag = self.panGestureRecognizerGroupTag;
    self.scrollView_r.panGestureRecognizer.groupTag = self.panGestureRecognizerGroupTag;

    self.dI_l = [[DelegateInterceptor alloc]init];
    self.dI_l.middleMan = self;
    self.dI_l.receiver = self.scrollView_l.delegate;
    if (self.scrollView_l.delegate) {
        self.scrollView_l.delegate = (typeof(self.scrollView_l.delegate))self.dI_l;
    }else{
        self.scrollView_l.delegate = (id<UIScrollViewDelegate>)self.dI_l;
    }
    
    self.dI_r = [[DelegateInterceptor alloc]init];
    self.dI_r.middleMan = self;
    self.dI_r.receiver = self.scrollView_r.delegate;
    if (self.scrollView_r.delegate) {
        self.scrollView_r.delegate =  (typeof(self.scrollView_r.delegate))self.dI_r;
    }else{
        self.scrollView_r.delegate = (id<UIScrollViewDelegate>)self.dI_r;
    }
}
-(void)setPanGestureRecognizerGroupTag:(NSString *)panGestureRecognizerGroupTag {
    _panGestureRecognizerGroupTag = panGestureRecognizerGroupTag;
    self.scrollView_l.panGestureRecognizer.groupTag = panGestureRecognizerGroupTag;
    self.scrollView_r.panGestureRecognizer.groupTag = panGestureRecognizerGroupTag;
}

-(void)lauout{
    
    self.scrollView_l.translatesAutoresizingMaskIntoConstraints = false;
    self.scrollView_r.translatesAutoresizingMaskIntoConstraints = false;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView_l attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView_l attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView_r attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView_l attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView_l attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView_r attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView_l attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView_r attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView_r attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView_r attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView_r attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView_l attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView_l) {
        if ([self.dI_l.receiver respondsToSelector:_cmd]) {
            [self.dI_l.receiver scrollViewDidScroll:scrollView];
        }
        if (scrollView.contentOffset.y <= 0 && self.haveHeader) {
            [self.scrollView_r setContentOffset:scrollView.contentOffset animated:false];
        }
    }
    
    if (scrollView == self.scrollView_r) {
        if ([self.dI_r.receiver respondsToSelector:_cmd]) {
            [self.dI_r.receiver scrollViewDidScroll:scrollView];
        }
        if (scrollView.contentOffset.y <= 0 && self.haveHeader) {
            [self.scrollView_l setContentOffset:scrollView.contentOffset animated:false];
        }
    }
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

@end
