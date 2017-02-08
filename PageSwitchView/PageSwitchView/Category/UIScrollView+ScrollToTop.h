//
//  UIScrollView+ScrollTop.h
//  RefreshDataArray
//
//  Created by YLCHUN on 2017/1/20.
//  Copyright © 2017年 YLCHUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ScrollToTop)

-(void)scrollToTopWithAnimatie:(BOOL)animate completion:(void(^)())completion;
-(void)scrollToTopWithTime:(double)time animatie:(BOOL)animate completion:(void(^)())completion;

@end
