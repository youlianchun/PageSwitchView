//
//  PageSwitchItemViewController.h
//  PageSwitchView
//
//  Created by YLCHUN on 2016/12/4.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewControllerProtocol.h"
#import "PageSwitchItem.h"

@interface PageSwitchItemViewController : UIViewController

+ (PageSwitchItem*)pageSwitchItemWithTitle:(NSString*)title;

@end
