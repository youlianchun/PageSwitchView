//
//  PageViewControllerProtocol.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/11/29.
//  Copyright © 2016年 ylchun. All rights reserved.
//

@protocol PageViewControllerProtocol<NSObject>
@optional

/**
 viewController.view在加载到框架上时候调用（在viewDidLoad之后调用）
 */
-(void)viewDidAdjustRect;

/**
  当前页面在滑动时候或者切换到其页面之后
 */
-(void)pageScrolling;


/**
 当前页面切换显示完成时候
 */
-(void)viewDidDisplayWhenSwitch;
/**
 当前页面切换消失完成时候
 */
-(void)viewDidEndDisplayWhenSwitch;
@end
