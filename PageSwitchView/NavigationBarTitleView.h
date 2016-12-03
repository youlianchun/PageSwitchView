//
//  NavigationBarTitleView.h
//  PageSwitchView
//
//  Created by YLCHUN on 2016/12/3.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBarTitleView : UIView
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIView *titleView;
@property (nonatomic, assign) CGFloat labelShowRatio;//默认1
@end
