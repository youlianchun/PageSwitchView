//
//  SearchView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView
@property (nonatomic, readonly) UIView *animateView;
-(void)doShowWithAnimate:(BOOL)animate;
-(void)doHideWithAnimate:(BOOL)animate;
@end
