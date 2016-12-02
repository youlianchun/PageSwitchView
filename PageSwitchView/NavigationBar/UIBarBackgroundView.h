//
//  UIBarBackgroundView.h
//  NavigationController
//
//  Created by YLCHUN on 16/10/27.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarBackgroundView : UIView

@property (nonatomic) BOOL                    translucent;
@property (nonatomic) UIImage                *backgroundImage;
@property (nonatomic) UIColor                *shadowColor;
@property (nonatomic) CGFloat                shadowHeight;
@property (nonatomic, readonly) UIImageView            *backgroundImageView;
@property (nonatomic, readonly) UIView                 *shadowView;
@property (nonatomic, readonly) UIVisualEffectView     *backgroundEffectView;

@end

