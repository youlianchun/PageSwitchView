//
//  PSViewController.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/5.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageSwitchView.h"
#import "RefresBoleDataArray.h"

@interface PSViewController : UIViewController
@property (nonatomic) PageSwitchView *pageSwitchView;
@property (nonatomic,readonly) RefresBoleDataArray *dataArray;

@end
