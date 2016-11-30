//
//  _TwoScrollView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/11/30.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "TwoScrollView.h"

@interface TwoScrollView ()

@property (nonatomic, assign) BOOL haveHeader;

@property (nonatomic, copy) NSString* panGestureRecognizerGroupTag;

@property(nonatomic,weak) id<UIScrollViewDelegate> delegate;

@end
