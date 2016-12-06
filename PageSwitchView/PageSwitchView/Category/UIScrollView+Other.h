//
//  UIScrollView+Other.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/6.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Other)

@property (nonatomic, weak) UIScrollView *otherScrollView;
@property (nonatomic, readonly) BOOL isDescendantOfOtherScrollView;
@property (nonatomic, readonly) BOOL isAncestorOfOtherScrollView;

@end
