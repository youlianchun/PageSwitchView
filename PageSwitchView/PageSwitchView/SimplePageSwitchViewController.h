//
//  PageSwitchViewController.h
//  PageSwitchView
//
//  Created by YLCHUN on 2016/12/4.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimplePageSwitchView.h"

@interface SimplePageSwitchViewController : UIViewController
@property (nonatomic, readonly) SimplePageSwitchView *pageSwitchView;
-(void)reload;
@end
