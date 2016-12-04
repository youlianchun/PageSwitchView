//
//  UINavigationBar+Background.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/2.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "UINavigationBar+Background.h"
#import <objc/runtime.h>
#import "UIBarBackgroundView.h"

@interface UINavigationBar()

@property (nonatomic) UIBarBackgroundView *barBackgroundView;
@property (nonatomic) UIImageView *backImageView;
@end

@implementation UINavigationBar (Background)
+ (void)load
{
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
        originalSelector = @selector(setTranslucent:);
        swizzledSelector = @selector(_setTranslucent:);
        
        originalMethod = class_getInstanceMethod(class, originalSelector);
        swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

-(void)_didMoveToSuperview {
    [self _didMoveToSuperview];
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            for (UIView *v in view.subviews) {
                v.alpha = 0;
            }
            [view addSubview:self.barBackgroundView];
            break;
        }
    }
}

-(void)_setTranslucent:(BOOL)translucent {
    [self _setTranslucent:translucent];
    self.barBackgroundView.translucent = translucent;
}

-(UIBarBackgroundView *)barBackgroundView {
    UIBarBackgroundView *_barBackgroundView = objc_getAssociatedObject(self, @selector(barBackgroundView));
    if (!_barBackgroundView) {
        _barBackgroundView = [[UIBarBackgroundView alloc]init];
        _barBackgroundView.backgroundColor = [UIColor clearColor];
        self.barBackgroundView = _barBackgroundView;
    }
   return  _barBackgroundView;
}

-(void)setBarBackgroundView:(UIBarBackgroundView *)barBackgroundView {
    objc_setAssociatedObject(self, @selector(barBackgroundView), barBackgroundView, OBJC_ASSOCIATION_RETAIN);
}

-(UIView *)shadowView {
    return self.barBackgroundView.shadowView;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage {
    self.barBackgroundView.backgroundImage = backgroundImage;
}

-(UIImage *)backgroundImage {
    return self.barBackgroundView.backgroundImage;
}

-(UIImageView *)backImageView {
    UIImageView *_backImageView = objc_getAssociatedObject(self, @selector(backImageView));
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 11.6667, 13, 21)];
        _backImageView.userInteractionEnabled = false;
        [self addSubview:_backImageView];
        CAShapeLayer *lineLayer = [[CAShapeLayer alloc]init];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, 12, 1);
        CGPathAddLineToPoint(path, nil, 2.5, 10.5);
        CGPathAddLineToPoint(path, nil, 12, 20);
        lineLayer.path = path;
        lineLayer.lineWidth = 3.1;
        CGPathRelease(path);
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        UIColor *tintColor = [UINavigationBar appearance].tintColor;
        if (!tintColor) {
            tintColor = self.tintColor;
        }
        lineLayer.strokeColor = tintColor.CGColor;
        [_backImageView.layer addSublayer:lineLayer];
        _backImageView.hidden = YES;
        self.backImageView = _backImageView;
    }
    return _backImageView;
}

-(void)setBackImageView:(UIImageView *)backImageView {
    objc_setAssociatedObject(self, @selector(backImageView), backImageView, OBJC_ASSOCIATION_RETAIN);
}

@end
