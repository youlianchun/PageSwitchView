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

@interface ViewController2tab()<SimplePageSwitchViewDelegate, SimplePageSwitchViewDataSource>
@property (nonatomic) SimplePageSwitchView *pageSwitchView;
@end

@implementation ViewController2tab

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"subView";

    self.pageSwitchView = [[SimplePageSwitchView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.pageSwitchView];
//    self.pageSwitchView.hoverTitleBar = YES;
    
    [self.pageSwitchView layoutWithinserts:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.pageSwitchView.delegate = self;
    self.pageSwitchView.dataSource = self;
    [self.pageSwitchView reloadData];
    
//    __weak typeof(self) wself = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [wself.pageSwitchView switchNewPageWithNewIndex:2];
//        [wself.pageSwitchView switchNewPageWithTitle:@"4"];
//    });
}


-(BOOL)adaptTitleWidthInPageSwitchView:(SimplePageSwitchView *)pageSwitchView {
    return YES;
}

-(NSArray<PageSwitchItem *> *)pageSwitchItemsInPageSwitchView:(SimplePageSwitchView *)pageSwitchView {
    PageSwitchItem *item1 = [PageSwitchItem itemWithTitle:@"11" key:@"TwoScrollViewController.twoScrollView"];
    PageSwitchItem *item2 = [PageSwitchItem itemWithTitle:@"2" key:@"PSViewController.pageSwitchView"];
    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"333333" key:@"SimpleViewController"];
    PageSwitchItem *item4 = [PageSwitchItem itemWithTitle:@"4" vcClsKey:@"ScrollViewController" viewKey:@"scrollView"];
    PageSwitchItem *item5 = [PageSwitchItem itemWithTitle:@"55" vcClsKey:@"TableViewController" viewKey:@"tableView"];
    PageSwitchItem *item6 = [PageSwitchItem itemWithTitle:@"666" vcClsKey:@"TableViewController" viewKey:@"tableView"];
    PageSwitchItem *item7 = [PageSwitchItem itemWithTitle:@"7" page:^(DoReturn doReturn) {
        TableViewController *vc = [[TableViewController alloc]init];
        vc.title = @"7";
        doReturn(vc, vc.tableView);
    }];
    return @[item1,item2,item3,item4,item5,item6,item7];
}


@end
