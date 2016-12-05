//
//  UINavigationBar+Background.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/2.
//  Copyright © 2016年 ylchun. All rights reserved.
//
#define Background_enabled 0

#if Background_enabled
#import <UIKit/UIKit.h>

@interface UINavigationBar (Background)
@property (nonatomic, readonly) UIView *shadowView;
@property (nonatomic, retain)   UIImage *backgroundImage;
@property (nonatomic, readonly) UIImageView *backImageView;
@end
#endif
