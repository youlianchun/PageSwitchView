//
//  ViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "ViewController2tab.h"
#import "SimplePageSwitchView.h"
#import "TableViewController.h"
#import "TwoScrollViewController.h"
#import "SimpleViewController.h"
#import "ScrollViewController.h"
#import "NavigationBarTitleView.h"
#import "PSViewController.h"

@interface ViewController2tab()<SimplePageSwitchViewControllerProtocol>
@end

@implementation ViewController2tab

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"subView";
    self.maxTitleCount = 6;
    self.titleSelectedStyle = SegmentSelectedStyleSubscript;
    self.selectedTitleColor = [UIColor blueColor];
    self.hoverTitleBar = YES;
//    [self layoutPageSwitchViewWithinserts:UIEdgeInsetsMake(0, 0, -49, 0)];

    [self reload];
    
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [wself setNumber:1 atIndex:2];
//        [wself reload];

    });
}

- (NSArray<PageSwitchItem*> *)pageSwitchItems {
//    PageSwitchItem *item1 = [PageSwitchItem itemWithTitle:@"今日" vcClsKey:@"TableViewController" viewKey:@"tableView"];
//    PageSwitchItem *item2 = [PageSwitchItem itemWithTitle:@"看台" key:@"PSViewController.pageSwitchView"];
//    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"活动" key:@"SimpleViewController"];
//    PageSwitchItem *item4 = [PageSwitchItem itemWithTitle:@"4" page:^(DoReturn doReturn) {
//        TableViewController *vc = [[TableViewController alloc]init];
//        vc.title = @"4";
//        doReturn(vc, vc.tableView);
//    }];
    PageSwitchItem *item0 = [PageSwitchItem itemWithTitle:@"约战" key:@"PageSwitchItemViewController"];
    PageSwitchItem *item1 = [PageSwitchItem itemWithTitle:@"挑战" key:@"PSViewController.pageSwitchView"];
    PageSwitchItem *item2 = [PageSwitchItem itemWithTitle:@"战报" key:@"PageSwitchItemViewController"];
    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"看台" key:@"PageSwitchItemViewController"];
    PageSwitchItem *item4 = [PageSwitchItem itemWithTitle:@"天梯" key:@"PageSwitchItemViewController"];
    PageSwitchItem *item5 = [PageSwitchItem itemWithTitle:@"天梯" key:@"PageSwitchItemViewController"];


    return @[item0,item1,item2,item3,item4,item5];
}

@end
