//
//  PageSwitchViewStatic.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/6.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kUIGestureRecognizer_V = @"kUIGestureRecognizer_V";
static NSString *kUIGestureRecognizer_H = @"kUIGestureRecognizer_H";
static const NSInteger kNull_PageIndex = 999999999;

static const CGFloat defauleBackgroungColor = 0.9;

typedef NS_ENUM(NSInteger, SegmentSelectedStyle) {
    SegmentSelectedStyleNone = 0,
    SegmentSelectedStyleBackground,
    SegmentSelectedStyleUnderline,
    SegmentSelectedStyleSubscript
};
