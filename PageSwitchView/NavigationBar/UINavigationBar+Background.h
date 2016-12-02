//
//  UINavigationBar+Background.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/2.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UINavigationBar (Background)
@property (nonatomic, readonly) UIView* shadowView;
@property (nonatomic) UIImage   *backgroundImage;
@property (nonatomic,readonly) UIImageView *backImageView;
@end
