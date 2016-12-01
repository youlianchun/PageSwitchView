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
@property (nonatomic) UIView                 *shadowView;
@end

@implementation UIBarBackgroundView

-(instancetype)init {
    self = [super init];
    if (self) {
        if ([UINavigationBar appearance].translucent) {
            [self backgroundEffectView];
        }
        [self backgroundImageView];
        [self shadowView];
    }
    return self;
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
        [self insertSubview:_backgroundImageView atIndex:0];
        [self addConstraint:_backgroundImageView inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return _backgroundImageView;
}

-(UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc]init];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:_shadowView];
        _shadowView.translatesAutoresizingMaskIntoConstraints = false;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_shadowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_shadowView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [_shadowView addConstraint:[NSLayoutConstraint constraintWithItem:_shadowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.5]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:_shadowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView.layer.shadowRadius = 1;
        _shadowView.layer.shadowOpacity = 10;
        _shadowView.layer.shadowColor = _shadowView.backgroundColor.CGColor;
    }
    return _shadowView;
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
}
-(UIImage *)backgroundImage {
    return self.backgroundImageView.image;
}

-(BOOL)translucence {
    return self.backgroundEffectView.effect;
}
-(void)setTranslucence:(BOOL)translucence {
    self.backgroundEffectView.hidden = translucence;
}

-(void)addConstraint:(UIView*)view inserts:(UIEdgeInsets)inserts {
    UIView *superview = view.superview;
    view.translatesAutoresizingMaskIntoConstraints = false;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1 constant:inserts.left]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1 constant:inserts.right]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:inserts.top]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1 constant:inserts.bottom]];
}


@end


@interface UINavigationBar (Bar)<UINavigationControllerDelegate>

@property (nonatomic) UIBarBackgroundView *barBackgroundView;
@property (nonatomic) UIViewController    *selfViewController;
@property (nonatomic) UIImageView         *backImageView;

@end

@implementation UINavigationBar(Bar)
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(didMoveToSuperview);
        SEL swizzledSelector = @selector(_didMoveToSuperview);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
-(void)_didMoveToSuperview {
    [self _didMoveToSuperview];
    [self barBackgroundView];
    [self backImageView];
    if (self.selfViewController) {
        [self setDelegate];
    }else {
        [self performSelector:@selector(setDelegate) withObject:nil afterDelay:0.0001];
    }
}
-(void)setDelegate {
    UIViewController *vc = self.selfViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nvc = (UINavigationController *)vc;
        nvc.delegate = self;
        self.backImageView.hidden = !(nvc.viewControllers.count>1);
    }else if ([vc isKindOfClass:[UIViewController class]]) {
        UINavigationController *nvc = vc.navigationController;
        if (nvc) {
            nvc.delegate = self;
            self.backImageView.hidden = !(nvc.viewControllers.count>1);
        }
    }
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.backImageView.hidden = !(navigationController.viewControllers.count>1);
}

-(UIBarBackgroundView *)barBackgroundView {
    UIBarBackgroundView *_barBackgroundView = objc_getAssociatedObject(self, _cmd);
    if (!_barBackgroundView) {
        for (UIView* view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                _barBackgroundView = [[UIBarBackgroundView alloc]init];
                [view insertSubview:_barBackgroundView atIndex:0];
                _barBackgroundView.translatesAutoresizingMaskIntoConstraints = false;
                [self addConstraint:[NSLayoutConstraint constraintWithItem:_barBackgroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                [self addConstraint:[NSLayoutConstraint constraintWithItem:_barBackgroundView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                [self addConstraint: [NSLayoutConstraint constraintWithItem:_barBackgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-20]];
                [self addConstraint: [NSLayoutConstraint constraintWithItem:_barBackgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                break;
            }
        }
        _barBackgroundView.backgroundColor = [UIColor clearColor];
        [self setBarBackgroundView:_barBackgroundView];
    }
    return _barBackgroundView;
}

-(void)setBarBackgroundView:(UIBarBackgroundView *)barBackgroundView {
    objc_setAssociatedObject(self, @selector(barBackgroundView), barBackgroundView, OBJC_ASSOCIATION_RETAIN);
}

-(UIViewController *)selfViewController{
    UIViewController *_selfViewController = objc_getAssociatedObject(self, _cmd);
    if (!_selfViewController) {
        UIResponder *responder = self;
        while (responder) {
            if ([responder isKindOfClass: [UIViewController class]]) {
                _selfViewController =  (UIViewController *)responder;
                [self setSelfViewController:_selfViewController];
                break;
            }
            responder = [responder nextResponder];
        }
    }
    return _selfViewController;
}

-(void)setSelfViewController:(UIViewController *)selfViewController {
    objc_setAssociatedObject(self, @selector(selfViewController), selfViewController, OBJC_ASSOCIATION_RETAIN);
}

-(UIImageView *)backImageView {
    UIImageView *_backImageView = objc_getAssociatedObject(self, _cmd);
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 11.6667, 13, 21)];
        [self addSubview:_backImageView];
        CAShapeLayer *lineLayer = [[CAShapeLayer alloc]init];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, 12, 1);
        CGPathAddLineToPoint(path, nil, 2.5, 10.5);
        CGPathAddLineToPoint(path, nil, 12, 20);
        lineLayer.path = path;
        lineLayer.lineWidth=3.1;
        CGPathRelease(path);
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        UIColor *tintColor = [UINavigationBar appearance].tintColor;
        if (!tintColor) {
            tintColor = [UINavigationBar appearance].tintColor;
        }
        lineLayer.strokeColor = tintColor.CGColor;
        [_backImageView.layer addSublayer:lineLayer];
        _backImageView.hidden = true;
        [self setBackImageView:_backImageView];
    }
    return _backImageView;
}
-(void)setBackImageView:(UIImageView *)backImageView {
    objc_setAssociatedObject(self, @selector(backImageView), backImageView, OBJC_ASSOCIATION_RETAIN);
}

@end



