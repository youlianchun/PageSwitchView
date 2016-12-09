//
//  PageViewControllerProtocol.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/11/29.
//  Copyright © 2016年 ylchun. All rights reserved.
//

@class PageSwitchItem;

@protocol PageViewControllerProtocol<NSObject>
@optional
//+ (PageSwitchItem *)pageSwitchItem;

-(void)viewDidAdjustRect;

/**
  当前页面在滑动时候或者切换到其页面之后
 */
-(void)pageScrolling;


/**
 当前页面显示完成时候
 */
-(void)viewDidDisplay;
/**
 当前页面消失完成时候
 */
-(void)viewDidEndDisplay;
@end
