//
//  PagingSwitchItem.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/9/23.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PageViewControllerProtocol.h"


typedef void (^DoReturn)(UIViewController*viewController, UIView* view);

@interface PageSwitchItem : NSObject

@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, readonly) void(^newPage)(DoReturn doReturn);

@property (nonatomic, readonly) UIView* contentView;

@property (nonatomic, readonly) BOOL didLoad;

@property (nonatomic, readonly) UIViewController<PageViewControllerProtocol> *contentViewController;


+(PageSwitchItem*)itemWithTitle:(NSString*)title page:(void(^)(DoReturn doReturn))newPage ;

-(instancetype)init NS_UNAVAILABLE;

@end
