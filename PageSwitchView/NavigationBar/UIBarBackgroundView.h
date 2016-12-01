//
//  UIBarBackgroundView.h
//  NavigationController
//
//  Created by YLCHUN on 16/10/27.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarBackgroundView : UIView

//@property (nonatomic) BOOL              translucence;
@property (nonatomic) UIImage                *backgroundImage;
@property (nonatomic) UIColor                *backgroundTintColor;
//@property (nonatomic) id                     backgroundEffect;
//@property (nonatomic) UIImage                *shadowImage;
@property (nonatomic) UIColor                *shadowColor;
@property (nonatomic) CGFloat                shadowHeight;
//@property (nonatomic) int                    shadowPosition;
@property (nonatomic, readonly) UIImageView            *backgroundImageView;
//@property (nonatomic, readonly) UIView                 *backgroundTopInsetView;
@property (nonatomic, readonly) UIView                 *shadowView;
@property (nonatomic, readonly) UIVisualEffectView     *backgroundEffectView;
@property (nonatomic) BOOL backgroundEffectViewHiden;
//@property (nonatomic) BOOL                   disableTinting;
//@property (nonatomic, readonly) UIView                 *customBackgroundView;
//@property (nonatomic) CGFloat                topInset;
//@property (nonatomic, readonly) UIView                 *backgroundView;
@end
