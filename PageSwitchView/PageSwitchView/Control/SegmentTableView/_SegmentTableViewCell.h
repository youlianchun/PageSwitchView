//
//  _SegmentTableViewCell.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/9.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _SegmentTableViewCell : UITableViewCell
@property (nonatomic) NSInteger number;//小于0时候显示红点不显示数字，等于0时候不显示红点，大于0时候显示红点和数字
@end
