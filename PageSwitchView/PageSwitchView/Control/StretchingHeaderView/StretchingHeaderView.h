//
//  StretchingHeaderView.h
//  PageSwitchView
//
//  Created by YLCHUN on 2016/10/6.
//  Copyright © 2016年 ylchun. All rights reserved.
//  

#import <UIKit/UIKit.h>
@class StretchingHeaderView;
@protocol StretchingHeaderViewDelegate<NSObject>
@optional
-(void)stretchingHeaderView:(StretchingHeaderView*)stretchingHeaderView displayProgress:(CGFloat)progress;
@end
@interface StretchingHeaderView : UIView
@property (nonatomic, weak) id<StretchingHeaderViewDelegate> delegate;
-(instancetype)initWithContentView:(UIView*)contentView stretching:(BOOL)stretching;
@end
