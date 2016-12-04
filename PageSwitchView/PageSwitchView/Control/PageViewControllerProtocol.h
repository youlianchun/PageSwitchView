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
-(void)pageScrolling;
@end
