//
//  PageSwitchViewController.h
//  PageSwitchView
//
//  Created by YLCHUN on 2016/12/4.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageSwitchView.h"

@interface PageSwitchViewController : UIViewController
@property (nonatomic, readonly) PageSwitchView *pageSwitchView;
-(void)reload;
@end
