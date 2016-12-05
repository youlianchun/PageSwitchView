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

+(PageSwitchItem*)itemWithTitle:(NSString*)title vcCls:(Class)vcCls viewKey:(NSString*)key;

+(PageSwitchItem*)itemWithTitle:(NSString*)title vcClsKey:(NSString*)clsKey viewKey:(NSString*)key;


/**
 创建PageSwitchItem

 @param title 标题
 @param key “类名.属性名”；默认UIViewController.view
 @return PageSwitchItem
 */
+(PageSwitchItem*)itemWithTitle:(NSString*)title key:(NSString*)key;

-(instancetype)init NS_UNAVAILABLE;

@end
