//
//  TwoScrollView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/21.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoScrollView : UIView
@property (nonatomic, readonly) UIScrollView *scrollView_l;
@property (nonatomic, readonly) UIScrollView *scrollView_r;

@property (nonatomic, copy) NSString* panGestureRecognizerGroupTag;

@property(nonatomic,weak) id<UIScrollViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame scrollView_l:(UIScrollView*)scrollView_l scrollView_r:(UIScrollView*)scrollView_r;

@end
