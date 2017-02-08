//
//  UIContentView.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/11/30.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIContentView : UIView
/**
 清空所有子视图
 */

@property (nonatomic,weak) id mountObject;
-(void)clearSubviews;

-(void)setContent:(UIView*)content;

-(id)content;

@end
